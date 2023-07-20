import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_animated_app/constanins.dart';
import 'package:tesla_animated_app/home_controller.dart';

import '../models/TyrePsi.dart';
import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/temp_details.dart';
import 'components/tesla_bottom_navigationbar.dart';
import 'components/tmp_btn.dart';
import 'components/tyre_psi_card.dart';
import 'components/tyres.dart';
import 'components/spotify_player.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationontroller;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

  late AnimationController _tyreAnimationContreller;
  late Animation<double> _animationTyre1Psi;
  late Animation<double> _animationTyre2Psi;
  late Animation<double> _animationTyre3Psi;
  late Animation<double> _animationTyre4Psi;

  late List<Animation<double>> _tyreAnimations;

  late AnimationController _spotifyAnimationController;

  void setupBatteryAnimation() {
    _batteryAnimationontroller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationontroller,
      curve: Interval(0.0, 0.5),
    );
    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationontroller,
      curve: Interval(0.6, 1),
    );
  }

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.2, 0.4),
    );
    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.45, 0.65),
    );
    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.7, 1),
    );
  }

  void setupTyreAnimation() {
    _tyreAnimationContreller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _animationTyre1Psi = CurvedAnimation(
        parent: _tyreAnimationContreller, curve: Interval(0.34, 0.5));
    _animationTyre2Psi = CurvedAnimation(
        parent: _tyreAnimationContreller, curve: Interval(0.5, 0.66));
    _animationTyre3Psi = CurvedAnimation(
        parent: _tyreAnimationContreller, curve: Interval(0.66, 0.82));
    _animationTyre4Psi = CurvedAnimation(
        parent: _tyreAnimationContreller, curve: Interval(0.82, 1));
    _tyreAnimations = [
      _animationTyre1Psi,
      _animationTyre2Psi,
      _animationTyre3Psi,
      _animationTyre4Psi,
    ];
  }

  void setupSpotifyAnimation() {
    _spotifyAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    setupTyreAnimation();
    setupSpotifyAnimation();

    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationontroller.dispose();
    _tempAnimationController.dispose();
    _tyreAnimationContreller.dispose();
    _spotifyAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _batteryAnimationontroller,
          _tempAnimationController,
          _tyreAnimationContreller,
          _spotifyAnimationController,
        ]),
        builder: (context, _) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {
                if (index == 1)
                  _batteryAnimationontroller.forward();
                else if (_controller.selectedBottomTab == 1 && index != 1)
                  _batteryAnimationontroller.reverse(from: 0.7);

                if (index == 2)
                  _tempAnimationController.forward();
                else if (_controller.selectedBottomTab == 2 && index != 2)
                  _tempAnimationController.reverse(from: 0.4);
                if (index == 3)
                  _tyreAnimationContreller.forward();
                else if (_controller.selectedBottomTab == 3 && index != 3)
                  _tyreAnimationContreller.reverse();
                if (index == 4)
                  _spotifyAnimationController.forward();
                else if (_controller.selectedBottomTab == 4 && index != 4)
                  _spotifyAnimationController.reverse();

                _controller.showTyreController(index);
                _controller.tyreStatusController(index);
                _controller.onBottomNavigationTabChange(index);
              },
              selectedTab: _controller.selectedBottomTab,
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                      ),
                      Positioned(
                        left:
                            constraints.maxWidth / 2 * _animationCarShift.value,
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: constraints.maxHeight * 0.1),
                          child: SvgPicture.asset(
                            "assets/Car.svg",
                            width: double.infinity,
                          ),
                        ),
                      ),

                      //battery
                      Opacity(
                        opacity: _animationBattery.value,
                        child: SvgPicture.asset(
                          "assets/Battery.svg",
                          width: constraints.maxWidth * 0.45,
                        ),
                      ),
                      Positioned(
                        top: 50 * (1 - _animationBatteryStatus.value),
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Opacity(
                          opacity: _animationBatteryStatus.value,
                          child: BatteryStatus(constraints: constraints),
                        ),
                      ),
                      //temp

                      Positioned(
                        right: -100 * (1 - _animationCoolGlow.value),
                        child: AnimatedSwitcher(
                          duration: defaultDuration,
                          child: _controller.isCoolSelected
                              ? Image.asset(
                                  "assets/Cool_glow_2.png",
                                  key: UniqueKey(),
                                  width: 200,
                                )
                              : Image.asset(
                                  "assets/Hot_glow_4.png",
                                  key: UniqueKey(),
                                  width: 200,
                                ),
                        ),
                      ),
                      //Spotify
                      Positioned(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Opacity(
                          opacity: _spotifyAnimationController.value,
                          child: SpotifyPlayer(),
                        ),
                      ),
                      if (_controller.isShowTyre) ...tyres(constraints),
                      if (_controller.isShowTyreStatus)
                        GridView.builder(
                          itemCount: 4,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: defaultPadding,
                            crossAxisSpacing: defaultPadding,
                            childAspectRatio:
                                constraints.maxWidth / constraints.maxHeight,
                          ),
                          itemBuilder: (context, index) => ScaleTransition(
                            scale: _tyreAnimations[index],
                            child: TyrePsiCard(
                              isBottomTwoTyre: index > 1,
                              tyrePsi: demoPsiList[index],
                            ),
                          ),
                        ),
                      //Lock
                      AnimatedPositioned(
                        duration: defaultDuration,
                        right: _controller.selectedBottomTab == 0
                            ? constraints.maxWidth * 0.05
                            : constraints.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isRightDoorLock,
                            press: _controller.updateRightDoorLock,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: defaultDuration,
                        left: _controller.selectedBottomTab == 0
                            ? constraints.maxWidth * 0.05
                            : constraints.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isLeftDoorLock,
                            press: _controller.updateLeftDoorLock,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: defaultDuration,
                        top: _controller.selectedBottomTab == 0
                            ? constraints.maxHeight * 0.13
                            : constraints.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isBonnetLock,
                            press: _controller.updateBonnetDoorLock,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: defaultDuration,
                        bottom: _controller.selectedBottomTab == 0
                            ? constraints.maxHeight * 0.17
                            : constraints.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isTrunkLock,
                            press: _controller.updateTrunkDoorLock,
                          ),
                        ),
                      ),
                      Positioned(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        top: 60 * (1 - _animationTempShowInfo.value),
                        child: Opacity(
                          opacity: _animationTempShowInfo.value,
                          child: TempDetails(controller: _controller),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}
