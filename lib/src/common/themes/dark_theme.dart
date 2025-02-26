import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_constants.dart';

//TODO: Falta iniciar e terminar kkkk
class DarkTheme {
  static ThemeData of(BuildContext context) {
    var theme = Theme.of(context);

    PopupMenuThemeData popupMenuTheme = PopupMenuThemeData(
      color: AppColors.primaryGreenDark,
      textStyle: TextStyle(
          background: Paint(),
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    final ButtonStyle textButtonStyle = TextButton.styleFrom(
        textStyle: const TextStyle(color: Colors.white),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent);

    // Dialog Theme
    final dialogTheme = DialogTheme(
      elevation: 0,
      backgroundColor: AppColors.darkBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: const TextStyle(
        color: AppColors.primaryGreenLight,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.lightGray,
        fontSize: 16.0,
      ),
    );

    DatePickerThemeData datePickerTheme = DatePickerThemeData(
      backgroundColor: AppColors.darkBackground,
      headerBackgroundColor: AppColors.primaryGreenDark,
      headerForegroundColor: Colors.white,
      headerHelpStyle: const TextStyle(color: Colors.white),
      surfaceTintColor: AppColors.primaryGreenDark,
      dayBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return AppColors.darkBackground;
      }),
      dayForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkBackground;
        }
        return Colors.white;
      }),
      todayBackgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreenLight;
        }
        return AppColors.primaryGreenLight;
      }),
      todayForegroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.white;
      }),
      yearForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkBackground;
        }
        return Colors.white;
      }),
      yearBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return AppColors.darkBackground;
      }),
      rangePickerBackgroundColor: AppColors.darkBackground,
      rangePickerHeaderBackgroundColor: AppColors.primaryGreenDark,
      rangePickerHeaderForegroundColor: AppColors.primaryBackground,
      rangeSelectionBackgroundColor:
          AppColors.primaryGreenLight.withOpacity(0.4),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primaryGreenLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primaryGreenDark),
        ),
        hintStyle: const TextStyle(color: AppColors.lightGray),
        labelStyle: const TextStyle(color: Colors.white),
        helperStyle: const TextStyle(color: AppColors.lightGray),
      ),
    );

    ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreenDark,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
    );

    // Card Theme
    const CardTheme cardTheme =
        CardTheme(color: AppColors.darkCard, elevation: 0);

    theme = ThemeData(
      useMaterial3: true,
      cardTheme: cardTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryGreenDark,
        scrolledUnderElevation: 0,
        elevation: 5,
        surfaceTintColor: AppColors.primaryGreenDark,
        toolbarTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: GoogleFonts.inter().fontFamily,
          fontWeight: FontWeight.w700,
        ),
      ),
      scrollbarTheme: const ScrollbarThemeData().copyWith(
        thumbColor: MaterialStateProperty.all(const Color(0xFF757575)),
        trackColor: MaterialStateProperty.all(const Color(0xFF333333)),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: Brightness.dark,
        primary: const Color(0xFF518159),
        secondary: const Color(0xFF064B11),
        background: Colors.white,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkOverlay,
        elevation: 0,
        modalBackgroundColor: AppColors.darkOverlay,
        modalElevation: 0,
      ),
      primaryColor: AppColors.primaryGreenDark,
      secondaryHeaderColor: AppColors.primaryGreen,
      primaryColorLight: AppColors.primaryGreenLight,
      primaryColorDark: AppColors.primaryGreenDark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: elevatedButtonTheme,
      textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      dividerTheme: const DividerThemeData(color: AppColors.darkDividerColor),
      dialogTheme: dialogTheme,
      datePickerTheme: datePickerTheme,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.darkInputBackground,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF3A3A3A),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF575757),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF757575),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      textTheme: GoogleFonts.interTextTheme(theme.textTheme).copyWith(
        displayLarge: theme.textTheme.displayLarge?.copyWith(
            fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
        displayMedium: theme.textTheme.displayMedium?.copyWith(
            fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
        displaySmall: theme.textTheme.displaySmall?.copyWith(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        headlineLarge: theme.textTheme.headlineLarge?.copyWith(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
        headlineMedium: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        headlineSmall: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        titleLarge: theme.textTheme.titleLarge?.copyWith(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
        bodyLarge: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14,
            color: AppColors.lightGray,
            fontWeight: FontWeight.normal),
        bodyMedium: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: AppColors.lightGray,
            fontWeight: FontWeight.normal),
        bodySmall: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: AppColors.lightGray,
            fontWeight: FontWeight.normal),
        labelLarge: theme.textTheme.labelLarge?.copyWith(
            fontSize: 14,
            color: AppColors.primaryGreenLight,
            fontWeight: FontWeight.w500),
        labelMedium: theme.textTheme.labelMedium?.copyWith(
            fontSize: 12,
            color: AppColors.primaryGreenLight,
            fontWeight: FontWeight.w400),
        labelSmall: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: AppColors.primaryGreenLight,
            fontWeight: FontWeight.w300),
      ),
      popupMenuTheme: popupMenuTheme,
    );

    return theme;
  }
}
