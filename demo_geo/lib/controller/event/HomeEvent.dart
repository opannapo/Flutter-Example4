import 'package:demo_geo/controller/bloc/HomeBloc.dart';
import 'package:demo_geo/utils/PermissionHelper.dart';
import 'package:demo_geo/views/Home.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class HomeEvent implements PermissionCallback {
  HomeState actionState();

  HomeState get _state => actionState();

  HomeBloc get _bloc => _state.bloc;

  PermissionHelper get _permissionHelper => _state.permissionHelper;

  @override
  void onResultRequest(Map<PermissionGroup, PermissionStatus> result) {
    if (result.containsKey(PermissionGroup.locationWhenInUse)) {
      if (result[PermissionGroup.locationWhenInUse] ==PermissionStatus.granted) {
        _reqLocation();
      }
    } else {
      print('NOTHING...');
    }
  }

  @override
  void onResultCheck(PermissionStatus result) {
    if (result == PermissionStatus.granted) {
      _reqLocation();
    } else {
      _permissionHelper.request([PermissionGroup.locationWhenInUse]);
    }
  }

  void eventFirstLoad() {
    _permissionHelper.check(PermissionGroup.locationWhenInUse);
  }

  Future _reqLocation() async {
    await _bloc.initPlatformState().then((val) {
      print(
          '$this _reqLocation() position ${val?.latitude} : ${val?.longitude}');
      return val;
    });
  }
}
