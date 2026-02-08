import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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
    // 1. Load the marker frame
    final ByteData markerData = await rootBundle.load(markerPath);
    final ui.Codec markerCodec = await ui.instantiateImageCodec(
      markerData.buffer.asUint8List(),
      targetWidth: size.round(),
      targetHeight: size.round(),
    );
    final ui.FrameInfo markerFrame = await markerCodec.getNextFrame();
    final ui.Image markerImage = markerFrame.image;

    // 2. Prepare Canvas
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);
    final double markerWidth = markerImage.width.toDouble();
    final double markerHeight = markerImage.height.toDouble();

    // 3. Draw marker frame
    canvas.drawImage(markerImage, ui.Offset.zero, ui.Paint());

    // 4. Load & Draw Doctor Image if available
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final Uint8List imageBytes = await _fetchImage(imageUrl);
        final ui.Codec imageCodec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: (markerWidth * 0.75).round(),
          targetHeight: (markerWidth * 0.75).round(),
        );
        final ui.Image doctorImage = (await imageCodec.getNextFrame()).image;

        // Clip to circle
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
        // If image loading fails, we just keep the base marker
        debugPrint('Error loading doctor avatar for marker: $e');
      }
    }

    // 5. Convert to Uint8List
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

  Future<Uint8List> _fetchImage(String url) async {
    if (url.startsWith('http')) {
      try {
        // Using DefaultCacheManager to get the file from cache or download it
        final file = await DefaultCacheManager().getSingleFile(url);
        return await file.readAsBytes();
      } catch (e) {
        debugPrint('CacheManager failed, falling back to simple http: $e');
        // Fallback to simple http if cache manager fails
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        } else {
          throw Exception('Failed to load image from network');
        }
      }
    } else {
      // Assume it's an asset if it doesn't start with http
      final ByteData data = await rootBundle.load(url);
      return data.buffer.asUint8List();
    }
  }
}

class LocationServicesException implements Exception {}

class LocationPermissionException implements Exception {}
