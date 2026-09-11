import 'package:flutter/material.dart';

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
      color: const Color(0xFFFFF7ED),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Color(0xFFFFD6A8)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 15, color: Color(0xFFCA3500)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyRegular
                      .copyWith(color: Color(0xFFCA3500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
