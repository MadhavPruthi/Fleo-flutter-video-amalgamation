import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static final cameraPermission = PermissionState(Permission.camera);
  static final microphonePermission = PermissionState(Permission.microphone);

  getActiveStatus() {
    return cameraPermission._permissionStatus == PermissionStatus.granted &&
        microphonePermission._permissionStatus == PermissionStatus.granted;
  }

  Future<bool> requestPermission() async{
    await cameraPermission.requestPermission();
    await microphonePermission.requestPermission();

    return getActiveStatus();
  }
}

class PermissionState {
  PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  Future<void> requestPermission() async {
    final status = await _permission.request();
    _permissionStatus = status;
  }
}
