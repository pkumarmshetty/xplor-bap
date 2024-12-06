import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/lang_translation_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../features/multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/circluar_button.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/list_view_card.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../on_boarding/presentation/blocs/choose_domain/choose_domain_bloc.dart';
import '../../../on_boarding/presentation/widgets/build_welcome.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TranslationBloc>().add(const GetLanguageListEvent());
    context.read<ChooseDomainBloc>().add(GetDeviceApiEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (val, result) {
              AppUtils.showAlertDialog(context, false);
            },
            child: Scaffold(
                backgroundColor: AppColors.white,
                body: AppBackgroundDecoration(
                    child: SafeArea(
                        child: BlocListener<TranslationBloc, TranslateState>(
                            listener: (context, state) {
                  if (state is TranslationLoaded && state.isNavigation) {
                    //Navigator.pushNamed(context, Routes.walkThrough);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.welcomePage,
                      (routes) => false,
                    );
                  }
                  if (state is LangListLoaded && state.message != null) {
                    // AppUtils.showSnackBar(context, state.message.toString());
                  }
                }, child: BlocBuilder<TranslationBloc, TranslateState>(
                  builder: (context, state) {
                    return SafeArea(
                        child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const WelcomeContentWidget(
                              title: 'Choose Language',
                              color: AppColors.textColor,
                              subTitle:
                                  'Select your preferred language for the interface.',
                            ),
                            AppDimensions.small.verticalSpace,
                            _bodyItem(state)
                          ],
                        ),
                        Wrap(
                          children: [
                            BlocBuilder<ChooseDomainBloc, ChooseDomainState>(
                                builder: (context, state) {
                              return CircularButton(
                                isValid: state is RegisterDeviceIdState,
                                title: 'Next',
                                onPressed: () {
                                  context.read<TranslationBloc>().add(
                                      ChooseLangCodeEvent(
                                          hasRegisterId: context
                                              .read<ChooseDomainBloc>()
                                              .isRegisterDeviceId));
                                },
                              ).singleSidePadding(
                                  bottom: kFloatingActionButtonMargin.w);
                            }),
                          ],
                        ),
                        if (state is TranslationLoading)
                          const LoadingAnimation()
                      ],
                    ).singleSidePadding(
                      top: kFloatingActionButtonMargin,
                      left: AppDimensions.medium,
                      right: AppDimensions.medium,
                    ));
                  },
                )))))));
  }

  _bodyItem(TranslateState state) {
    return Expanded(
        child: ListView(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.medium),
      children: [
        if (context.read<TranslationBloc>().recommendedLangModel != null)
          Row(
            children: [
              "Recommended Language"
                  .titleExtraBold(size: 14.sp, color: AppColors.navyBlue),
              " (Based on your location)"
                  .titleRegular(size: 12.sp, color: AppColors.grey6a6a6a),
            ],
          ),
        AppDimensions.small.verticalSpace,
        if (context.read<TranslationBloc>().recommendedLangModel != null)
          _itemView(
              context.read<TranslationBloc>().recommendedLangModel!,
              context.read<TranslationBloc>().recommendedLangModel ==
                  context.read<TranslationBloc>().selectedModel,
              0,
              false),
        AppDimensions.mediumXL.verticalSpace,
        if (context.read<TranslationBloc>().langModel.isNotEmpty)
          "Other Language"
              .titleExtraBold(size: 14.sp, color: AppColors.navyBlue),
        AppDimensions.small.verticalSpace,
        _languageSelectionListView(context.read<TranslationBloc>().langModel,
            selected: context.read<TranslationBloc>().selectedModel),
      ],
    ));
  }

  _languageSelectionListView(List<LanguageTranslationModel> langList,
      {LanguageTranslationModel? selected}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: langList.length,
        itemBuilder: (context, index) {
          return _itemView(langList[index], selected == langList[index], index,
              langList.length == index + 1);
        });
  }

  _itemView(LanguageTranslationModel langList, bool isSelected, int index,
      bool isLastIndex) {
    return CardItemView(
      title: langList.symbol,
      description: langList.language,
      langCode: langList.nativeLanguage,
      isSelected: isSelected,
      isLastIndex: isLastIndex,
      callback: () {
        if (!isSelected) {
          sl<SharedPreferencesHelper>().setString(
              PrefConstKeys.selectedLanguageCode, langList.languageCode);
          context
              .read<TranslationBloc>()
              .add(SelectLanguageEvent(selected: langList));
        }
      },
    );
  }
}
