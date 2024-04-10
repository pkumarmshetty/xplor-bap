import '../config/routes/path_routing.dart';
import '../const/local_storage/pref_const_key.dart';
import '../const/local_storage/shared_preferences_helper.dart';

String checkRouteBasedOnUserJourney() {
  var route = Routes.chooseRole;
  var kycVerified = SharedPreferencesHelper().getBoolean(PrefConstKeys.kycVerified);
  var roleAssigned = SharedPreferencesHelper().getBoolean(PrefConstKeys.roleAssigned);

  if (roleAssigned && !kycVerified) {
    route = Routes.kyc;
  } else if (roleAssigned && kycVerified) {
    route = Routes.home;
  } else {
    route = Routes.chooseRole;
  }

  return route;
}
