import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sougou_app/cubit/get_setting_cubit.dart';
import 'package:sougou_app/utils/constants.dart';

class TermAndCondition extends StatelessWidget {
  const TermAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.read<GetSettingCubit>().appbarTitlestyle() == 'center'
          ? AppBar(
              title: Text(CustomStrings.terms),
              centerTitle: true,
            )
          : AppBar(
              title: Align(
                  alignment: Alignment.topLeft,
                  child: Text(CustomStrings.terms)),
              centerTitle: true,
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HtmlWidget(context.read<GetSettingCubit>().termsPage()),
            ),
          ],
        ),
      ),
    );
  }
}
