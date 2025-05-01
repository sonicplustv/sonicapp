part of 'helpers.dart';

void changeDeviceOrient() {
  //change portrait mobile
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

void changeDeviceOrientBack() {
  //change portrait mobile
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}
