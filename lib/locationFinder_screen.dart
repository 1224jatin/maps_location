import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_location/map_services.dart';
import 'package:maps_location/place_model.dart';
import 'package:maps_location/route_services.dart';

import 'constents.dart';
import 'location_services.dart';

class LocationfinderScreen extends StatefulWidget {
  const LocationfinderScreen({super.key});

  @override
  State<LocationfinderScreen> createState() => _LocationfinderScreen();
}

class _LocationfinderScreen extends State<LocationfinderScreen> {
  Position? currentLocation;
  PlaceModel? destination;
  List<LatLng> routePoints = [];
  final TextEditingController searchController = TextEditingController();
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Finder"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search Location",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (searchController.text.isNotEmpty) {
                        final place = await MapServices().searchPlace(searchController.text);
                        if (place != null) {
                          setState(() {
                            destination = place;
                            mapController.move(
                              LatLng(double.parse(place.lat), double.parse(place.long)),
                              13.0,
                            );
                          });
                        }
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 350,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FlutterMap(
                  mapController: mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(28.6139, 77.2090),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: ApiUrl.osmTile,
                      userAgentPackageName: 'com.example.maps_location',
                    ),
                    if (currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(currentLocation!.latitude, currentLocation!.longitude),
                            child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                          ),
                        ],
                      ),
                    if (destination != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(double.parse(destination!.lat), double.parse(destination!.long)),
                            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    if (routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            color: Colors.blue,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 10),
                          Text("Latitude : ${currentLocation?.latitude ?? destination?.lat ?? '28.6139'}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          const SizedBox(width: 10),
                          Text("Longitude : ${currentLocation?.longitude ?? destination?.long ?? '77.2090'}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.route),
                          const SizedBox(width: 10),
                          Text("Route: ${routePoints.isNotEmpty ? 'Calculated' : 'Not Set'}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final pos = await LocationServices().currentLocation();
                        setState(() {
                          currentLocation = pos;
                          mapController.move(LatLng(pos.latitude, pos.longitude), 13.0);
                        });
                      },
                      icon: const Icon(Icons.my_location),
                      label: const Text("My Location"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (currentLocation != null && destination != null) {
                          final points = await RouteServices().getRout(
                            LatLng(currentLocation!.latitude, currentLocation!.longitude),
                            LatLng(double.parse(destination!.lat), double.parse(destination!.long)),
                          );
                          print(points.toString());
                          setState(() {
                            routePoints = points;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please set both My Location and Destination")),
                          );
                        }
                      },
                      icon: const Icon(Icons.alt_route),
                      label: const Text("Show Route"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
