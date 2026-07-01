class ApiUrl {
  static const String osmTile = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  
  // Geocoding (Nominatim)
  static const String nominatimSearch = "https://nominatim.openstreetmap.org/search";
  static const String nominatimReverse = "https://nominatim.openstreetmap.org/reverse";

  // Routing (OSRM - No Key Required)
  static const String osrmRoute = "https://router.project-osrm.org/route/v1/driving";
}
