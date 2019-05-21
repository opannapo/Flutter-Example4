import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionCallback _callback;

  PermissionHelper(this._callback);

  void check(PermissionGroup permission) async {
    await PermissionHandler().checkPermissionStatus(permission).then((val) {
      _callback.onResultCheck(val);
    });
  }

  void request(List<PermissionGroup> permission) async {
    await PermissionHandler().requestPermissions(permission).then((val) {
      _callback.onResultRequest(val);
    });
  }
}

abstract class PermissionCallback {
  void onResultCheck(PermissionStatus result);

  void onResultRequest(Map<PermissionGroup, PermissionStatus> result);
}
