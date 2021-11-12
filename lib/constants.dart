import 'package:flutter/material.dart';

String defaultImgUrl =
    'https://firebasestorage.googleapis.com/v0/b/healthiee-dc5ec.appspot.com/o/profileImg%2FLBCC_logo.png?alt=media&token=afe33eb6-3781-4c74-9ffb-4b1726b92576';

ThemeData defaultAppTheme = ThemeData(
  iconTheme: IconThemeData(color: Colors.white, size: 30),
  primaryColor: Colors.redAccent,
  backgroundColor: Colors.white,
  accentColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  hintColor: Colors.grey,
  cardTheme: CardTheme(
    color: Color(0xFFE9EEFA),
    elevation: 3.0,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.red,
  ),
  primaryColorLight: Colors.deepOrange,
  primaryColorDark: Colors.red[900],
  splashColor: Colors.red,
  buttonColor: Colors.red,
);

TextStyle styleBold = TextStyle(
  color: Color(0xFF2152D1),
  fontSize: 30,
  fontWeight: FontWeight.bold,
);

TextStyle styleDarkGrayBold = TextStyle(
  color: Color(0xFF2152D1),
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

TextStyle styleBoldWhiteLarge = TextStyle(
  color: Colors.white,
  fontSize: 60,
  fontWeight: FontWeight.bold,
  fontFamily: 'Kanit'
);

TextStyle styleBoldBlack = TextStyle(
  color: Colors.black,
  fontSize: 30,
  fontWeight: FontWeight.bold,
);

TextStyle styleCardParamWhite = TextStyle(
  color: Colors.white,
  fontSize: 16,
  letterSpacing: 2,
  fontWeight: FontWeight.bold,
);

TextStyle styleBoldBlackMedium = TextStyle(
  color: Colors.black,
  fontSize: 32,
  fontFamily: 'Kanit',
  fontWeight: FontWeight.bold,
);

TextStyle styleBoldGrayMedium = TextStyle(
  color: Colors.black54,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

TextStyle styleBoldWhite = TextStyle(
  color: Colors.white,
  fontSize: 40,
  letterSpacing: 2,
  fontFamily: 'Kanit',
  fontWeight: FontWeight.bold,
);

TextStyle styleBoldWhiteMedium = TextStyle(
  color: Colors.white,
  fontSize: 32,
  letterSpacing: 2,
  fontFamily: 'Kanit',
  fontWeight: FontWeight.bold,
);

TextStyle styleBoldLtBlueMedium = TextStyle(
  color: Colors.lightBlueAccent[100],
  fontSize: 32,
  letterSpacing: 2,
  fontFamily: 'Kanit',
  fontWeight: FontWeight.bold,
);

TextStyle subHead = TextStyle(
  color: Colors.blue,
  fontSize: 20,
);
TextStyle normal = TextStyle(
  color: Colors.black,
  fontSize: 16,
);

TextStyle elementwhite = TextStyle(
  color: Colors.white,
  fontFamily: 'Kanit',
  fontSize: 20,
);

TextStyle elementgray = TextStyle(
  color: Colors.grey,
  fontSize: 16,
);

TextStyle profileEmail = TextStyle(
  color: Colors.white60,
  fontSize: 16,
);

TextStyle purpleNormalBold = TextStyle(
  color: Colors.purple,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

TextStyle blueNormalBold = TextStyle(
  color: Colors.blue[900],
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

TextStyle profileText = TextStyle(
  color: Colors.purple,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

TextStyle profileTextwhite = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

TextStyle profileTextltblue = TextStyle(
  color: Colors.lightBlue,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

TextStyle profileTextBlue = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

TextStyle profileTextTime = TextStyle(
  color: Colors.white70,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

InputDecoration createacdec = InputDecoration(
  labelText: 'Name',
  labelStyle: normal,
  focusColor: Colors.red,
);

ButtonStyle dashBoardParams = ButtonStyle(
  elevation: MaterialStateProperty.all(0),
  padding: MaterialStateProperty.all(EdgeInsets.all(6)),
  shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),side: BorderSide(width: 2, color: Colors.black)),),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return Colors.orange;
      return Colors.white; // Use the component's default.
    },
  ),
);

class Constants {}