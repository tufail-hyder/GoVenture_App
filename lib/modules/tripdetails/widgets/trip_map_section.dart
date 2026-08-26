import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'section_title.dart';

class TripMapSection extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String location;
  final String meetingPoint;

  const TripMapSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.location,
    this.meetingPoint = '',
  });

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) return const SizedBox.shrink();

    final position = LatLng(latitude!, longitude!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TripSectionTitle('Location'),
        const SizedBox(height: AppSizes.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: SizedBox(
            height: 180,
            child: Stack(
              children: [
                AbsorbPointer(
                  absorbing: true,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: position, zoom: 12),
                    markers: {
                      Marker(
                        markerId: const MarkerId('trip_location'),
                        position: position,
                        infoWindow: InfoWindow(title: location),
                      ),
                    },
                    gestureRecognizers: const {},
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    liteModeEnabled: true,
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {

                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (meetingPoint.isNotEmpty) ...[
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              const Icon(Icons.pin_drop_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text('Meeting Point: $meetingPoint',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}