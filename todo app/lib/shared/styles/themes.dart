// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData darkTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: HexColor('3A3B3C'),
  appBarTheme: AppBarTheme(
      titleSpacing: 20,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor('3A3B3C'),
          statusBarIconBrightness: Brightness.light),
      backgroundColor: HexColor('3A3B3C'),
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.blue,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.blue)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: HexColor('3A3B3C'),
    unselectedItemColor: Colors.grey[300],
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    elevation: 20.0,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
    subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.20),
  ),
);
ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      titleSpacing: 20,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.blue)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      elevation: 20.0),
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
    subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.20),
  ),
);
