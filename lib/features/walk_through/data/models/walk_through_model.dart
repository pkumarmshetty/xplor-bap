import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';

/// Model for Walk Through Screens
class WalkThroughModel {
  final String image, title, subTitle;

  WalkThroughModel({
    required this.image,
    required this.title,
    required this.subTitle,
  });
}

List<WalkThroughModel> walkThroughModel = [
  WalkThroughModel(
      image: Assets.images.infoFirst,
      title: OnBoardingKeys.titleStep1.stringToString,
      subTitle: OnBoardingKeys.titleDesStep1.stringToString),
  WalkThroughModel(
      image: Assets.images.infoSecond,
      title: OnBoardingKeys.titleStep2.stringToString,
      subTitle: OnBoardingKeys.titleDesStep2.stringToString),/*
  WalkThroughModel(
      image: Assets.images.infoFirst,
      title: OnBoardingKeys.titleStep3.stringToString,
      subTitle: OnBoardingKeys.titleDesStep3.stringToString)*/
];
