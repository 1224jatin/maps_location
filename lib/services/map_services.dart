import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_location/models/place_model.dart';
import '../constents.dart';

class MapServices {
  // Nominatim requires a valid, unique User-Agent to avoid 403 errors.
  // Using a more specific and unique User-Agent.
  final Map<String, String> headers = {
    "User-Agent": "FlutterMapsLocationApp_Unique_anandita_9464",
    "Accept": "application/json",
  };

  // Search suggestions using Nominatim
  Future<List<PlaceModel>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];
    
    // Using jsonv2 for better structure and added addressdetails
    final url = Uri.parse("${ApiUrl.nominatimSearch}?q=${Uri.encodeComponent(query)}&format=jsonv2&limit=5&addressdetails=1");

    try {
      print("Nominatim Search Request: $url");
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print("Nominatim Found ${data.length} results");
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        print("Nominatim 403: Access Denied. User-Agent might be blocked or policy violated.");
        print("Response Body: ${response.body}");
      } else {
        print("Nominatim API error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Nominatim Search exception: $e");
    }
    return [];
  }

  // Reverse Geocoding using Nominatim
  Future<String> reverseGeocode(double lat, double lon) async {
    final url = Uri.parse("${ApiUrl.nominatimReverse}?format=jsonv2&lat=$lat&lon=$lon");

    try {
      print("Nominatim Reverse Request: $url");
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["display_name"] ?? "Unknown Location";
      } else {
        print("Nominatim Reverse error: ${response.statusCode}");
      }
    } catch (e) {
      print("Reverse geocode error: $e");
    }
    return "Unknown Location";
  }
}
