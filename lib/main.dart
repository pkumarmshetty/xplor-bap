import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/health_record/HealthRecord.dart';
import 'package:xplor/features/teleconsultation/teleconsultation.dart';
import 'app/xplorapp.dart';
import 'utils/app_utils/app_utils.dart';
import 'const/bootstrap.dart';
import 'core/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  // Check if token is saved
  final bool isLoggedIn = await AppUtils.checkToken();
  //const bool isLoggedIn = false;

  // Bootstrap the app
  bootstrap(() {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        // return XplorApp(isLoggedIn: isLoggedIn);
        return Teleconsultation();
      },
    );
  });
}
