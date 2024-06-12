import 'dart:convert';

class SearchPostEntity {
  final String deviceId;
  final String searchText;
  final String initialIndex;
  final String lastIndex;

  SearchPostEntity(
      {required this.deviceId, required this.searchText, required this.initialIndex, required this.lastIndex});

  String toJson() {
    return json.encode({'deviceId': deviceId, 'searchQuery': searchText, "itemIds": [], "providerIds": []});
  }
}
