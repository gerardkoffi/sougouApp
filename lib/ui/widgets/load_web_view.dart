import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prime_web/cubit/get_setting_cubit.dart';
import 'package:prime_web/utils/constants.dart';
import 'package:prime_web/main.dart';
import 'package:prime_web/provider/navigation_bar_provider.dart';
import 'package:prime_web/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadWebView extends StatefulWidget {
  const LoadWebView({this.url = '', this.webUrl = true, super.key});

  final String url;
  final bool webUrl;

  @override
  State<LoadWebView> createState() => _LoadWebViewState();
}

class _LoadWebViewState extends State<LoadWebView>
    with SingleTickerProviderStateMixin {
  final webViewKey = GlobalKey();

  late PullToRefreshController _pullToRefreshController;
  CookieManager cookieManager = CookieManager.instance();
  InAppWebViewController? webViewController;
  double progress = 0;
  String url = '';
  int _previousScrollY = 0;
  bool isLoading = false;
  bool showErrorPage = false;
  bool slowInternetPage = false;
  bool noInternet = false;
  late AnimationController animationController;
  late Animation<double> animation;
  final expiresDate =
      DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _validURL = false;
  bool canGoBack = false;

  @override
  void initState() {
    super.initState();
    
    NoInternet.initConnectivity().then(
      (value) => setState(() {
        _connectionStatus = value;
      }),
    );
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      NoInternet.updateConnectionStatus(result).then((value) {
        _connectionStatus = value;
        if (_connectionStatus != [ConnectivityResult.none]) {
          setState(() {
            noInternet = false;
            webViewController?.reload();
          });
        } /* else {
          setState(() {
            noInternet = true;
          });
        } */
      });
    });
    

    try {
      _pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(
            color: context.read<GetSettingCubit>().loadercolor()),
        onRefresh: () async {
          // if (Platform.isAndroid) {
          //   await webViewController!.reload();
          // } else if (Platform.isIOS) {
          //   await webViewController!.loadUrl(
          //     urlRequest: URLRequest(url: await webViewController!.getUrl()),
          //   );
          // }
          await webViewController!.loadUrl(
            urlRequest: URLRequest(url: await webViewController!.getUrl()),
          );
        },
      );
    } catch (e, stackTrace) {
      log('Error initializing PullToRefreshController: $e');
      log('StackTrace: $stackTrace');
    }

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    animationController.dispose();
    webViewController = null;
    super.dispose();
  }

  final _inAppWebViewSettings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    useOnDownloadStart: true,
    javaScriptCanOpenWindowsAutomatically: true,
    userAgent:
        'Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36',
    verticalScrollBarEnabled: false,
    horizontalScrollBarEnabled: false,
    transparentBackground: true,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    allowsInlineMediaPlayback: true,
  );

  @override
  Widget build(BuildContext context) {
    _validURL = Uri.tryParse(widget.url)?.isAbsolute ?? false;
    return GestureDetector(
      onHorizontalDragEnd: (dragEndDetails) async {
        // Swiping in right direction.
        if (dragEndDetails.primaryVelocity! > 0) {
          if (await webViewController!.canGoBack()) {
            await webViewController!.goBack();
          } else {}
        }
      },
      child: WillPopScope(
        onWillPop: () => _exitApp(context),
        child: !widget.webUrl
            ? InAppWebView(
                initialData: InAppWebViewInitialData(data: widget.url),
                initialSettings: InAppWebViewSettings(
                  // hybrid composition and webview causes issue in flutter (3.16.X), this should be fixed in 3.17.X.
                  // useHybridComposition: false,
                  useShouldOverrideUrlLoading: true,
                  verticalScrollBarEnabled: false,
                  horizontalScrollBarEnabled: false,
                  transparentBackground: true,
                  allowFileAccessFromFileURLs: true,
                  defaultFontSize: 32,
                  allowsInlineMediaPlayback: true,
                ),
                gestureRecognizers: const <Factory<
                    OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    EagerGestureRecognizer.new,
                  ),
                },
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
              )
            : Stack(
                children: [
                  if (_validURL)
                    InAppWebView(
                      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                      initialSettings: _inAppWebViewSettings,
                      pullToRefreshController:
                          context.read<GetSettingCubit>().pullToRefresh()
                              ? _pullToRefreshController
                              : null,
                      gestureRecognizers: const <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          EagerGestureRecognizer.new,
                        ),
                      },
                      onWebViewCreated: (controller) async {
                        webViewController = controller;

                        await cookieManager.setCookie(
                          url: WebUri(widget.url),
                          name: 'myCookie',
                          value: 'myValue',
                          // domain: ".flutter.dev",
                          expiresDate: expiresDate,
                          isHttpOnly: false,
                          isSecure: true,
                        );
                      },
                      onScrollChanged: (controller, x, y) async {
                        final currentScrollY = y;
                        final animationController = context
                            .read<NavigationBarProvider>()
                            .animationController;

                        if (currentScrollY > _previousScrollY) {
                          _previousScrollY = currentScrollY;
                          if (!animationController.isAnimating) {
                            await animationController.forward();
                          }
                        } else {
                          _previousScrollY = currentScrollY;

                          if (!animationController.isAnimating) {
                            await animationController.reverse();
                          }
                        }
                      },
                      onLoadStart: (controller, url) async {
                        setState(() {
                          isLoading = true;
                          showErrorPage = false;
                          slowInternetPage = false;
                          this.url = url.toString();
                        });
                      },
                      onLoadStop: (controller, url) async {
                        await _pullToRefreshController.endRefreshing();

                        setState(() {
                          this.url = url.toString();
                          isLoading = false;
                        });

                        // Removes header and footer from page
                        if (context.read<GetSettingCubit>().hideHeader()) {
                          await webViewController!
                              .evaluateJavascript(
                                source:
                                    "javascript:(function() { var head = document.getElementsByTagName('header')[0];head.parentNode.removeChild(head);})()",
                              )
                              .then(
                                (_) => debugPrint(
                                  'Page finished loading Javascript',
                                ),
                              )
                              .catchError((Object e) => debugPrint('$e'));
                        }

                        if (context.read<GetSettingCubit>().hideFooter()) {
                          await webViewController!
                              .evaluateJavascript(
                                source:
                                    "javascript:(function() { var footer = document.getElementsByTagName('footer')[0];footer.parentNode.removeChild(footer);})()",
                              )
                              .then(
                                (_) => debugPrint(
                                  'Page finished loading Javascript',
                                ),
                              )
                              .catchError((Object e) => debugPrint('$e'));
                        }
                      },
                      onReceivedError: (controller, request, error) async {
                        print("onReceivedError Hear.......${error}");
                        await _pullToRefreshController.endRefreshing();
                        setState(() {
                          isLoading = false;

                          if (request.url.origin == widget.url &&
                                  error.type ==
                                      WebResourceErrorType.HOST_LOOKUP &&
                                  error.description ==
                                      'net::ERR_NAME_NOT_RESOLVED' ||
                              error.description ==
                                  'net::ERR_CONNECTION_CLOSED') {
                            slowInternetPage = true;
                            return;
                          }
                          if (error.type ==
                                  WebResourceErrorType
                                      .NOT_CONNECTED_TO_INTERNET ||
                              error.description ==
                                  'net::ERR_INTERNET_DISCONNECTED') {
                            noInternet = true;
                            return;
                          }
                        });
                      },
                      onReceivedHttpError: (controller, request, response) {
                        _pullToRefreshController.endRefreshing();
                        // print('=====${response.statusCode}');//
                        if ([100, 299].contains(response.statusCode) ||
                            [400, 599].contains(response.statusCode)) {
                          setState(() {
                            showErrorPage = true;
                            isLoading = false;
                          });
                        }
                      },
                      onReceivedServerTrustAuthRequest:
                          (controller, challenge) async {
                        return ServerTrustAuthResponse(
                          action: ServerTrustAuthResponseAction.PROCEED,
                        );
                      },
                      onGeolocationPermissionsShowPrompt:
                          (controller, origin) async {
                        await Permission.location.request();
                        return Future.value(
                          GeolocationPermissionShowPromptResponse(
                            origin: origin,
                            allow: true,
                            retain: true,
                          ),
                        );
                      },
                      onPermissionRequest: (controller, request) async {
                        for (final element in request.resources) {
                          if (element == PermissionResourceType.MICROPHONE) {
                            await Permission.microphone.request();
                          }
                          if (element == PermissionResourceType.CAMERA) {
                            await Permission.camera.request();
                          }
                        }

                        return PermissionResponse(
                          action: PermissionResponseAction.GRANT,
                          resources: request.resources,
                        );
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          if (progress == 100) {
                            _pullToRefreshController.endRefreshing();
                            isLoading = false;
                          }
                          this.progress = progress / 100;
                        });
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var url = navigationAction.request.url.toString();
                        final uri = Uri.parse(url);

                        if (Platform.isIOS && url.contains('geo')) {
                          url = url.replaceFirst(
                            'geo://',
                            'http://maps.apple.com/',
                          );
                        } else if (url.contains('tel:') ||
                            url.contains('mailto:') ||
                            url.contains('play.google.com') ||
                            url.contains('maps') ||
                            url.contains('messenger.com')) {
                          url = Uri.encodeFull(url);
                          try {
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              await launchUrl(uri);
                            }
                            return NavigationActionPolicy.CANCEL;
                          } catch (e) {
                            await launchUrl(uri);
                            return NavigationActionPolicy.CANCEL;
                          }
                        } else if (![
                          'http',
                          'https',
                          'file',
                          'chrome',
                          'data',
                          'javascript',
                        ].contains(uri.scheme)) {
                          if (await canLaunchUrl(uri)) {
                            // Launch the App
                            await launchUrl(
                              uri,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onCloseWindow: (controller) async {},
                      onDownloadStartRequest:
                          (controller, onDownloadStartRequest) async {
                        await enableStoragePermission().then((status) async {
                          final url = onDownloadStartRequest.url.toString();

                          if (status == true) {
                            try {
                              final dio = Dio();
                              String fileName;
                              if (url.lastIndexOf('?') > 0) {
                                fileName = url.substring(
                                  url.lastIndexOf('/') + 1,
                                  url.lastIndexOf('?'),
                                );
                              } else {
                                fileName = url.substring(
                                  url.lastIndexOf('/') + 1,
                                );
                              }
                              final savePath = await getFilePath(fileName);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Downloading file..'),
                                ),
                              );
                              await dio.download(
                                url,
                                savePath,
                                onReceiveProgress: (rec, total) {},
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Download Complete'),
                                ),
                              );
                            } on Exception catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Downloading failed'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Permission denied'),
                              ),
                            );
                          }
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) async {
                        setState(() {
                          this.url = url.toString();
                        });
                      },
                    )
                  else
                    Center(
                      child: Text(
                        'Url is not valid',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  if (isLoading)
                    if (Platform.isIOS)
                      Center(
                        child: CupertinoActivityIndicator(
                          radius: 18,
                          color: context.read<GetSettingCubit>().loadercolor(),
                        ),
                      )
                    else
                      Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: context.read<GetSettingCubit>().loadercolor(),
                        ),
                      )
                  else
                    const SizedBox.shrink(),
                  if (noInternet)
                    const Center(
                      child: NoInternetWidget(),
                    )
                  else
                    const SizedBox.shrink(),
                  if (showErrorPage)
                    Center(
                      child: NotFound(
                        webViewController: webViewController!,
                        url: url,
                        title1: CustomStrings.pageNotFound1,
                        title2: CustomStrings.pageNotFound2,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  if (slowInternetPage)
                    Center(
                      child: NotFound(
                        webViewController: webViewController!,
                        url: url,
                        title1: CustomStrings.incorrectURL1,
                        title2: CustomStrings.incorrectURL2,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  // if (progress < 1.0 && _validURL)
                  //   SizeTransition(
                  //     sizeFactor: animation,
                  //     axis: Axis.horizontal,
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width,
                  //       height: 5,
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           colors: [
                  //             Theme.of(context).progressIndicatorTheme.color!,
                  //             Theme.of(context)
                  //                 .progressIndicatorTheme
                  //                 .refreshBackgroundColor!,
                  //             Theme.of(context)
                  //                 .progressIndicatorTheme
                  //                 .linearTrackColor!,
                  //           ],
                  //           stops: const [0.1, 1.0, 0.1],
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  // else
                  //   const SizedBox.shrink(),
                ],
              ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (mounted) {
      await context.read<NavigationBarProvider>().animationController.reverse();
    }
    if (!_validURL) {
      return Future.value(true);
    }
    if (await webViewController!.canGoBack()) {
      setState(() {
        noInternet = false;
      });
      await webViewController!.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<bool> requestPermission() async {
    final status = await Permission.storage.status;

    if (status == PermissionStatus.granted) {
      return true;
    } else if (status != PermissionStatus.granted) {
      //
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        // await openAppSettings();
        return false;
      }
    }
    return true;
  }

  Future<String> getFilePath(String uniqueFileName) async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = '/storage/emulated/0/Download';
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }

    return '$externalStorageDirPath/$uniqueFileName';
  }
}
