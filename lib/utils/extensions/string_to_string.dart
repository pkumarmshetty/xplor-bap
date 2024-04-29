extension StringToStringExtension on String {
  String get stringToString {
    return this;
  }

  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
