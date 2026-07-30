import 'package:flutter/material.dart';

class SettingsState {
  final ThemeMode themeMode;
  final int autoEmptyTrashDays; // 0 means never
  final String defaultSortOrder;
  final int previewLength;
  final bool dynamicColor;
  final bool enableAppLock;
  final bool hideLockedNotesPreview;

  const SettingsState({
    required this.themeMode,
    required this.autoEmptyTrashDays,
    required this.defaultSortOrder,
    required this.previewLength,
    required this.dynamicColor,
    required this.enableAppLock,
    required this.hideLockedNotesPreview,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    int? autoEmptyTrashDays,
    String? defaultSortOrder,
    int? previewLength,
    bool? dynamicColor,
    bool? enableAppLock,
    bool? hideLockedNotesPreview,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      autoEmptyTrashDays: autoEmptyTrashDays ?? this.autoEmptyTrashDays,
      defaultSortOrder: defaultSortOrder ?? this.defaultSortOrder,
      previewLength: previewLength ?? this.previewLength,
      dynamicColor: dynamicColor ?? this.dynamicColor,
      enableAppLock: enableAppLock ?? this.enableAppLock,
      hideLockedNotesPreview: hideLockedNotesPreview ?? this.hideLockedNotesPreview,
    );
  }
}
