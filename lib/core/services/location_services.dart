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
}

class LocationServicesException implements Exception {}

class LocationPermissionException implements Exception {}
