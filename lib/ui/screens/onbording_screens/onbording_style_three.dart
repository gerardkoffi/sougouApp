import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_web/cubit/get_onbording_cubit.dart';
import 'package:prime_web/utils/constants.dart';
import 'package:prime_web/main.dart';
import 'package:prime_web/ui/screens/main_screen.dart';
import 'package:prime_web/ui/widgets/glassmorphism_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreenThree extends StatefulWidget {
  const OnboardingScreenThree({super.key});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreenThree>
    with SingleTickerProviderStateMixin {
  final pageController = PageController();
  int _selectedIndex = 0;
  late int totalPages;
  double value = 0.0;
  TextStyle headline = const TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GlassmorphismContainer(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Container(
              height: size.height * 0.05,
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: jumpToMainPage,
                  child: Text('Skip', style: headline),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: double.maxFinite,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: BlocBuilder<GetOnbordingCubit, GetOnbordingState>(
                    builder: (context, state) {
                      if (state is GetOnbordingStateInSussess) {
                        final filterOnbordingData = state.onbordingdata
                            .where((data) => data.status == 1)
                            .toList();

                        totalPages = filterOnbordingData.length;
                        return PageView.builder(
                          controller: pageController,
                          itemCount: totalPages,
                          onPageChanged: (index) => setState(() {
                            if (index > _selectedIndex) {
                              value = (_selectedIndex + 1) / totalPages;
                            } else {
                              value = (_selectedIndex - 1) / totalPages;
                            }
                            _selectedIndex = index;
                          }),
                          itemBuilder: (context, index) {
                            return Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: Column(
                                children: <Widget>[
                                  const Spacer(),
                                  Container(
                                    height: size.height * 0.4,
                                    width: size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Image.network(
                                        filterOnbordingData[index]
                                            .image
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: size.height * 0.45,
                                    width: size.width,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                child: AnimatedText(
                                                  des: false,
                                                  desc:
                                                      filterOnbordingData[index]
                                                          .title
                                                          .toString(),
                                                  textStye: const TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 28,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: size.height * 0.1 + 30,
                                                width: size.width,
                                                child: AnimatedText(
                                                  des: true,
                                                  desc:
                                                      filterOnbordingData[index]
                                                          .description
                                                          .toString(),
                                                  textStye: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: size.height * 0.06),
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (_selectedIndex <
                                                    totalPages - 1) {
                                                  setState(() {
                                                    value =
                                                        (_selectedIndex + 1) /
                                                            totalPages;
                                                  });
                                                  await pageController.nextPage(
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeInOut,
                                                  );
                                                } else if (_selectedIndex ==
                                                    totalPages - 1) {
                                                  setState(() {
                                                    value += 1;
                                                  });
                                                  await jumpToMainPage();
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        height: 90,
                                                        child: CircularProgressIndicator(
                                                            strokeWidth: 3,
                                                            value: value,
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    209,
                                                                    210,
                                                                    214),
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    indicatorColor1)),
                                                      ),
                                                      Center(
                                                        child: Container(
                                                          width: 65,
                                                          height: 65,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            40)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x29000000),
                                                                offset: Offset(
                                                                    0, 3),
                                                                blurRadius: 6,
                                                              ),
                                                            ],
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                onboardingButtonColor1,
                                                                onboardingButtonColor2,
                                                              ],
                                                            ),
                                                          ),
                                                          child: const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            color: whiteColor,
                                                            size: 40,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> jumpToMainPage() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isFirstTimeUser', false);
    await navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute<MyHomePage>(
        builder: (_) => MyHomePage(webUrl: webInitialUrl),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  AnimatedText(
      {super.key,
      required this.desc,
      required this.textStye,
      required this.des});

  final String desc;
  final TextStyle textStye;
  bool des;
  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;

  late Animation<double> animation;

  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(
      parent: expandController,
      curve: const Interval(
        0.0,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: expandController,
        curve: const Interval(
          0.4,
          0.7,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    expandController.forward();
  }

  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          maxLines: widget.des ? 4 : 2,
          overflow: TextOverflow.ellipsis,
          widget.desc,
          style: widget.textStye,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
