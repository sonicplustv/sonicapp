part of 'settings_cubit.dart';

class SettingsState {
  final String setting;
  final bool isDemo;

  SettingsState({required this.setting, this.isDemo = false});

  SettingsState copyWith({
    final String? setting,
    final bool? isDemo,
  }) {
    return SettingsState(
      setting: setting ?? this.setting,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}
