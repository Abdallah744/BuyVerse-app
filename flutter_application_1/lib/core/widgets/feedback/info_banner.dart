import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// The amber "Location — tap to update on map" prompt on Edit Profile.
/// Generic enough to reuse anywhere a tappable info banner is needed.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.location_on_outlined,
    this.onTap,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bannerBackground,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.bannerBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 15, color: AppColors.bannerText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.bannerText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
