import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/controllers/add_or_update_student_new_controller.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:nwc_referral/app/modules/homePage/views/how_it_works_widget.dart';
import 'package:nwc_referral/app/modules/homePage/views/refer_info_card.dart';
import 'package:nwc_referral/app/routes/app_pages.dart';
import 'package:nwc_referral/common_widgets/app_button.dart';
import 'package:nwc_referral/common_widgets/custom_circle_avatar.dart';
import 'package:nwc_referral/common_widgets/my_drawer.dart';
import 'package:nwc_referral/constraints/app_colors.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';
import '../../../../common_widgets/customImageSlider.dart';
import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  HomePageView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        top: false,
        child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: CustomCircleAvatar(
                      width: 50,
                      height: 50,
                      border: 2,
                      bgColor: AppColors.inactiveColor,
                      image: controller.userData.value.avatar ?? "",
                    ),
                  ),
                  const SizedBox(width: 10), // Add spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align text to the left
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BodyText(
                        text: "Hi, Welcome Back,",
                        color: AppColors.bodyTextColor,
                        size: 12,
                        resizeAble: false,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      HeaderText(
                        text: controller.userData.value.name ?? "",
                        size: 16,
                        resizeAble: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            drawer: MyDrawer(),
            bottomNavigationBar: CustomBottomNavigationBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: AppDimensions.widgetPadding.h,
                        ),
                        if ((controller.homeData.value.data?.slider ?? [])
                            .isEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.inactiveColor,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadius.r),
                            ),
                            height: 200.spMax,

                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 1.5,),
                            ),
                          ),
                        if ((controller.homeData.value.data?.slider ?? [])
                            .isNotEmpty)
                          CustomImageSlider(
                            slider:
                                controller.homeData.value.data?.slider ?? [],
                            fit: BoxFit.cover,
                            height: 200.spMax,
                          ),
                        SizedBox(
                          height: AppDimensions.widgetPadding.h,
                        ),
                        referSection(),
                        SizedBox(
                          height: AppDimensions.widgetPadding.h,
                        ),
                      ],
                    ),
                  ),
                  HowItWorksWidget(
                      qFormLink:
                          controller.homeData.value.data?.qFormLink ?? ""),
                ],
              ),
            )),
      ),
    );
  }

  Widget referSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReferInfoCard(
              icon: "assets/images/info_card_group.png",
              title: "Referred Students",
              subtitle:
                  "${controller.estimatedIncome.value.totalLead ?? 0} Students",
              bgColor: Color(0xffB3E5FC),
            ),
            // SizedBox(width: AppDimensions.contentPadding.w),
            ReferInfoCard(
              icon: "assets/images/info_card_deposits.png",
              title: "Total Offers",
              subtitle:
                  "${controller.estimatedIncome.value.leadHasOffer??""} Offers",
              bgColor: Color(0xffD6E4FF),
            ),
            // SizedBox(width: 8),
            ReferInfoCard(
              icon: "assets/images/info_card_total_earning.png",
              title: "Estimated Income",
              subtitle:
                  "£${controller.estimatedIncome.value.estimatedIncome??"0"} ",
              bgColor: Color(0xffEED1F1),
            ),
          ],
        ),
        SizedBox(
          height: AppDimensions.widgetPadding.h,
        ),
        AppButton(
            text: "Refer & Earn Now",
            bgColor: AppColors.primaryColor,
            borderColor: AppColors.primaryColor,
            borderRadius: 10.r,
            textTransform: TextTransform.none,
            onTap: () {
              Get.put(AddOrUpdateStudentNewController()).getPrimaryData();
              Get.find<AddOrUpdateStudentNewController>().resetFields();
              Get.toNamed(Routes.ADD_OR_UPDATE_STUDENT_NEW);
            })
      ],
    );
  }
}
