import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sougou_app/cubit/get_setting_cubit.dart';
import 'package:sougou_app/utils/constants.dart';

class PrivacypolicyScreen extends StatelessWidget {
  const PrivacypolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
           AppBar(
              title: Text(CustomStrings.privacyPolicy),
              centerTitle: true,
            ),
         
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HtmlWidget(context.read<GetSettingCubit>().privacyPage()),
            ),
          ],
        ),
      ),
    );
  }
}
