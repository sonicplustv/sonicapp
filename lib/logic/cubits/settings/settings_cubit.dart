import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../helpers/helpers.dart';

part 'settings_state.dart';

const platform = MethodChannel('main_activity_channel');

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(setting: "null"));

  void updateStatusAccount(bool isDemo) {
    if (isDemo) {
      changeDeviceOrient();
    } else {
      changeDeviceOrientBack();
    }
    emit(state.copyWith(isDemo: isDemo));
  }

  void getSettingsCode() async {
    try {
      String data = await platform.invokeMethod('getData');
      debugPrint("DATA: $data");

      emit(state.copyWith(setting: data));
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}
