import 'package:shared_preferences/shared_preferences.dart';

part 'pref_const_key.dart';

class SharedPreferencesHelper {
  late SharedPreferences sharedPreferences;

  Future<dynamic> init({SharedPreferences? preferences}) async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // Define your methods to get and set data using _sharedPreferences.
  // For example:

  String getString(String key, {String defaultValue = 'NA'}) {
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0}) {
    return sharedPreferences.getDouble(key) ?? defaultValue;
  }

  bool getBoolean(String key) {
    return sharedPreferences.getBool(key) ?? false;
  }

  Future<bool> setString(String key, String value) {
    return sharedPreferences.setString(key, value);
  }

  Future<bool> setDouble(String key, double value) {
    return sharedPreferences.setDouble(key, value);
  }

  Future<bool> setBoolean(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    return sharedPreferences.getStringList(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) {
    return sharedPreferences.setStringList(key, value);
  }

// Add more methods as needed.
}
