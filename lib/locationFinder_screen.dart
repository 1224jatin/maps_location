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
  String currentAddress = "Not set";
  PlaceModel? destination;
  List<LatLng> routePoints = [];
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
              Autocomplete<PlaceModel>(
                displayStringForOption: (PlaceModel option) => option.name,
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<PlaceModel>.empty();
                  }
                  return await MapServices().searchPlaces(textEditingValue.text);
                },
                onSelected: (PlaceModel selection) {
                  setState(() {
                    destination = selection;
                    mapController.move(
                      LatLng(double.parse(selection.lat), double.parse(selection.long)),
                      13.0,
                    );
                  });
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onFieldSubmitted,
                    decoration: InputDecoration(
                      hintText: "Search Destination",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.my_location, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Current: $currentAddress",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Destination: ${destination?.name ?? 'Not set'}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.route, color: Colors.green),
                          const SizedBox(width: 10),
                          Text("Route: ${routePoints.isNotEmpty ? 'Points Loaded' : 'Not Calculated'}"),
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
                        final address = await MapServices().reverseGeocode(pos.latitude, pos.longitude);
                        setState(() {
                          currentLocation = pos;
                          currentAddress = address;
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
                          setState(() {
                            routePoints = points;
                            if (points.isNotEmpty) {
                              // Optional: Fit map to show both points
                              // mapController.fitCamera(...) 
                            }
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
