import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_location/place_model.dart';
import 'constents.dart';

class MapServices {
  final Map<String, String> headers = {
    "User-Agent": "MapsLocationApp/1.0 (contact@example.com)",
  };

  // Search suggestions using Nominatim
  Future<List<PlaceModel>> searchPlaces(String query) async {
    final url = Uri.parse("${ApiUrl.nominatimSearch}?q=$query&format=json&limit=5&addressdetails=1");

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Search error: $e");
    }
    return [];
  }

  // Reverse Geocoding using Nominatim
  Future<String> reverseGeocode(double lat, double lon) async {
    final url = Uri.parse("${ApiUrl.nominatimReverse}?format=json&lat=$lat&lon=$lon");

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["display_name"] ?? "Unknown Location";
      }
    } catch (e) {
      print("Reverse geocode error: $e");
    }
    return "Unknown Location";
  }
}
