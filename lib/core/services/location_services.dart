import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationServices {
  Location currentLocation = Location();

  Future<void> checkAndRequestLocationService() async {
    bool serviceEnabled;

    serviceEnabled = await currentLocation.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await currentLocation.requestService();
      if (!serviceEnabled) {
        throw LocationServicesException();
      }
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    PermissionStatus permissionGranted;
    permissionGranted = await currentLocation.hasPermission();
    if (permissionGranted == PermissionStatus.deniedForever) {
      throw LocationPermissionException();
    }
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await currentLocation.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw LocationPermissionException();
      }
    }
  }

  void getRealTimeLocationUpdates(void Function(LocationData)? onData) async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    currentLocation.onLocationChanged.listen(onData);
  }

  Future<LocationData> getLocation() async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    return await currentLocation.getLocation();
  }

  Future<Uint8List> getImageFromRawData(String image, double width) async {
    var imageData = await rootBundle.load(image);
    var imageCodec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(
        imageData.offsetInBytes,
        imageData.lengthInBytes,
      ),
      targetWidth: width.round(),
    );

    var imageFrame = await imageCodec.getNextFrame();

    var imageByteData = await imageFrame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return imageByteData!.buffer.asUint8List(
      imageByteData.offsetInBytes,
      imageByteData.lengthInBytes,
    );
  }

  Future<Uint8List> getDoctorMarker({
    required String markerPath,
    required String? imageUrl,
    required double size,
  }) async {
    final ByteData markerData = await rootBundle.load(markerPath);
    final ui.Codec markerCodec = await ui.instantiateImageCodec(
      markerData.buffer.asUint8List(),
      targetWidth: size.round(),
      targetHeight: size.round(),
    );
    final ui.FrameInfo markerFrame = await markerCodec.getNextFrame();
    final ui.Image markerImage = markerFrame.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);
    final double markerWidth = markerImage.width.toDouble();
    final double markerHeight = markerImage.height.toDouble();

    canvas.drawImage(markerImage, ui.Offset.zero, ui.Paint());

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final Uint8List imageBytes = await _fetchImage(imageUrl);
        final ui.Codec imageCodec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: (markerWidth * 0.75).round(),
          targetHeight: (markerWidth * 0.75).round(),
        );
        final ui.Image doctorImage = (await imageCodec.getNextFrame()).image;

        final double radius = doctorImage.width / 2;
        final ui.Offset center = ui.Offset(markerWidth / 2, markerWidth * 0.42);

        canvas.save();
        final ui.Path clipPath = ui.Path()
          ..addOval(ui.Rect.fromCircle(center: center, radius: radius));
        canvas.clipPath(clipPath);
        canvas.drawImage(
          doctorImage,
          ui.Offset(center.dx - radius, center.dy - radius),
          ui.Paint(),
        );
        canvas.restore();
      } catch (e) {
        debugPrint('Error loading doctor avatar for marker: $e');
      }
    }

    final ui.Picture picture = recorder.endRecording();
    final ui.Image finalImage = await picture.toImage(
      markerWidth.round(),
      markerHeight.round(),
    );
    final ByteData? byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> getClusterMarker({
    required int count,
    required bool isDark,
    required double size,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final center = ui.Offset(size / 2, size / 2);
    final radius = size / 2;

    final shadowPaint = ui.Paint()
      ..color = Colors.black.withValues(alpha: isDark ? 0.42 : 0.18)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 14);

    canvas.drawCircle(center.translate(0, 3), radius * 0.72, shadowPaint);

    final outerPaint = ui.Paint()
      ..color = isDark ? const Color(0xFF2563EB) : const Color(0xFF0165FC);
    canvas.drawCircle(center, radius * 0.72, outerPaint);

    final innerPaint = ui.Paint()
      ..color = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FBFF);
    canvas.drawCircle(center, radius * 0.49, innerPaint);

    final highlightPaint = ui.Paint()
      ..color = Colors.white.withValues(alpha: isDark ? 0.14 : 0.3);
    canvas.drawCircle(
      ui.Offset(center.dx - radius * 0.18, center.dy - radius * 0.18),
      radius * 0.14,
      highlightPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: count > 99 ? '99+' : '$count',
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF0165FC),
          fontSize: count > 99 ? size * 0.16 : size * 0.19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      ui.Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.round(), size.round());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<Uint8List> _fetchImage(String url) async {
    if (url.startsWith('http')) {
      try {
        final file = await DefaultCacheManager().getSingleFile(url);
        return await file.readAsBytes();
      } catch (e) {
        debugPrint('CacheManager failed, falling back to simple http: $e');
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        } else {
          throw Exception('Failed to load image from network');
        }
      }
    } else {
      final ByteData data = await rootBundle.load(url);
      return data.buffer.asUint8List();
    }
  }
}

class LocationServicesException implements Exception {}

class LocationPermissionException implements Exception {}
