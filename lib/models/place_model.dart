class PlaceModel {
  late final String name;
  late final String lat;
  late final String long;

  PlaceModel({
    required this.name,
    required this.lat,
    required this.long,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      // Nominatim returns 'display_name' and 'lon'
      name: json["display_name"] ?? (json["name"] ?? ""),
      lat: json["lat"] as String,
      long: json["lon"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "lat": lat,
      "long": long,
    };
  }
}
