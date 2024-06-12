import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/circluar_button.dart';

class LocationAccessPage extends StatefulWidget {
  const LocationAccessPage({super.key});

  @override
  State<LocationAccessPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationAccessPage> {
  bool isLoading = false;

  @override
  void initState() {
    _getDeviceId();
    // _determinePosition();

    super.initState();
  }

  _getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    sl<SharedPreferencesHelper>().setString(PrefConstKeys.deviceId, deviceId!);
  }

  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    setState(() {
      isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      updateData();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        updateData();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      updateData();
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    if (kDebugMode) {
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    }
    sl<SharedPreferencesHelper>().setDouble(PrefConstKeys.latitude, position.latitude);
    sl<SharedPreferencesHelper>().setDouble(PrefConstKeys.longitude, position.longitude);

    updateData();

    return position;
  }

  void updateData() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PopScope(
      canPop: false,
      onPopInvoked: (bool val) {
        AppUtils.showAlertDialog(context, false);
      },
      child: AppBackgroundDecoration(
          child: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SvgPicture.asset(
                  Assets.images.accessLocation,
                  width: MediaQuery.of(context).size.width, // Set the width of the SVG
                ).scaleYAnimated(),
                "Allow location\naccess".titleBlack(align: TextAlign.center).fadeAnimation(),
              ],
            ),
            AppDimensions.small.w.vSpace(),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: AppColors.textColor, fontSize: 14.0, fontWeight: FontWeight.w400),
                children: <TextSpan>[
                  TextSpan(text: 'Allow '),
                  TextSpan(
                      text: 'Discover',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 14.0, fontWeight: FontWeight.w800)),
                  TextSpan(text: ' to access this device’s location'),
                ],
              ),
            ).fadeAnimation(),
            const Spacer(),
            CircularButton(
              isValid: true,
              title: (!isLoading ? 'Allow' : 'Waiting'),
              onPressed: () async {
                await _determinePosition();

                _goToNext();
              },
            ).fadeInAnimated().symmetricPadding(horizontal: AppDimensions.medium),
          ],
        ).symmetricPadding(vertical: AppDimensions.medium.w),
      )),
    ));
  }

  _goToNext() {
    Navigator.pushReplacementNamed(context, Routes.selectLanguageScreen);
  }
}
