import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position?> getCurrentPosition() async {
  // Ask location permission
  final status = await Permission.location.request();
  if (!status.isGranted) return null;

  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,       // we have to fix this issue with adding a attribue
    );
  } catch (e) {
    return null;
  }
}
