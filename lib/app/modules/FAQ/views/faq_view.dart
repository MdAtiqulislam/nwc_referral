import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:nwc_referral/constraints/app_colors.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';

import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: Text('FAQ'),
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            itemCount: controller.faqs.length,
            itemBuilder: (context, index) {
              var faq = controller.faqs[index];
              bool isExpanded = controller.expandedIndices[index];

              return Container(
                margin: EdgeInsets.only(bottom: AppDimensions.contentPadding.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                  color: Color(0xffF5F5F5),
                ),
                child: ExpansionTile(
                  title: HeaderText(
                    text: "${index + 1}. ${faq.question}",
               color: AppColors.primaryColor,
                    align: TextAlign.start,
                    maxLine: 5,
                    size: 14,
                  ),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (expanded) => controller.toggleExpansion(index),
                  tilePadding: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                    side: BorderSide.none, // Removes border
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                    side: BorderSide.none, // Removes border
                  ),
                  trailing: Obx(() => Image.asset(
                    controller.expandedIndices[index]
                      ? "assets/icons/arrow_up.png"
                      : "assets/icons/arrow_down.png",)/*Icon(
                    controller.expandedIndices[index]
                        ? Icons.arrow_circle_up
                        : Icons.arrow_drop_down_circle_outlined,
                    color: Colors.blue,
                  )*/),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child: BodyText(text:faq.ans ?? "",size: 12,maxLine: 50,align: TextAlign.start,),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}

