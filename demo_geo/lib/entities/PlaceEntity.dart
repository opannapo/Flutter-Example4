import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_geo/utils/DistanceHelper.dart';
import 'package:geolocator/geolocator.dart';

class PlaceEntity {
  String id;
  String name;
  String pic;
  int type;
  bool status;
  GeoPoint geoPoint;
  double distance;

  PlaceEntity(
      {this.id,
      this.name,
      this.pic,
      this.type,
      this.status,
      this.geoPoint,
      this.distance});

  factory PlaceEntity.fromSnapshot(
      Position position, DocumentSnapshot snapshot) {
    var entity = snapshot;

    Position userPos = position;
    GeoPoint geoPoint = entity['geopoint'] as GeoPoint;

    double lat1 = userPos.latitude;
    double lon1 = userPos.longitude;
    double lat2 = geoPoint.latitude;
    double lon2 = geoPoint.longitude;
    double distance = DistanceHelper.distanceInMeter(lat1, lon1, lat2, lon2);

    return PlaceEntity(
        id: entity.documentID,
        name: entity['name'] as String,
        pic: entity['pic'] as String,
        type: entity['type'] as int,
        status: entity['status'] as bool,
        geoPoint: entity['geoPoint'] as GeoPoint,
        distance: distance);
  }

  @override
  String toString() {
    return 'PlaceEntity{id: $id, name: $name, pic: $pic, type: $type, status: $status, geoPoint: $geoPoint, distance: $distance}';
  }
}
