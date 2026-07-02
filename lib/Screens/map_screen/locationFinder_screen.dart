import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_location/services/map_services.dart';
import 'package:maps_location/models/place_model.dart';
import 'package:maps_location/services/route_services.dart';

import '../../constents.dart';
import '../../services/location_services.dart';

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
  
  bool isSearching = false;
  bool isRouting = false;
  List<PlaceModel> searchResults = [];

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Manual Suggestion Search (More reliable than Autocomplete overlay)
              TextField(
                onChanged: (value) async {
                  if (value.length > 2) {
                    setState(() => isSearching = true);
                    final results = await MapServices().searchPlaces(value);
                    setState(() {
                      searchResults = results;
                      isSearching = false;
                    });
                  } else {
                    setState(() => searchResults = []);
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search Destination",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: isSearching 
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              // Suggestions List displayed directly in the column
              if (searchResults.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchResults.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final place = searchResults[index];
                        return ListTile(
                          title: Text(place.name, style: const TextStyle(fontSize: 14)),
                          onTap: () {
                            setState(() {
                              destination = place;
                              searchResults = [];
                              mapController.move(
                                LatLng(double.parse(place.lat), double.parse(place.long)),
                                13.0,
                              );
                            });
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 15),
              
              // Map Container
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
              
              // Info Card
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
                              maxLines: 2,
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
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final pos = await LocationServices().currentLocation();
                          final address = await MapServices().reverseGeocode(pos.latitude, pos.longitude);
                          setState(() {
                            currentLocation = pos;
                            currentAddress = address;
                            mapController.move(LatLng(pos.latitude, pos.longitude), 13.0);
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Location Error: $e")),
                          );
                        }
                      },
                      icon: const Icon(Icons.my_location),
                      label: const Text("My Location"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isRouting ? null : () async {
                        if (currentLocation != null && destination != null) {
                          setState(() => isRouting = true);
                          try {
                            final points = await RouteServices().getRout(
                              LatLng(currentLocation!.latitude, currentLocation!.longitude),
                              LatLng(double.parse(destination!.lat), double.parse(destination!.long)),
                            );
                            setState(() {
                              routePoints = points;
                              isRouting = false;
                            });
                            if (points.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No route found between these locations")),
                              );
                            }
                          } catch (e) {
                            setState(() => isRouting = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Routing Error: $e")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please set both My Location and Destination")),
                          );
                        }
                      },
                      icon: isRouting 
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.alt_route),
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
