import 'package:flutter/material.dart';

const primaryColors = MaterialColor(
  0xFF30475E, // primaryColor
  <int, Color>{
    50: primaryColor,
    100: primaryColor,
    200: primaryColor,
    300: primaryColor,
    400: primaryColor,
    500: primaryColor,
    600: primaryColor,
    700: primaryColor,
    800: primaryColor,
    900: primaryColor,
  },
);

const primaryColor = Color(0xFF30475E);
const backgroundColorLightTheme = Color(0xFFF5F5F5);
const backgroundColorDarkTheme = Color(0xFF041C32);
const accentColor = Color(0xFFC92BCE);
const splashBackColor1 = Color(0xFFFFCB8B);
const splashBackColor2 = Color(0xFFFFFFFF);
const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF000000);

const onboardingButtonColor1 = Color(0xFFE08900);
const onboardingButtonColor2 = Color(0xFFFFFFFF);
const onboardingBGColor = Color(0xFFFFFFFF);

const indicatorColor1 = Color(0xFFE69416);
const indicatorColor2 = Color(0xFFF6D6A8);
const indicatorColor3 = Color(0xFFF37B46);

const indicatorColor = LinearGradient(
  colors: [
    onboardingButtonColor1,
    onboardingButtonColor2,
  ],
);
