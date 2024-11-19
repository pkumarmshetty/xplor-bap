part of 'translate_bloc.dart';

Map<String, dynamic> getMapping(String type) {
  Map<String, dynamic> mapping = {};
  switch (type) {
    case onBoardingModule:
      mapping.clear();
      mapping.addAll(originalOnBoardingMap);
      return mapping;

    case homeModule:
      mapping.clear();
      mapping.addAll(originalHomeMap);
      return mapping;

    case walletModule:
      mapping.clear();
      mapping.addAll(originalWalletMap);
      return mapping;

    case profileModule:
      mapping.clear();
      mapping.addAll(originalProfileMap);
      return mapping;

    case seekerHomeModule:
      mapping.clear();
      mapping.addAll(originalSeekerHomeMap);
      return mapping;

    case networkErrorsModule:
      mapping.clear();
      mapping.addAll(originalNetworkErrorMaps);
      return mapping;

    default:
      mapping.clear();
      mapping.addAll(originalOnBoardingMap);
      return mapping;
  }
}
