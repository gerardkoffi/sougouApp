import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:one_context/one_context.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';

import 'package:sougou_app/cubit/fcm_cubit.dart';
import 'package:sougou_app/cubit/get_onbording_cubit.dart';
import 'package:sougou_app/cubit/get_setting_cubit.dart';
import 'package:sougou_app/cubit/get_otpgenerate_cubit.dart';
import 'package:sougou_app/data/repositories/auth_repositories.dart';
import 'package:sougou_app/data/repositories/get_otpgenerate_repositories.dart';
import 'package:sougou_app/data/repositories/verify_otp_repositories.dart';

import 'package:sougou_app/provider/navigation_bar_provider.dart';
import 'package:sougou_app/provider/theme_provider.dart';
import 'package:sougou_app/ui/screens/splash_screen.dart';
import 'package:sougou_app/ui/widgets/admob_service.dart';

import 'package:sougou_app/utils/constants.dart';

import 'cubit/auth_cubit.dart';
import 'ui/screens/set_screens/settings_screen.dart';

//final navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences pref;

/// Fonction pour demander et vérifier les permissions de stockage
Future<bool> enableStoragePermission() async {
  if (Platform.isIOS) {
    return await Permission.storage.request().isGranted;
  } else {
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    if (androidDeviceInfo.version.sdkInt < 33) {
      return await Permission.storage.request().isGranted;
    } else {
      return await Permission.photos.request().isGranted;
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  await initializeDateFormatting('fr_FR', null);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await Firebase.initializeApp();
  AdMobService.initialize();

  await enableStoragePermission();

  const counter = 0;
  pref.setInt('counter', counter);

  final bool isDarkTheme = pref.getBool('isDarkTheme') ?? false;

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (BuildContext context) => ThemeProvider(isDarkTheme: isDarkTheme),
      child: SharedValue.wrapApp(MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationBarProvider>(
          create: (_) => NavigationBarProvider(),
        ),
        BlocProvider(create: (context) => GetSettingCubit()),
        BlocProvider(create: (context) => GetOnbordingCubit()),
        BlocProvider(create: (context) => SetFcmCubit()),
        BlocProvider(create: (context) => AuthCubit(AuthRepository())),
        BlocProvider(create: (context) => OTPCubit(otpRepository: OTPRepository(), verifyOtpRepository: VerifyOtpRepositories())),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
              builder: OneContext().builder, // <--- essentiel
              navigatorKey: OneContext().key,
              title: appName,
              debugShowCheckedModeBanner: false,
              themeMode: value.getTheme(),
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              //navigatorKey: navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                return switch (settings.name) {
                  'settings' => CupertinoPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  _ => null,
                };
              },
              home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

/// Classe pour ignorer les erreurs de certificat SSL
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
