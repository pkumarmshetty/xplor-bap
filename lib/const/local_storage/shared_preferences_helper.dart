import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  late SharedPreferences sharedPreferences;

  Future<dynamic> init({SharedPreferences? preferences}) async {
    if (preferences != null) {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = preferences;
      return sharedPreferences;
    } else {
      sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  // Define your methods to get and set data using _sharedPreferences.
  // For example:

  String getString(String key, {String defaultValue = 'NA'}) {
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  bool getBoolean(String key) {
    return sharedPreferences.getBool(key) ?? false;
  }

  Future<bool> setString(String key, String value) {
    return sharedPreferences.setString(key, value);
  }

  Future<bool> setBoolean(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

// Add more methods as needed.
}
