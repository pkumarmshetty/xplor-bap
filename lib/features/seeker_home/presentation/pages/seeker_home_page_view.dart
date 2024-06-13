import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:xplor/features/course_description/presentation/blocs/course_description_bloc.dart';
import 'package:xplor/features/course_description/presentation/blocs/course_description_event.dart';
import 'package:xplor/features/on_boarding/domain/entities/categories_entity.dart';
import 'package:xplor/features/seeker_home/presentation/blocs/seeker_dashboard_bloc/seeker_home_bloc.dart';
import 'package:xplor/features/seeker_home/presentation/blocs/seeker_dashboard_bloc/seeker_home_state.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../core/exception_errors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/search_text_field_widget.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';

import '../../domain/entities/get_response_entity/services_items.dart';
import '../blocs/seeker_dashboard_bloc/seeker_home_event.dart';
import '../../../../utils/widgets/courses_label.dart';
import '../widgets/courses_preview_widget.dart';
import '../widgets/seeker_app_bar_widget.dart';

class SeekerHomePageView extends StatefulWidget {
  const SeekerHomePageView({super.key});

  @override
  State<SeekerHomePageView> createState() => _SeekerHomePageViewState();
}

class _SeekerHomePageViewState extends State<SeekerHomePageView> {
  String? _selectedLabel;
  String label = "Art";
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<CategoryEntity> courseLabels = [];
  String address = "NA";

  @override
  void initState() {
    if (kDebugMode) {
      print("on init inside seeker home");
    }
    courseLabels.clear();
    String categoriesJson =
        sl<SharedPreferencesHelper>().getString(PrefConstKeys.listOfCategory);
    debugPrint('Category JSON.... $categoriesJson');
    List<dynamic> jsonList = jsonDecode(categoriesJson);

    String domains = sl<SharedPreferencesHelper>()
        .getString(PrefConstKeys.savedDomainsNames);

    debugPrint("Domains...$domains");

    courseLabels =
        jsonList.map((json) => CategoryEntity.fromJson(json)).toList();
    _determinePosition();
    final searchInputText = sl<SharedPreferencesHelper>()
        .getString(PrefConstKeys.searchCategoryInput);
    _searchController.text = searchInputText == "NA" ? "" : searchInputText;
    context
        .read<SeekerHomeBloc>()
        .add(const SeekerSSEvent(search: '', isFirstTime: true));
    scrollController.addListener(_loadMoreData);
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  void _loadMoreData() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      context
          .read<SeekerHomeBloc>()
          .add(const SeekerSSEvent(search: '', isFirstTime: false));
    }
  }

  // are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();

      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    sl<SharedPreferencesHelper>()
        .setDouble(PrefConstKeys.latitude, position.latitude);
    sl<SharedPreferencesHelper>()
        .setDouble(PrefConstKeys.longitude, position.longitude);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark firstPlacemark = placemarks.first;

    String city = firstPlacemark.locality ?? 'Unknown City';

    if (mounted) {
      _addressController.text = city;
      address = city;
      setState(() {});
    }

    return position;
  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print("dispose home");
    }
    _searchController.dispose();
    _addressController.dispose();
    scrollController.dispose();
    SSEClient.unsubscribeFromSSE();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SeekerHomeBloc, SeekerHomeState>(
      listener: (context, state) {
        if (kDebugMode) {
          print('current_bloc_state... $state');
        }
        if (state is SeekerHomeUpdatedState &&
            state.state == DataState.error &&
            state.errorMessage ==
                ExceptionErrors.checkInternetConnection.stringToString) {
          AppUtils.showSnackBar(context, state.errorMessage!);
        }
      },
      child: BlocBuilder<SeekerHomeBloc, SeekerHomeState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomScrollView(slivers: [
                // SliverAppBar with flexible space for image and overlay
                SeekerAppBarWidget(
                    address:
                        address == "NA" ? _addressController.text : address),
                // SliverToBoxAdapter with detailed information
                SliverToBoxAdapter(
                  child: _buildMainContent(state),
                ),
                SliverFillRemaining(child: _listViewData(state))
              ]),
            ],
          );
        },
      ),
    );
  }

  search(String input) {
    if (kDebugMode) {
      print(
          "context.read<SeekerHomeBloc>().add(SeekerSSEvent(search: val));  $input");
    }
    if (_searchController.text.isNotEmpty) {
      sl<SharedPreferencesHelper>()
          .setString(PrefConstKeys.searchHomeInput, _searchController.text);
      Navigator.pushNamed(context, Routes.seekerOnSearchResult);
      _searchController.clear();
    }
  }

  Widget _buildMainContent(SeekerHomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimensions.smallXL.vSpace(),
        SearchTextFieldWidget(
          controller: _searchController,
          onSearch: search,
        ),
        AppDimensions.medium.vSpace(),
        AspectRatio(
          aspectRatio: 13,
          child: ListView.separated(
            controller: scrollController,
            separatorBuilder: (context, index) {
              return 9.hSpace();
            },
            scrollDirection: Axis.horizontal,
            itemCount: courseLabels.length,
            itemBuilder: (context, index) {
              final label = courseLabels[index].category;
              final value = courseLabels[index].value;
              final isSelected = _selectedLabel == value;

              return CoursesLabel(
                label: label.toString(),
                isSelected: isSelected,
                value: value.toString(),
                onChanged: (selectedLabel) {
                  setState(() {
                    if (_selectedLabel == selectedLabel) {
                      _selectedLabel = null; // Deselect if already selected
                    } else {
                      _selectedLabel = selectedLabel;
                    }

                    String selectedValue =
                        _selectedLabel == selectedLabel ? value.toString() : "";

                    debugPrint("Selected category... $selectedValue");

                    context
                        .read<SeekerHomeBloc>()
                        .add(SeekerSSEvent(search: selectedValue));
                  });
                },
              );
            },
          ),
        ),
        if (state is SeekerHomeUpdatedState && state.providerData!.isNotEmpty)
          _providerData([], isProviderTitle: true),
        if (state is SeekerHomeUpdatedState && state.providerData!.isNotEmpty)
          _providerData(state.providerData!),
        AppDimensions.extraSmall.vSpace(),
        if (state is SeekerHomeUpdatedState && state.providerData!.isNotEmpty)
          _providerTrendingData([], isProviderTitle: true),
        if (state is SeekerHomeUpdatedState && state.providerData!.isNotEmpty)
          _providerTrendingData(state.providerData!.reversed.toList()),
        AppDimensions.mediumXL.vSpace(),
      ],
    ).symmetricPadding(horizontal: AppDimensions.medium.sp);
  }
}

_listViewData(SeekerHomeState state) {
  if (state is SeekerHomeUpdatedState) {
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
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.images.noDocumentsAdded),
              AppDimensions.mediumXL.vSpace(),
              SeekerHomeKeys.noDataFound.stringToString.titleExtraBold(
                color: AppColors.black,
                size: AppDimensions.mediumXL.sp,
              ),
            ],
          )
        ]),
      );
    }
  } else {
    return Container();
  }
}

_providerData(List<SearchItemEntity> provider, {bool isProviderTitle = false}) {
  return isProviderTitle
      ? coursesHeader(title: SeekerHomeKeys.recommendedCourses.stringToString)
      : AspectRatio(
          aspectRatio: 1.4,
          child: ListView.separated(
            key: UniqueKey(),
            separatorBuilder: (context, index) {
              return AppDimensions.smallXL.hSpace();
            },
            scrollDirection: Axis.horizontal,
            itemCount: provider.length,
            itemBuilder: (context, index) {
              return courseCardList(context, provider[index]);
            },
          ),
        );
}

_providerTrendingData(List<SearchItemEntity> provider,
    {bool isProviderTitle = false}) {
  return isProviderTitle
      ? coursesHeader(title: SeekerHomeKeys.trendingCourses.stringToString)
      : AspectRatio(
          aspectRatio: 1.4,
          child: ListView.separated(
            key: UniqueKey(),
            separatorBuilder: (context, index) {
              return AppDimensions.smallXL.hSpace();
            },
            scrollDirection: Axis.horizontal,
            itemCount: provider.length,
            itemBuilder: (context, index) {
              return courseCardList(context, provider[index]);
            },
          ),
        );
}

/*
_providerStreamBuilder(BuildContext context, {bool isProviderTitle = false}) {
  return StreamBuilder<List<SssDataModel>>(
      stream: context.read<SeekerHomeBloc>().providerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final products = snapshot.data!;
        return isProviderTitle
            ? coursesHeader(
                title: SeekerHomeKeys.recommendedCourses.stringToString)
            : AspectRatio(
                aspectRatio: 1.4,
                child: ListView.separated(
                  key: UniqueKey(),
                  separatorBuilder: (context, index) {
                    return AppDimensions.smallXL.hSpace();
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return courseCardList(context, products[index]);
                  },
                ),
              );
      });
}
*/

/*
_productStreamBuilder(BuildContext context, {bool isProductsTitle = false}) {
  return StreamBuilder<List<Item>>(
      stream: context.read<SeekerHomeBloc>().productStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final products = snapshot.data!;
        return isProductsTitle
            ? coursesHeader(title: SeekerHomeKeys.products.stringToString)
            : SizedBox(
                height: 87.w,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return AppDimensions.extraSmall.hSpace();
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final image = products[index].descriptor?.symbol;
                    return ProductsLabel(image: image!);
                  },
                ),
              );
      });
}
*/

Widget coursesHeader({required String title}) {
  return Column(
    children: [
      AppDimensions.medium.vSpace(),
      title.titleBold(size: AppDimensions.medium.sp),
      AppDimensions.small.vSpace(),
    ],
  );
}

Widget courseCardList(BuildContext context, SearchItemEntity data) {
  return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print("data adsadfa  ${data.domain}");
        }
        context
            .read<CourseDescriptionBloc>()
            .add(CourseSelectedEvent(course: data));
        Navigator.pushNamed(context, Routes.courseDescription,
            arguments: context.read<SeekerHomeBloc>().transactionId);
      },
      child: CoursesPreviewWidget(
        course: data,
      ));
}
