import '../config/routes/path_routing.dart';
import '../const/local_storage/pref_const_key.dart';
import '../const/local_storage/shared_preferences_helper.dart';
import 'dependency_injection.dart';

String checkRouteBasedOnUserJourney() {
  var route = Routes.chooseRole;
  var kycVerified = sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.kycVerified);
  var roleAssigned = sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.roleAssigned);

  if (roleAssigned && !kycVerified) {
    route = Routes.kyc;
  } else if (roleAssigned && kycVerified) {
    route = Routes.home;
  } else {
    route = Routes.chooseRole;
  }

  return route;
}
