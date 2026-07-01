import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_location/models/place_model.dart';

import '../constents.dart';

class MapServices {
  Future<List<PlaceModel>> searchPlaces(String place) async {
    // Added limit=5 for faster dropdown response
    final url = Uri.parse("${ApiUrl.search}?q=${Uri.encodeComponent(place)}&format=json&limit=5");

    try {
      final response = await http.get(
        url,
        headers: {
          "User-Agent": "MapsLocationApp/1.0 (contact@example.com)",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => PlaceModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Search Error: $e");
    }
    return [];
  }

  Future<PlaceModel?> searchPlace(String place) async {
    final results = await searchPlaces(place);
    return results.isNotEmpty ? results.first : null;
  }
}
