import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../blocs/select_category/categories_bloc.dart';
import '../../widgets/category_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/circluar_button.dart';
import '../../../../../utils/common_top_header.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../../../../utils/widgets/search_text_field_widget.dart';
import '../../../../../config/routes/path_routing.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/mapping_const.dart';
import '../../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import '../../../../multi_lang/presentation/blocs/bloc/translate_bloc.dart';

part 'select_category_widget.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  int translationCount = 0;

  @override
  void initState() {
    context.read<CategoriesBloc>().add(FetchCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TranslationBloc, TranslateState>(
        listener: (context, state) {
          if (state is TranslationLoaded && state.isNavigation) {
            //Navigator.pushNamed(context, Routes.walkThrough);
            translationCount++;
            if (translationCount == 1) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.seekerHome,
                (routes) => false,
              );
            }
          }
        },
        child: BlocListener<CategoriesBloc, CategoriesState>(listener: (context, state) {
          if (state is CategoriesFetchedState && state.selectCategoryState == SelectCategoryState.saved) {
            context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
                langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
                moduleTypes: seekerHomeModule,
                isNavigation: true));
            sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.category}Done', true);
          }
        }, child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: AppBackgroundDecoration(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      state is CategoriesFetchedState
                          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              CommonTopHeader(
                                  title: OnBoardingKeys.selectCategory.stringToString,
                                  onBackButtonPressed: () {
                                    Navigator.pop(context);
                                  }),
                              selectCategoryHeaderView(context),
                              Expanded(
                                child: GridView.count(
                                  crossAxisSpacing: AppDimensions.extraSmall.w,
                                  mainAxisSpacing: AppDimensions.extraSmall.w,
                                  childAspectRatio: 3 / 1.8,
                                  crossAxisCount: 2,
                                  padding: const EdgeInsets.only(bottom: 3 * AppDimensions.xxlLarge),
                                  children: state.categories.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final categoryData = entry.value;
                                    return CategoryWidget(
                                      category: categoryData.category!,
                                      isSelected: categoryData.isSelected!,
                                      onSelect: (result) {
                                        context
                                            .read<CategoriesBloc>()
                                            .add(CategorySelectedEvent(position: index, isSelected: result));
                                      },
                                    );
                                  }).toList(),
                                ).symmetricPadding(horizontal: AppDimensions.medium),
                              ),
                            ])
                          : Container(),
                      state is CategoriesFetchedState && state.categories.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircularButton(
                                  onPressed: () {
                                    context.read<CategoriesBloc>().add(CategoriesSaveEvent());
                                  },
                                  isValid: (state.selectedCategories.isNotEmpty),
                                  title: OnBoardingKeys.next.stringToString,
                                ).symmetricPadding(
                                  horizontal: AppDimensions.medium,
                                  vertical: AppDimensions.large.w,
                                ),
                              ],
                            )
                          : Container(),
                      BlocBuilder<TranslationBloc, TranslateState>(builder: (context, translateData) {
                        return translateData is TranslationLoading ||
                                (state is CategoriesFetchedState &&
                                    state.selectCategoryState == SelectCategoryState.loading) ||
                                (state is CategoriesFetchedState &&
                                    state.selectCategoryState == SelectCategoryState.saved)
                            ? const LoadingAnimation()
                            : Container();
                      }),
                    ],
                  ),
                ));
          },
        )));
  }
}
