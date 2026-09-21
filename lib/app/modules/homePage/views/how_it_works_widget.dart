import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/customAppBar/app_bar_controller.dart';
import 'package:nwc_referral/common_widgets/app_button.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';

import '../../../../constraints/app_colors.dart';

class HowItWorksWidget extends StatelessWidget {
  final String? qFormLink;
  const HowItWorksWidget({this.qFormLink,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
      color: Color(0xffF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(
            text: "How It Works?",
          ),
          //const SizedBox(height: 5),
          const HeaderText(
            text: "Simple Step-By-Step Guide",
            color: AppColors.primaryColor,
            size: 16,
          ),
           SizedBox(height: AppDimensions.sectionPadding.h),
          SizedBox(
            width: Get.width,
              child: Image.asset("assets/images/how_it_works_steps.png",fit: BoxFit.fitWidth,)),
          const SizedBox(height: 20),
          referralLinkSection(),
        ],
      ),
    );
  }
  Widget referralLinkSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: BodyText(text: qFormLink??"",maxLine: 1,),),
                      BodyText(text: "(Form Link)"),
                    ],
                  ),
                ),
                SizedBox(width: AppDimensions.contentPadding.w,),
                Material(child: InkWell(onTap: () {

                  if (qFormLink != null && qFormLink!.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: qFormLink!));
                    Get.snackbar(
                      "Copied!",
                      "Link copied to clipboard",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  }
                }, child: HeaderText(text: "Copy"),),),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        AppButton(
          onTap: () {
            Get.put(AppBarController()).shareLink(link: qFormLink??"");
          },
          text: "Share",
          bgColor: AppColors.primaryColor,
          borderRadius: 10.r,
          borderColor: AppColors.primaryColor,
          textTransform: TextTransform.none,
          ),
      ],
    );
  }
}
