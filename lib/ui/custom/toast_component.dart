import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:toast/toast.dart';

import '../../my_theme.dart';

class ToastComponent {
  static showDialog(
      String msg, {
        int duration = 0,
        int gravity = 0,
        TextStyle textStyle = const TextStyle(color: MyTheme.font_grey),
        Color bgColor = const Color.fromRGBO(239, 239, 239, .9),
      }) {
    if (OneContext.hasContext) {
      ToastContext().init(OneContext().context!);
      Toast.show(
        msg,
        duration: duration != 0 ? duration : Toast.lengthLong,
        gravity: gravity != 0 ? gravity : Toast.bottom,
        backgroundColor: Colors.white,
        textStyle: textStyle,
        border: Border.all(
          color: MyTheme.accent_color,
        ),
        backgroundRadius: 15,
      );
    } else {
      debugPrint("⚠️ OneContext not ready: toast not shown");
    }
  }
}
