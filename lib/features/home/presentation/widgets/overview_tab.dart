import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'card_title_widget.dart';
import 'map_widget.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';
import 'bar_graph_view.dart';
import 'earning_skill_widget.dart';
import 'line_graph_view.dart';

/// Overview Tab Widget
class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  //late DateTime _selectedDate;

  String? _selectedLocation;

  /* @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }*/

/*  void _navigateToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    });
  }

  void _navigateToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
    });
  }*/

  // default constructor
  /*MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 30.744600, longitude: 76.652496),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppDimensions.medium.sp),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.smallXL),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.searchShadowColor,
                  offset: Offset(0, 2),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                  child: EarningSkillWidget(
                iconPath: Assets.images.totalAmount,
                title: HomeKeys.totalEarnings.stringToString,
                subtitle: '₹200',
                isIncrease: true,
                color: AppColors.lightGreen.withOpacity(0.25),
              )),
              AppDimensions.medium.w.horizontalSpace,
              Expanded(
                  child: EarningSkillWidget(
                iconPath: Assets.images.claimedAmount,
                title: HomeKeys.totalSeekers.stringToString,
                subtitle: '512',
                isIncrease: false,
                color: AppColors.tabsSelectedColor.withOpacity(0.4),
              )),
            ],
          ),
        ),
        AppDimensions.mediumXL.verticalSpace,
        _lineGraphWidget(),
        AppDimensions.mediumXL.verticalSpace,
        _barGraphWidget(),
        AppDimensions.mediumXL.verticalSpace,
        MapWidget(selectedLocation: _selectedLocation),
        AppDimensions.mediumXL.verticalSpace
      ],
    );
  }

  _lineGraphWidget() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.medium.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.smallXL),
          boxShadow: const [
            BoxShadow(
              color: AppColors.searchShadowColor,
              offset: Offset(0, 2),
              blurStyle: BlurStyle.outer,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitleWidget(
            title: HomeKeys.totalSeekers.stringToString,
            selectedLocation: _selectedLocation,
          ),
          AppDimensions.extraSmall.verticalSpace,
          "1,509 ${HomeKeys.seekers.stringToString}".titleBold(size: 38.sp),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.extraSmall),
                decoration: BoxDecoration(
                  color: AppColors.activeGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.extraSmall),
                ),
                child: Row(children: [
                  SvgPicture.asset(
                    Assets.images.trendingUp,
                    height: AppDimensions.smallXL.sp,
                    width: AppDimensions.smallXL.sp,
                  ),
                  AppDimensions.extraSmall.w.horizontalSpace,
                  '37.8%'.titleBold(size: 12.sp, color: AppColors.activeGreen),
                ]),
              ),
              ' ${HomeKeys.vs.stringToString} Sep 8, 2024'.titleBold(size: 12.sp, color: AppColors.greyTextColor),
            ],
          ),
          AppDimensions.extraSmall.verticalSpace,
          const LineGraphView(),
        ],
      ),
    );
  }

  _barGraphWidget() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.medium.sp),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.smallXL),
          boxShadow: const [
            BoxShadow(
              color: AppColors.searchShadowColor,
              offset: Offset(0, 2),
              blurStyle: BlurStyle.outer,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitleWidget(
            title: HomeKeys.totalEarnings.stringToString,
            selectedLocation: _selectedLocation,
          ),
          AppDimensions.extraSmall.verticalSpace,
          const BarGraphView(),
        ],
      ),
    );
  }

// Widget _cardTitleView({required String title}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       title.titleBold(size: 18.sp, color: AppColors.black1a1d1f),
//       Container(
//           height: 40.w,
//           padding:
//               const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: AppColors.checkBoxDisableColor),
//               borderRadius: BorderRadius.circular(
//                   AppDimensions.smallXL) // Set border radius for all corners
//               ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton(
//               hint: SizedBox(
//                 width: 100.w,
//                 child: HomeKeys.sixWeeks.stringToString.titleSemiBold(
//                     color: AppColors.greyTextColor, size: 14.sp, maxLine: 1),
//               ),
//               value: _selectedLocation,
//               icon: const Icon(
//                 Icons.keyboard_arrow_down,
//                 color: AppColors.greyTextColor,
//               ),
//               onChanged: (newValue) {
//                 setState(() {
//                   _selectedLocation = newValue;
//                 });
//               },
//               items: [
//                 HomeKeys.lastSixWeeks.stringToString,
//                 HomeKeys.lastNineWeeks.stringToString
//               ].map((location) {
//                 return DropdownMenuItem(
//                   value: location,
//                   child: SizedBox(
//                     width: 100.w,
//                     child: location.titleSemiBold(
//                         color: AppColors.greyTextColor,
//                         size: 14.sp,
//                         maxLine: 1),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ))
//     ],
//   );
// }

// final MapController _mapController = MapController();
//
// Widget _buildMapView(BuildContext context) {
//   return SizedBox(
//     height: 296.w,
//     child: Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(AppDimensions.medium),
//           child: FlutterMap(
//             options: MapOptions(
//               initialCenter: const LatLng(30.744600, 76.652496),
//               initialZoom: 13,
//               // interactionOptions: const InteractionOptions(flags: InteractiveFlag.scrollWheelZoom, )
//               onTap: (tapPosition, latLng) => {
//                 setState(() {
//                   _tooltipPosition = null;
//                   _isTooltipVisible = false;
//                 })
//               },
//               onPositionChanged: (MapPosition position, bool hasGesture) {
//                 // Update tooltip position when map position changes
//                 if (_isTooltipVisible) {
//                   setState(() {
//                     points = _mapController.camera
//                         .latLngToScreenPoint(_tooltipPosition!);
//                   });
//                 }
//               },
//             ),
//             mapController: _mapController,
//             children: [
//               openStreetMapTileLayer,
//               MarkerLayer(markers: [
//                 _createMarker(const LatLng(30.7457016, 76.6523029)),
//                 _createMarker(const LatLng(30.7505065, 76.6375842)),
//                 _createMarker(const LatLng(30.726522, 76.6494403)),
//                 _createMarker(const LatLng(30.7379814, 76.6607737)),
//                 _createMarker(const LatLng(30.7425424, 76.6724394)),
//               ])
//             ],
//           ),
//         ),
//         if (_isTooltipVisible)
//           Positioned(
//             left: points.x - 80,
//             top: points.y - 90,
//             child: Tooltip(message: '', child: toolTipContent()),
//           ),
//       ],
//     ),
//   );
// }
//
// TileLayer get openStreetMapTileLayer => TileLayer(
//       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//       subdomains: const [
//         'a',
//         'b',
//         'c'
//       ], // OpenStreetMap tile servers subdomains
//     );
//
// Marker _createMarker(LatLng latLng) {
//   return Marker(
//       point: latLng,
//       width: 22.w,
//       height: 22.w,
//       alignment: Alignment.centerLeft,
//       child: GestureDetector(
//           onTap: () => _onMarkerTapped(latLng),
//           child: SvgPicture.asset(Assets.images.mapMarker)));
// }
//
// LatLng? _tooltipPosition;
// bool _isTooltipVisible = false;
// late Point<double> points;
//
// _onMarkerTapped(LatLng latLng) {
//   points = _mapController.camera.latLngToScreenPoint(latLng);
//     AppUtils.printLogs('latlng...$latLng');
//   // Set the marker position where the tooltip will be shown
//   setState(() {
//     if (_isTooltipVisible && _tooltipPosition == latLng) {
//       _isTooltipVisible = false;
//     } else {
//       _tooltipPosition = latLng;
//       _isTooltipVisible = true;
//     }
//   });
// }
//
// @override
// void dispose() {
//   super.dispose();
//   _mapController.dispose();
// }
//
// Widget toolTipContent() {
//   return Container(
//       padding: const EdgeInsets.all(AppDimensions.medium),
//       decoration: BoxDecoration(
//         color: AppColors.black272b30,
//         borderRadius: BorderRadius.circular(AppDimensions.small),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           'Kharar'.titleMedium(color: AppColors.whiteefefef, size: 12.sp),
//           AppDimensions.extraSmall.verticalSpace,
//           '${_tooltipPosition?.latitude}, ${_tooltipPosition?.longitude}'
//               .titleBold(size: 12.sp, color: AppColors.whiteefefef),
//         ],
//       ));
// }
//
// Widget _mapWidget() {
//   return Container(
//     padding: EdgeInsets.all(AppDimensions.medium.sp),
//     decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppDimensions.smallXL),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.searchShadowColor,
//             offset: Offset(0, 2),
//             blurStyle: BlurStyle.outer,
//             blurRadius: 2,
//             spreadRadius: 1,
//           ),
//         ]),
//     child: Column(
//       children: [
//         _cardTitleView(title: HomeKeys.mapArea.stringToString),
//         AppDimensions.mediumXL.verticalSpace,
//         _buildMapView(context),
//       ],
//     ),
//   );
// }
}
