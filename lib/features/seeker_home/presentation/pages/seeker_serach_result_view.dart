import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/search_text_field_widget.dart';
import '../../../course_description/presentation/blocs/course_description_bloc.dart';
import '../../../course_description/presentation/blocs/course_description_event.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../blocs/seeker_search_result_bloc/seeker_search_result_bloc.dart';
import '../blocs/seeker_search_result_bloc/seeker_search_result_event.dart';
import '../blocs/seeker_search_result_bloc/seeker_search_result_state.dart';
import '../widgets/courses_preview_widget.dart';

/// A widget that provides a search result view for the seeker application.
class SeekerSearchResultView extends StatefulWidget {
  const SeekerSearchResultView({super.key});

  @override
  State<SeekerSearchResultView> createState() => _SeekerSearchResultViewState();
}

class _SeekerSearchResultViewState extends State<SeekerSearchResultView> {
  String label = "Marketing";
  final TextEditingController _searchController = TextEditingController();

  /// Initializes the search input text from shared preferences.
  @override
  void initState() {
    super.initState();
    final searchInputText =
        sl<SharedPreferencesHelper>().getString(PrefConstKeys.searchHomeInput);
    _searchController.text = searchInputText == "NA" ? "" : searchInputText;
    scrollController.addListener(_loadMoreData);
    context
        .read<SeekerSearchResultBloc>()
        .add(SearchSSEvent(search: _searchController.text, isFromSearch: true));
  }

  ScrollController scrollController = ScrollController();

  /// Disposes the search input text from shared preferences.
  @override
  void dispose() {
    scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Loads more data when the user scrolls to the bottom of the list.
  void _loadMoreData() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      context.read<SeekerSearchResultBloc>().add(
          SearchSSEvent(search: _searchController.text, isFromSearch: false));
    }
  }

  /// Searches for courses based on the input text.
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        BlocBuilder<SeekerSearchResultBloc, SeekerSearchResultState>(
            builder: (context, state) {
      return AppBackgroundDecoration(
        child: SafeArea(
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 38.w,
                      width: 38.w,
                      decoration: BoxDecoration(
                        color: AppColors.blueWith10Opacity,
                        // Set your desired background color
                        borderRadius: BorderRadius.circular(
                            10), // Set your desired border radius
                      ),
                      child: SvgPicture.asset(
                              height: AppDimensions.medium.w,
                              width: AppDimensions.medium.w,
                              Assets.images.icBack)
                          .paddingAll(padding: AppDimensions.smallXL),
                    ),
                  ),
                  AppDimensions.mediumXL.verticalSpace,
                  SearchTextFieldWidget(
                    controller: _searchController,
                    onSearch: search,
                  ),
                  AppDimensions.mediumXL.verticalSpace,
                  Expanded(
                    child: Stack(
                      children: [
                        _providerStreamBuilder(state),
                        _listViewData(state)
                      ],
                    ),
                  ),
                ],
              ).paddingAll(padding: AppDimensions.medium.sp),
            ),
          ]),
        ),
      );
    }));
  }

  /// Provides the list view data based on the state of the search result.
  Widget _listViewData(SeekerSearchResultState state) {
    if (state is SearchResultUpdatedState) {
      if (state.state == DataState.loading && state.providerData!.isEmpty) {
        return Center(
          child: Lottie.asset(
            Assets.files.search,
            height: 150.w,
            width: 150.w,
          ).paddingAll(padding: AppDimensions.medium),
        );
      } else if (state.state == DataState.success &&
          state.providerData!.isEmpty) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.images.noDocumentsAdded),
              AppDimensions.mediumXL.verticalSpace,
              SeekerHomeKeys.noDataFound.stringToString.titleExtraBold(
                color: AppColors.black,
                size: AppDimensions.mediumXL.sp,
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  /// Provides the list view data based on the state of the search result.
  _providerStreamBuilder(
    SeekerSearchResultState state,
  ) {
    if (state is SearchResultUpdatedState && state.providerData!.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        controller: scrollController,
        key: UniqueKey(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // Number of columns in the grid
            crossAxisSpacing: 10,
            // Gap between columns
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 3),
        itemCount: state.providerData!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                context.read<CourseDescriptionBloc>().add(
                    CourseSelectedEvent(course: state.providerData![index]));
                Navigator.pushNamed(context, Routes.courseDescription,
                    arguments:
                        context.read<SeekerSearchResultBloc>().transactionId);
              },
              child: CoursesPreviewWidget(
                course: state.providerData![index],
              ));
        },
      );
    } else {
      return const SizedBox();
    }
  }

  /// Searches for courses based on the input text.
  search(String input) {
    context
        .read<SeekerSearchResultBloc>()
        .add(SearchSSEvent(search: input, isFromSearch: true));
  }
}
