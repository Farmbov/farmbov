import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  static ThemeData of(BuildContext context) {
    var theme = Theme.of(context);

    // Tema padrão para os campos de input no modo claro
    final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: Colors.white, // Fundo do input
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xffD7D3D0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xffD7D3D0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xffD7D3D0),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    );

    PopupMenuThemeData popupMenuTheme = PopupMenuThemeData(
      color: AppColors.primaryGreen,
      textStyle: TextStyle(
          background: Paint(),
          color: Colors.black,
          fontSize: 12.0,
          fontWeight: FontWeight.normal),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
      ),
    );

    final ButtonStyle textButtonStyle = TextButton.styleFrom(
        textStyle: const TextStyle(color: Colors.white),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent);

    // Dialog Theme
    final dialogTheme = DialogTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: const TextStyle(
        color: AppColors.primaryGreen,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.neutralGray,
        fontSize: 16.0,
      ),
    );

    DatePickerThemeData datePickerTheme = DatePickerThemeData(
      backgroundColor: AppColors.primaryBackground,
      headerBackgroundColor: AppColors.primaryGreen,
      headerForegroundColor: Colors.white,
      headerHelpStyle: const TextStyle(color: Colors.white),
      surfaceTintColor: AppColors.primaryGreen,
      dayBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return AppColors.primaryBackground;
      }),
      dayForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryBackground;
        }
        return AppColors.neutralBlack;
      }),
      todayBackgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreenLight;
        }
        return AppColors.primaryGreenLight; // Cor quando não está selecionado
      }),
      todayForegroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.neutralBlack; // Cor quando está selecionado
        }
        return AppColors.neutralBlack; // Cor quando não está selecionado
      }),
      yearForegroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryBackground;
        }
        return AppColors.neutralBlack;
      }),
      yearBackgroundColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return AppColors.primaryBackground;
      }),
      rangePickerBackgroundColor: AppColors.lightBackground,
      rangePickerHeaderBackgroundColor: AppColors.primaryGreenDark,
      rangePickerHeaderForegroundColor: AppColors.primaryBackground,
      rangeSelectionBackgroundColor:
          AppColors.primaryGreenLight.withOpacity(0.4),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            AppColors.lightBackground, // Cor de fundo do campo de entrada
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
        hintStyle: const TextStyle(color: AppColors.neutralGray),
        labelStyle: const TextStyle(color: AppColors.neutralBlack),
        helperStyle: const TextStyle(color: AppColors.neutralGray),
      ),
    );

    ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ), // Espaçamento interno
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
    );

    //card theme

    const CardTheme cardTheme = CardTheme(color: Colors.white, elevation: 0);

    // SegmentedButton
    final segmentedButtonTheme = SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) =>
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors
                .primaryGreen; // Cor quando o botão está selecionado
          }
          return AppColors.lightGray; // Cor de fundo padrão
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white; // Cor do texto quando selecionado
          }
          return AppColors.neutralBlack; // Cor do texto padrão
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return AppColors.primaryGreenLight
                .withOpacity(0.3); // Efeito de toque
          }
          return null;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Cantos arredondados
            side:
                const BorderSide(color: AppColors.dividerColor), // Borda sutil
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevation: MaterialStateProperty.all<double>(0), // Sem sombra
      ),
    );

    theme = ThemeData(
        useMaterial3: true,
        checkboxTheme: const CheckboxThemeData(
          side: BorderSide(
            color: AppColors.primaryGreen,
            width: 1,
          ),
        ),
        cardTheme: cardTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          scrolledUnderElevation: 0,
          elevation: 5,
          surfaceTintColor: AppColors.primaryGreen,
          toolbarTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: GoogleFonts.inter().fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(const Color(0xFFCECECE)),
          trackColor: MaterialStateProperty.all(const Color(0xFFF0F0F0)),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF518159),
          secondary: const Color(0xFF064B11),
          background: Colors.white,
        ),
        bottomSheetTheme: MediaQuery.of(context).size.width < 800
            ? const BottomSheetThemeData(backgroundColor: Colors.black54)
            : const BottomSheetThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
                modalBackgroundColor: Colors.transparent,
                modalElevation: 0,
              ),
        primaryColor: const Color(0xFF518159),
        secondaryHeaderColor: const Color(0xFF064B11),
        primaryColorLight: const Color(0xFF518159),
        primaryColorDark: const Color(0xFF064B11),
        scaffoldBackgroundColor: AppColors.lightBackground,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: elevatedButtonTheme,
        textButtonTheme: TextButtonThemeData(style: textButtonStyle),
        dividerTheme: const DividerThemeData(color: AppColors.dividerColor),
        dialogTheme: dialogTheme,
        datePickerTheme: datePickerTheme,
        inputDecorationTheme: inputDecorationTheme,
        textTheme: GoogleFonts.interTextTheme(theme.textTheme).copyWith(
          displayLarge: theme.textTheme.displayLarge?.copyWith(
              fontSize: 48, color: Colors.white, fontWeight: FontWeight.w900),
          displayMedium: theme.textTheme.displayLarge?.copyWith(
              fontSize: 40, color: Colors.white, fontWeight: FontWeight.w900),
          displaySmall: theme.textTheme.displayLarge?.copyWith(
              fontSize: 38, color: Colors.white, fontWeight: FontWeight.w900),
          headlineMedium: theme.textTheme.displayLarge?.copyWith(
              fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700),
          headlineSmall: theme.textTheme.displayLarge?.copyWith(
              fontSize: 26, color: Colors.white, fontWeight: FontWeight.w700),
          titleLarge: theme.textTheme.displayLarge?.copyWith(
              fontSize: 20,
              color: theme.primaryColor,
              fontWeight: FontWeight.w700),
          bodyLarge: theme.textTheme.displayLarge
              ?.copyWith(fontSize: 14, color: AppColors.darkGray),
          bodyMedium: theme.textTheme.displayLarge
              ?.copyWith(fontSize: 12, color: AppColors.mediumGray),
          labelLarge: theme.textTheme.labelLarge?.copyWith(
            fontSize: 14,
            backgroundColor: theme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        popupMenuTheme: popupMenuTheme,
        segmentedButtonTheme: segmentedButtonTheme);

    return theme;
  }
}
