import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_location/place_model.dart';

import 'constents.dart';

class MapServices {
  Future<PlaceModel?> searchPlace(String place) async {
    final url = Uri.parse("${ApiUrl.search}?q=$place&format=json");

    final response = await http.get(
      url,
      headers: {
        "User-Agent" : "MapsLocationApp/1.0 (contact@example.com)",

      }

    );

    if(response.statusCode == 200 ){
      final data = jsonDecode(response.body);

      if(data.isEmpty) return null;

      return PlaceModel.fromJson(data.first);


    }
    return null;

  }
}