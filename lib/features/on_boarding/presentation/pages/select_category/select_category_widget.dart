part of 'select_category_screen.dart';

Widget selectCategoryHeaderView(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      OnBoardingKeys.lookingFor.stringToString
          .titleBold(color: AppColors.black3939, size: 14.sp)
          .singleSidePadding(left: AppDimensions.medium, right: AppDimensions.medium, top: AppDimensions.medium),
      SearchTextFieldWidget(
        onChanged: (value) {
          context.read<CategoriesBloc>().add(CategorySearchEvent(query: value));
        },
      ).symmetricPadding(horizontal: AppDimensions.medium, vertical: 10.w),
      OnBoardingKeys.recommendedCategories.stringToString
          .titleBold(color: AppColors.black3939, size: 14.sp)
          .symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.smallXL),
    ],
  );
}
