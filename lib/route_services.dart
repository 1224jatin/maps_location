import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'constents.dart';

class RouteServices {
  Future<List<LatLng>> getRout(LatLng start, LatLng end) async {
    // OSRM Format: /route/v1/driving/lon,lat;lon,lat?overview=full&geometries=geojson
    final url = Uri.parse(
        "${ApiUrl.osrmRoute}/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson");

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final List coordinates = data["routes"][0]["geometry"]["coordinates"];
          // OSRM returns [lon, lat]
          return coordinates.map((e) => LatLng(e[1].toDouble(), e[0].toDouble())).toList();
        }
      } else {
        print("OSRM Error: ${response.body}");
      }
    } catch (e) {
      print("Routing error: $e");
    }
    return [];
  }
}
