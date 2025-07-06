import 'package:flutter/material.dart';
import 'package:mvmnt_cli/core/theme/app_colors.dart';
import 'package:mvmnt_cli/core/theme/app_text_styles.dart';
import 'package:mvmnt_cli/core/util/theme_util.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AppTheme {
  static ThemeData getTheme(BuildContext context, ThemeType? type) {
    var isDark = getIsDark(context, type);

    return ThemeData(
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: isDark ? AppColors.primaryDark : AppColors.primaryLight,
        onPrimary: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        secondary: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
        onSecondary:
            isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        error: isDark ? AppColors.errorColorDark : AppColors.errorColorLight,
        onError: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        onSurface: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
      ),
      textTheme: const TextTheme(
        bodySmall: AppTextStyles.bodySmall,
        bodyMedium: AppTextStyles.bodyMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        headlineSmall: AppTextStyles.headlineSmall,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineLarge: AppTextStyles.headlineLarge,
      ),
      dividerColor: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDark ? Color(0xFF2C2C2E) : Colors.grey[200],
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        filled: true,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        strokeCap: StrokeCap.round,
        refreshBackgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(
              inherit: true,
              fontSize: 16,
              //color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            // if (states.contains(WidgetState.disabled)) {
            //   return Colors.grey; // Color when disabled
            // }
            return isDark ? Color(0xFF2C2C2E) : AppColors.onSurfaceDark;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey; // Color when disabled
            }
            return isDark
                ? AppColors.onSurfaceDark
                : AppColors.onSurfaceLight; // Color when enabled
          }),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDark ? AppColors.primaryDark : AppColors.primaryLight,
          foregroundColor:
              isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          elevation: 0,
          disabledBackgroundColor: AppColors.primaryLight.withOpacity(0.3),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStateProperty.all<Color>(
            isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey; // Color when disabled
            }
            return isDark
                ? AppColors.onSurfaceDark
                : AppColors.onSurfaceLight; // Color when enabled
          }),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(
              color: Colors.white,
              //isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          minimumSize: WidgetStateProperty.all<Size>(Size(double.infinity, 60)),

          shape: WidgetStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) => TextStyle(
              fontSize: 18,
              fontWeight:
                  states.contains(WidgetState.selected)
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) =>
                states.contains(WidgetState.selected)
                    ? AppColors.primaryLight
                    : isDark
                    ? AppColors.onSurfaceDark
                    : AppColors.onSurfaceLight,
          ),
        ),
        selectedIcon: SvgIcon(name: 'check', color: AppColors.primaryLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        shape: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
            width: 0.1,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 60,
        elevation: 12,
        indicatorColor: Colors.transparent,
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => TextStyle(
            fontSize: 10,
            fontWeight:
                states.contains(WidgetState.selected)
                    ? FontWeight.bold
                    : FontWeight.normal,
            color:
                states.contains(WidgetState.selected)
                    ? AppColors.primaryDark
                    : isDark
                    ? AppColors.onSurfaceDark
                    : AppColors.onSurfaceLight,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (states) => IconThemeData(
            size: 22,
            color:
                states.contains(WidgetState.selected)
                    ? AppColors.primaryDark
                    : isDark
                    ? AppColors.onSurfaceDark
                    : AppColors.onSurfaceLight,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 12,
        modalElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textColorDark : AppColors.textColorLight,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        selectedTileColor: AppColors.primaryLight.withOpacity(0.1),
      ),
      tabBarTheme: TabBarThemeData(
        dividerHeight: 0.5,
        tabAlignment: TabAlignment.start,
        // indicatorSize: TabBarIndicatorSize.label,
        // indicator: UnderlineTabIndicator(
        //   borderSide: BorderSide(
        //     // width: 4.0,
        //     // color: Theme.of(context).indicatorColor,
        //   ),
        //   // insets: const EdgeInsets.only(right: 30),
        // ),
        labelPadding: EdgeInsets.only(right: 30),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (states) =>
              states.contains(WidgetState.selected)
                  ? isDark
                      ? AppColors.surfaceLight
                      : AppColors.surfaceDark
                  : isDark
                  ? Color(0xFF2C2C2E)
                  : Colors.grey.shade300,
        ),
        trackOutlineColor: WidgetStateProperty.all<Color>(Colors.transparent),
        thumbColor: WidgetStateProperty.all<Color>(
          isDark ? AppColors.onSurfaceLight : AppColors.onSurfaceDark,
        ),
      ),
    );
  }
}
