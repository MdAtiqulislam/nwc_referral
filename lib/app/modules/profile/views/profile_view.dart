import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:nwc_referral/app/routes/app_pages.dart';
import 'package:nwc_referral/common_widgets/app_button.dart';
import 'package:nwc_referral/common_widgets/custom_circle_avatar.dart';
import 'package:nwc_referral/common_widgets/custom_loading_screen.dart';
import 'package:nwc_referral/constraints/app_colors.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Obx(()=>Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCircleAvatar(
                        width: 100.spMax,
                        height: 100.spMax,
                        image: controller.userData.value.avatar??"",
                      border: 5,
                      bgColor: AppColors.inactiveColor,
                    ),
                    // SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.EDIT_PROFILE_PAGE);
                      },
                      icon: Icon(Icons.edit, size: 16.sp,color: AppColors.primaryColor,),
                      label: BodyText(text: "Edit Profile",color: AppColors.primaryColor,),
                    ),
                    // SizedBox(height: 8),
                    HeaderText(
                      text:  controller.userData.value.name??"",
                      size: 18,
                    ),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    Container(
                      padding: EdgeInsets.all(AppDimensions.widgetPadding.r),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileDetail("Name", controller.userData.value.name??""),
                          profileDetail("Occupation", controller.userData.value.sourceOccupation??""),
                          profileDetail("Email", controller.userData.value.email??""),
                          profileDetail("Mobile", controller.userData.value.phone??""),
                          profileDetail("Present Country", controller.selectedCountry.value.name??" "),
                          profileDetail("Present City", controller.userData.value.city??""),
                          profileDetail("Nearest Office", "${controller.selectedOffice.value.name??""}: ${controller.selectedOffice.value.address??""}"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    AppButton(
                      text: "Log Out",
                      onTap: (){
                        controller.logOut();
                      },
                      textTransform: TextTransform.none,
                      leading: Icon(Icons.logout,color: Colors.white,size: 24.sp,),
                      borderColor: AppColors.primaryColor,
                      bgColor: AppColors.primaryColor,
                      borderRadius: 10.r,
                    )
                  ],
                ),
              ),
            ),
            if(controller.isLoading.value)LoadingScreen()
          ],
        ),),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }

  Widget profileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: HeaderText(text:"$title:",align: TextAlign.start,size: 14,),),
          Expanded(
            flex: 3,
              child: BodyText(text: value,align: TextAlign.start,),),
        ],
      ),
    );
  }
}
