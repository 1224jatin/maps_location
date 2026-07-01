import 'package:geolocator/geolocator.dart';

class LocationServices{
  Future<Position> currentLocation() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
  }


}

/*class LocationServices {
  Future<bool> requestPermission() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return false;
      }
      if (permission == LocationPermission.deniedForever){
        return false;
      }
      return false;
    }

  }
  Future<Position?>  getCurrentLocation() async {
    final hasPermission = await requestPermission();
    if(!hasPermission) return null ;

    try{
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
    } catch (e){
      print(" error getting Location $e");
      return null ;
    }



  }
  double calculateDistance(LatLng start , LatLng end){
    return const Distance().as(
        LengthUnit.Kilometer,
        start,
        end);

  }
}*/
