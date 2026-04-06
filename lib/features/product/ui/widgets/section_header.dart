import 'package:flutter/material.dart';
import 'export_allthings.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onViewAll,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: r.titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: r.captionFontSize, color: AppColors.textMid),
                ),
            ],
          ),
          const Spacer(),
          if (onViewAll != null)
            Semantics(
              button: true,
              label: AppStrings.viewAll,
              child: InkWell(
                onTap: onViewAll,
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.isPhone ? 14 : 18,
                    vertical: r.isPhone ? 7 : 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.viewAll,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: r.captionFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded, color: AppColors.white, size: r.isPhone ? 13 : 15),
                    ],
                  ),
                ),
              ),
            ),
            
        ],
      ),
    );
  }
}
