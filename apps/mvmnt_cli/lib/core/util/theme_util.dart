import 'package:flutter/material.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';

bool getIsDark(BuildContext context, ThemeType? type) {
  switch (type) {
    case ThemeType.light:
      return false;
    case ThemeType.dark:
      return true;
    default:
      Brightness brightness = MediaQuery.of(context).platformBrightness;
      return brightness == Brightness.dark;
  }
}
