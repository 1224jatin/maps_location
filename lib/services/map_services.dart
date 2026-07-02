import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_location/models/place_model.dart';
import '../constents.dart';

class MapServices {
  // Nominatim requires a valid, unique User-Agent to avoid 403 errors.
  final Map<String, String> headers = {
    "User-Agent": "FlutterMapsLocationApp/1.2 (anandita9464@example.com)",
    "Accept": "application/json",
  };

  // Search suggestions using Nominatim
  Future<List<PlaceModel>> searchPlaces(String query) async {
    if (query.isEmpty) return [];
    
    // Properly encode the query
    final url = Uri.parse("${ApiUrl.nominatimSearch}?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1");

    try {
      print("Fetching search results for: $query");
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print("Found ${data.length} results");
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        print("Nominatim 403: Access Denied. Check User-Agent or Policy.");
      } else {
        print("Search API error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Search exception: $e");
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
