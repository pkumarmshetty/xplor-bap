/// A class representing dimensions used in the app.
class AppDimensions {
  static final AppDimensions _instance = AppDimensions._();

  /// Singleton instance

  /// Private constructor
  AppDimensions._();

  /// Factory method to return the singleton instance of [AppDimensions].
  factory AppDimensions() {
    return _instance;
  }

  static const double extraExtraSmall = 2.0;

  static const double extraSmall = 4.0;

  /// Extra small dimension
  static const double small = 8.0;

  /// Small dimension
  static const double smallXL = 12.0;

  /// Small extra large dimension
  static const double medium = 16.0;

  /// Medium dimension
  static const double mediumXL = 20.0;

  /// Medium extra large dimension
  static const double large = 24.0;

  /// Large dimension
  static const double xxl = 32.0;

  /// Extra extra large dimension
}
