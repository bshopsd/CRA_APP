import 'package:geocoding/geocoding.dart';

class LocationHelper {
  static final Map<int, String> _addressCache = {};

  static Future<String> getAddress(double lat, double lng, int id) async {
    if (_addressCache.containsKey(id)) return _addressCache[id]!;

    if (lat == 0.0 && lng == 0.0) {
      print("Invalid coordinates for complaint ID $id");
      return 'Unknown location';
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
        _addressCache[id] = address;
        return address;
      }
    } catch (e) {
      print("Geocoding error for ID $id: $e");
    }

    return 'Unknown location';
  }
}
