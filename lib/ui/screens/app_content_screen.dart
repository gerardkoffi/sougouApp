import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_web/cubit/get_setting_cubit.dart';
import 'package:prime_web/ui/widgets/load_web_view.dart';

class AppContentScreen extends StatefulWidget {
  const AppContentScreen({
    this.title,
    this.content,
    required this.url,
    super.key,
  });

  final String? title;
  final String? content;
  final String url;

  @override
  State<AppContentScreen> createState() => _AppContentScreenState();
}

class _AppContentScreenState extends State<AppContentScreen> {
  @override
  Widget build(BuildContext context) {
    late final message =
        "<span style='color: ${Theme.of(context).brightness == Brightness.dark ? 'white' : 'black'};'>"
        '${widget.content}'
        '</span>';

    return Scaffold(
      appBar: context.read<GetSettingCubit>().appbarTitlestyle() == 'center'
          ? AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(widget.title ?? "Title"),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            )
          : AppBar(
              elevation: 0,
              title: Align(
                alignment: Alignment.topLeft,
                child: Text(widget.title ?? "Title"),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),
      body: SafeArea(
        top: !Platform.isIOS,
        child: widget.url == ''
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: LoadWebView(url: message, webUrl: false),
              )
            : LoadWebView(url: widget.url),
      ),
    );
  }
}
