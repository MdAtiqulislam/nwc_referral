import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nwc_referral/constraints/app_colors.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';

class ReferInfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color bgColor;

  const ReferInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.contentPadding),
      width: 110.w, // Adjust based on your layout needs
      height: 90.spMax,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon),
          const SizedBox(height: 8),
          HeaderText(
            text: title,
            color: Color(0xff2558B3),
            size: 10,
          ),
          const SizedBox(height: 4),
          BodyText(
            text: subtitle,
            size: 9,
          ),
        ],
      ),
    );
  }
}