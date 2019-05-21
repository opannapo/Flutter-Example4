import 'dart:math';

class DistanceHelper {
  static double _degreesToRadians(degress) {
    return degress * pi / 180;
  }

  static double distanceInMeter(lat1, lon1, lat2, lon2) {
    var earthRadiusKm = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return (earthRadiusKm * c) * 1000; //1000 : 1km
  }
}
