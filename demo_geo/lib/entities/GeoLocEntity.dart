import 'package:geolocator/geolocator.dart';

class GeoLocEntity {
  Position position;
  Placemark placemark;

  GeoLocEntity({this.position, this.placemark});
}
