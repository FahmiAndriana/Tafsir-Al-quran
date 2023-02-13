import 'package:flutter/material.dart';

const appPurpleAdult = Color(0xFF301E67);
const appPurpleOld = Color(0xFF2E0D8A);
const appPurpleTeen = Color(0xFF9345F2);
const appPurpleBlack = Color(0xFF260F68);
const appOrange = Color(0xFFE6704A);
const appWhite = Color(0xFFFAF8FC);
const appGrey = Color(0xFFB9A2D8);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  primaryColor: appPurpleAdult,
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: appOrange),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: appWhite,
    titleTextStyle: TextStyle(
      color: appPurpleOld,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: appPurpleOld,
    ),
    bodyMedium: TextStyle(
      color: appPurpleOld,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: appPurpleAdult,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appPurpleAdult,
    unselectedLabelColor: appGrey,
    // indicator: BoxDecoration(
    //   color: appPurpleAdult,
    // ),
  ),
  iconTheme: const IconThemeData(color: appPurpleAdult),
  bottomAppBarTheme: const BottomAppBarTheme(color: appPurpleOld),
);

ThemeData themeDark = ThemeData(
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: appGrey),
  brightness: Brightness.dark,
  primaryColor: appPurpleAdult,
  scaffoldBackgroundColor: appPurpleAdult,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurpleAdult,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: appWhite,
    ),
    bodyMedium: TextStyle(
      color: appWhite,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: appWhite,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appWhite,
    unselectedLabelColor: appGrey,
    // indicator: BoxDecoration(
    //   color: appWhite,
    // ),
  ),
  iconTheme: const IconThemeData(color: appWhite),
  bottomAppBarTheme: const BottomAppBarTheme(color: appWhite),
);
