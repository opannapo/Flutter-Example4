import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_geo/entities/GeoLocEntity.dart';
import 'package:demo_geo/entities/PlaceEntity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final BehaviorSubject<List<PlaceEntity>> _placeEntitySc =
      BehaviorSubject<List<PlaceEntity>>();
  final BehaviorSubject<GeoLocEntity> _geoLocEntitySc =
      BehaviorSubject<GeoLocEntity>();

  BehaviorSubject<List<PlaceEntity>> get placeEntitySc => _placeEntitySc;

  BehaviorSubject<GeoLocEntity> get geoLocEntitySc => _geoLocEntitySc;

  void dispose() {
    _placeEntitySc.close();
    _geoLocEntitySc.close();
  }

  Future<Position> initPlatformState() async {
    Position position;
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();

    if (geolocationStatus == GeolocationStatus.granted) {
      try {
        final Geolocator geolocator = Geolocator()
          ..forceAndroidLocationManager = true;
        await geolocator
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((val) async {
          position = val;
          geoLocEntitySc.sink.add(new GeoLocEntity(position: position));
          await _doReqAroundMe(position);
          await _doGetPlaceMark(position);
          await _listenLocationUpdate(geolocator);
        });
      } catch (PlatformException) {
        print(PlatformException);
      }
    } else {
      print('wikwikwik');
    }

    return position;
  }

  Future<Position> _doReqAroundMe(Position position) {
    print('$this _doReqAroundMe ${position}');
    double lat = 0.00001;
    double lon = 0.00001;
    double radius = 1000; //meters

    double lowerLat = position.latitude - (lat * radius);
    double lowerLon = position.longitude - (lat * radius);
    double greaterLat = position.latitude + (lat * radius);
    double greaterLon = position.longitude + (lat * radius);

    GeoPoint lesserGeoPoint = new GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeoPoint = new GeoPoint(greaterLat, greaterLon);

    var q = Firestore.instance
        .collection('tbl_places')
        .where('geopoint', isGreaterThanOrEqualTo: lesserGeoPoint)
        .where('geopoint', isLessThanOrEqualTo: greaterGeoPoint)
        .orderBy('geopoint', descending: true);

    q.snapshots().listen((querySnapshot) {
      if (querySnapshot.documentChanges.length == 0) {
        print('No Result');
        placeEntitySc.sink.add(new List());
      }

      querySnapshot.documentChanges.forEach((val) {
        PlaceEntity place =
            new PlaceEntity.fromSnapshot(position, val.document);
        print('$this ${place.toString()}');

        if (val.type == DocumentChangeType.added) {
          _doAddNew(place);
        } else if (val.type == DocumentChangeType.modified) {
          _doUpdate(place);
        } else if (val.type == DocumentChangeType.removed) {
          _doRemove(place);
        }
      });
    });
  }

  void _doAddNew(PlaceEntity p) {
    print('$this _doAddNew ${p.toString()}');
    if (placeEntitySc.value == null) {
      if (placeEntitySc.isClosed) return;
      placeEntitySc.sink.add(new List());
    }

    List<PlaceEntity> pls = placeEntitySc.value;
    pls.add(p);

    if (placeEntitySc.isClosed) return;
    return _sort(pls);
  }

  void _doUpdate(PlaceEntity p) {
    if (placeEntitySc.value == null) {
      if (placeEntitySc.isClosed) return;
      placeEntitySc.sink.add(new List());
    }

    List<PlaceEntity> pls = placeEntitySc.value;
    int idx = pls.indexWhere((cResult) => cResult.id == p.id);
    pls[idx] = p;

    if (placeEntitySc.isClosed) return;
    return _sort(pls);
  }

  void _doRemove(PlaceEntity p) {
    if (placeEntitySc.value == null) {
      if (placeEntitySc.isClosed) return;
      placeEntitySc.sink.add(new List());
    }

    List<PlaceEntity> pls = placeEntitySc.value;
    int idx = pls.indexWhere((cResult) => cResult.id == p.id);
    pls.removeAt(idx);

    if (placeEntitySc.isClosed) return;
    return _sort(pls);
  }

  void _sort(List<PlaceEntity> pls) {
    pls.sort((PlaceEntity a, PlaceEntity b) {
      return a.distance.compareTo((b.distance));
    });

    placeEntitySc.sink.add(pls);
  }

  Future<Placemark> _doGetPlaceMark(Position position) async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark pmTmp;
    placemark.forEach((pm) {
      pmTmp = pm;
    });

    geoLocEntitySc.sink
        .add(new GeoLocEntity(position: position, placemark: pmTmp));
  }

  Future _listenLocationUpdate(Geolocator geoLocator) {
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
    geoLocator
        .getPositionStream(locationOptions)
        .listen((Position positionUpdate) {
      _doGetPlaceMark(positionUpdate);
    });
  }
}
