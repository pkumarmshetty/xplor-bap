import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'card_title_widget.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, required this.selectedLocation});

  final String? selectedLocation;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
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
        children: [
          CardTitleWidget(
            title: HomeKeys.mapArea.stringToString,
            selectedLocation: widget.selectedLocation,
          ),
          AppDimensions.mediumXL.verticalSpace,
          _buildMapView(context),
        ],
      ),
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: const ['a', 'b', 'c'],
      );

  Marker _createMarker(LatLng latLng) {
    return Marker(
        point: latLng,
        width: 22.w,
        height: 22.w,
        alignment: Alignment.centerLeft,
        child: GestureDetector(onTap: () => _onMarkerTapped(latLng), child: SvgPicture.asset(Assets.images.mapMarker)));
  }

  LatLng? _tooltipPosition;
  bool _isTooltipVisible = false;
  late Point<double> points;

  _onMarkerTapped(LatLng latLng) {
    points = _mapController.camera.latLngToScreenPoint(latLng);
    setState(() {
      if (_isTooltipVisible && _tooltipPosition == latLng) {
        _isTooltipVisible = false;
      } else {
        _tooltipPosition = latLng;
        _isTooltipVisible = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  Widget _buildMapView(BuildContext context) {
    return SizedBox(
      height: 296.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.medium),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(30.744600, 76.652496),
                initialZoom: 13,
                // interactionOptions: const InteractionOptions(flags: InteractiveFlag.scrollWheelZoom, )
                onTap: (tapPosition, latLng) => {
                  setState(() {
                    _tooltipPosition = null;
                    _isTooltipVisible = false;
                  })
                },
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  // Update tooltip position when map position changes
                  if (_isTooltipVisible) {
                    setState(() {
                      points = _mapController.camera.latLngToScreenPoint(_tooltipPosition!);
                    });
                  }
                },
              ),
              mapController: _mapController,
              children: [
                openStreetMapTileLayer,
                MarkerLayer(markers: [
                  _createMarker(const LatLng(30.7457016, 76.6523029)),
                  _createMarker(const LatLng(30.7505065, 76.6375842)),
                  _createMarker(const LatLng(30.726522, 76.6494403)),
                  _createMarker(const LatLng(30.7379814, 76.6607737)),
                  _createMarker(const LatLng(30.7425424, 76.6724394)),
                ])
              ],
            ),
          ),
          if (_isTooltipVisible)
            Positioned(
              left: points.x - 80,
              top: points.y - 90,
              child: Tooltip(message: '', child: toolTipContent()),
            ),
        ],
      ),
    );
  }

  Widget toolTipContent() {
    return Container(
        padding: const EdgeInsets.all(AppDimensions.medium),
        decoration: BoxDecoration(
          color: AppColors.black272b30,
          borderRadius: BorderRadius.circular(AppDimensions.small),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Kharar'.titleMedium(color: AppColors.whiteefefef, size: AppDimensions.smallXL.sp),
            AppDimensions.extraSmall.verticalSpace,
            '${_tooltipPosition?.latitude}, ${_tooltipPosition?.longitude}'
                .titleBold(size: AppDimensions.smallXL.sp, color: AppColors.whiteefefef),
          ],
        ));
  }
}
