import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sougou_app/cubit/get_setting_cubit.dart';
import 'package:sougou_app/utils/icons.dart';

export '../ui/styles/colors.dart';
export 'icons.dart';
export 'strings.dart';

const String androidPackageName = 'com.sougou.webviewapp';

// admin url
String baseurl = 'https://sougou.disseh.com';
String databaseUrl = '$baseurl/api/';

// Url Sougou
String sougouUrl = 'http://207.180.210.22:9000';
String sgbaseUrl = "$sougouUrl/api/v1/";

const appName = 'Sougou';

// Here is for only reference you have to change it from panel

String webInitialUrl = '';

//Force Update
String forceUpdatee = '0'; //OFF

String message = '';
final shareAppMessage = '$message : $storeUrl';

String storeUrl = Platform.isAndroid ? '' : '';

bool showBottomNavigationBar = true;

/// Ad Ids
String interstitialAdId = Platform.isAndroid ? '' : '';
String bannerAdId = Platform.isAndroid ? '' : '';
String openAdId = Platform.isAndroid ? '' : '';

//icon to set when get firebase messages
const String notificationIcon = '@mipmap/ic_launcher_squircle';

//turn on/off enable storage permission
const bool isStoragePermissionEnabled = false;

List<Map<String, String>> navigationTabs(BuildContext context) => [
      {
        'url': context.read<GetSettingCubit>().primaryUrl(),
        'label': context.read<GetSettingCubit>().firstBottomNavWeb(),
        'icon': CustomIcons.homeIcon(Theme.of(context).brightness),
      },
      {
        'url': context.read<GetSettingCubit>().secondaryUrl(),
        'label': context.read<GetSettingCubit>().secondBottomNavWeb(),
        'icon': CustomIcons.demoIcon(Theme.of(context).brightness),
      },
    ];
