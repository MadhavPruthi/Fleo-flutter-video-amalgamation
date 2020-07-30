import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const PRIMARY_COLOR_LIGHT = Color(0xff3254F1);
const PRIMARY_COLOR_DARK = Color(0xffeeeeee);

const ACCENT_COLOR_LIGHT = Color(0xffffffff);
const ACCENT_COLOR_DARK = Color(0xff383838);

final TextStyle textStyleLight =
    GoogleFonts.robotoSlab(color: ACCENT_COLOR_LIGHT);
final TextStyle textStyleDark =
    GoogleFonts.robotoSlab(color: ACCENT_COLOR_DARK);
enum AppTheme { Light, Dark }

final appThemeData = {
  AppTheme.Light: ThemeData(
    brightness: Brightness.light,
    primaryColor: PRIMARY_COLOR_LIGHT,
    accentColor: ACCENT_COLOR_LIGHT,
    textTheme: TextTheme(headline3: textStyleLight, bodyText1: textStyleLight),
  ),
  AppTheme.Dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: PRIMARY_COLOR_DARK,
    accentColor: ACCENT_COLOR_DARK,
    textTheme: TextTheme(headline3: textStyleDark, bodyText1: textStyleDark),
  ),
};
