import 'package:flutter/material.dart';
import '../../../models/upcoming_booking_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class UpcomingTripListTile extends StatelessWidget {
  final UpcomingBookingModel booking;
  final VoidCallback onTap;

  const UpcomingTripListTile({super.key, required this.booking, required this.onTap,
  });

  static const _months = ['', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final date = booking.travelDate;
    final nights = (booking.duration ?? 0) > 0 ? booking.duration! - 1 : 0;
    final backgroundColor = isDark ? AppColors.surfaceDark : Colors.white;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd,),
          border: Border.all(color: dividerColor.withValues(alpha: 0.45),),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha:isDark ? 0.15 : 0.06,),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE + DATE BADGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusMd,),
                    topRight: Radius.circular(AppSizes.radiusMd,),
                  ),
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: booking.tripImage.isNotEmpty ? Image.network(booking.tripImage, fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace,) {
                        return Container(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                          child: Icon(Icons.image_not_supported_outlined, color: secondaryColor, size: 30,),
                        );
                      },
                    )
                        : Container(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      child: Icon(Icons.image_outlined, color: secondaryColor, size: 30,),
                    ),
                  ),
                ),

                // DATE BADGE
                if (date != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 43,
                      padding: const EdgeInsets.symmetric(vertical: 5,),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm,),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.15,),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${date.day}', style: TextStyle(color: AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w800, fontSize: 16, height: 1,),
                          ),
                          const SizedBox(height: 3),
                          Text(_months[date.month],
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 9, height: 1,),
                          ),
                        ],
                      ),
                    ),
                  ),

                // BOOKMARK BUTTON
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.bookmark_border_rounded, size: 18, color: AppColors.textPrimaryLight,),
                  ),
                ),
              ],
            ),

            // CONTENT
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 10,),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    booking.tripTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: titleColor, fontWeight: FontWeight.w700, fontSize: 13, height: 1.25,),
                  ),

                  const SizedBox(height: 7),

                  // DURATION
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: secondaryColor,),
                        const SizedBox(width: 5),
                        Text('${booking.duration ?? 0} Days · $nights Nights',
                          style: TextStyle(color: secondaryColor, fontSize: 11, fontWeight: FontWeight.w600,),
                        ),
                      ],
                    ),

                  const SizedBox(height: 9),

                  // DIVIDER
                  Container(height: 1, color: dividerColor.withValues(alpha: 0.45),),

                  const SizedBox(height: 8),
                  // PRICE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FROM', style: TextStyle(color: secondaryColor, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5,),
                            ),
                            const SizedBox(height: 2),
                            Text('PKR ${(booking.amount ?? 30000).toStringAsFixed(0)}',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16,),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.primary,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}