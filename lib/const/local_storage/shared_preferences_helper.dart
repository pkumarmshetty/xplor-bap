import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;
  late SharedPreferences _sharedPreferences;

  factory SharedPreferencesHelper() {
    _instance ??= SharedPreferencesHelper._();
    return _instance!;
  }

  SharedPreferencesHelper._();

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Define your methods to get and set data using _sharedPreferences.
  // For example:

  String getString(String key, {String defaultValue = 'NA'}) {
    return _sharedPreferences.getString(key) ?? defaultValue;
  }

  bool getBoolean(String key) {
    return _sharedPreferences.getBool(key) ?? false;
  }

  Future<bool> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }

  Future<bool> setBoolean(String key, bool value) {
    return _sharedPreferences.setBool(key, value);
  }

// Add more methods as needed.
}
