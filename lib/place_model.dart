class PlaceModel {
  final String name;
  final String lat;
  final String long;

  PlaceModel({
    required this.name,
    required this.lat,
    required this.long,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json["display_name"] ?? json["name"] ?? "Unknown Location",
      lat: json["lat"].toString(),
      long: json["lon"]?.toString() ?? json["long"]?.toString() ?? "0.0",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "lat": lat,
      "long": long,
    };
  }
  
  @override
  String toString() => name;
}
