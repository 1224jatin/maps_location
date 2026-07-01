import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../constents.dart';

class RouteServices {
  Future<List<LatLng>> getRout(
    LatLng state ,
  LatLng end ,) async {
    final url = Uri.parse(
        "${ApiUrl.route}/${state.longitude},${state.latitude};${end.longitude},${end.latitude}?overview=false");

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    List coordinates = data["routes"][0]["geometry"]["coordinates"];

    return coordinates.map((e) => LatLng(e[1], e[0])).toList();

  }

}