import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openInMapsApp() async {
    if (latitude == null || longitude == null) return;

    final label = Uri.encodeComponent(location);
    final Uri url;

    if (Platform.isIOS) {
      // Apple Maps
      url = Uri.parse('https://maps.apple.com/?ll=$latitude,$longitude&q=$label');
    } else {
      // Android — Google Maps app (agar installed ho to seedha khulega)
      url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) return const SizedBox.shrink();

    final position = LatLng(latitude!, longitude!);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

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
                      Marker(markerId: const MarkerId('trip_location'), position: position, infoWindow: InfoWindow(title: location)),
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
                    onTap: _openInMapsApp,
                  ),
                ),
                // ===== Small hint badge — user ko pata chale tap-able hai =====
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.directions_rounded, size: 12, color: AppColors.primary),
                        SizedBox(width: 3),
                        Text('Open in Maps', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ],
                    ),
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
                    style: TextStyle(fontSize: 13, color: textSecondary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}