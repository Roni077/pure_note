import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/models/settings_state.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class SettingsViewModel extends Notifier<SettingsState> {
  late SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    
    final themeString = _prefs.getString('themeMode') ?? 'system';
    final ThemeMode theme;
    switch (themeString) {
      case 'light': theme = ThemeMode.light; break;
      case 'dark': theme = ThemeMode.dark; break;
      default: theme = ThemeMode.system;
    }
    
    final autoEmptyTrashDays = _prefs.getInt('autoEmptyTrashDays') ?? 30;
    final defaultSortOrder = _prefs.getString('defaultSortOrder') ?? 'updated_desc';
    final previewLength = _prefs.getInt('previewLength') ?? 5;
    final dynamicColor = _prefs.getBool('dynamicColor') ?? true;
    final enableAppLock = _prefs.getBool('enableAppLock') ?? false;
    final hideLockedNotesPreview = _prefs.getBool('hideLockedNotesPreview') ?? false;

    return SettingsState(
      themeMode: theme,
      autoEmptyTrashDays: autoEmptyTrashDays,
      defaultSortOrder: defaultSortOrder,
      previewLength: previewLength,
      dynamicColor: dynamicColor,
      enableAppLock: enableAppLock,
      hideLockedNotesPreview: hideLockedNotesPreview,
    );
  }

  void setThemeMode(ThemeMode mode) {
    _prefs.setString('themeMode', mode.name);
    state = state.copyWith(themeMode: mode);
  }

  void setAutoEmptyTrashDays(int days) {
    _prefs.setInt('autoEmptyTrashDays', days);
    state = state.copyWith(autoEmptyTrashDays: days);
  }

  void setDefaultSortOrder(String sortOrder) {
    _prefs.setString('defaultSortOrder', sortOrder);
    state = state.copyWith(defaultSortOrder: sortOrder);
  }

  void setPreviewLength(int length) {
    _prefs.setInt('previewLength', length);
    state = state.copyWith(previewLength: length);
  }

  void setDynamicColor(bool isDynamic) {
    _prefs.setBool('dynamicColor', isDynamic);
    state = state.copyWith(dynamicColor: isDynamic);
  }

  void setEnableAppLock(bool enable) {
    _prefs.setBool('enableAppLock', enable);
    state = state.copyWith(enableAppLock: enable);
  }

  void setHideLockedNotesPreview(bool hide) {
    _prefs.setBool('hideLockedNotesPreview', hide);
    state = state.copyWith(hideLockedNotesPreview: hide);
  }
}

final settingsProvider = NotifierProvider<SettingsViewModel, SettingsState>(() {
  return SettingsViewModel();
});
