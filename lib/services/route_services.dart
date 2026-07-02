import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../constents.dart';

class RouteServices {
  Future<List<LatLng>> getRout(LatLng start, LatLng end) async {
    // OSRM Format: /lon,lat;lon,lat?overview=full&geometries=geojson
    final url = Uri.parse(
        "${ApiUrl.osrmRoute}/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson");

    try {
      print("OSRM Routing Request: $url");
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final List coordinates = data["routes"][0]["geometry"]["coordinates"];
          // OSRM returns [longitude, latitude]
          return coordinates.map((e) => LatLng(e[1].toDouble(), e[0].toDouble())).toList();
        }
      } else {
        print("OSRM Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Routing error: $e");
    }
    return [];
  }
}
