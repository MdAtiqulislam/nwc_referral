import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar_controller.dart';
import 'package:nwc_referral/app/routes/app_pages.dart';
import '../app/data/my_drawer_controller.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import 'custom_circle_avatar.dart';
import 'custom_loading_screen.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final MyDrawerController controller = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SafeArea(
        child: Stack(
          children: [
            Drawer(
              backgroundColor: Colors.white,
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Get.width * .8
                  : Get.width * .5,
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w,//AppDimensions.horizontalPadding,
                      vertical: 24.h//AppDimensions.verticalPadding
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: AppDimensions.widgetPadding.h,
                      ),
                      Stack(
                        children: [
                          CustomCircleAvatar(
                            width: 100,
                            height: 100,
                            image: controller.userData.value.avatar ?? '',
                            bgColor: AppColors.inactiveColor,
                            fit: BoxFit.cover,
                            border: 5,
                          ),
                         /* Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.white54,
                                    onTap: () {
                                      // controller.chooseImage();

                                      Get.bottomSheet(choseImage());
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ))*/
                        ],
                      ),
                      SizedBox(
                          height: AppDimensions.contentPadding.h,
                      ),
                      HeaderText(
                        text: controller.userData.value.name ?? "",
                        align: TextAlign.start,
                        maxLine: 3,
                      ),
                      BodyText(text: controller.userData.value.email ?? ""),
                      BodyText(text: controller.userData.value.phone ?? ""),
                      if(controller.userData.value.country!=null) BodyText(
                          text: "${controller.userData.value.city ?? ""}, "
                              "${controller.countryList[controller.countryList.indexWhere((element) => element.id == controller.userData.value.country)].name ?? ""}"
                      ),
                      BodyText(
                          text:
                          controller.userData.value.sourceOccupation ?? ""),
                      SizedBox(
                          height: AppDimensions.widgetPadding.h,
                      ),
                      const Divider(),
                      drawerButton(
                          onTap: (){
                            Get.back();
                            Get.offAllNamed(Routes.HOME_PAGE);
                            Get.put(CustomBottomNavigationController()).selectedIndex.value=0;
                          },
                          icon: Icon(Icons.home_outlined,color: AppColors.bodyTextColor,size: 20.sp,),
                          text: "Home",
                        textColor: AppColors.bodyTextColor
                      ),

                      drawerButton(
                          onTap: (){
                            Get.back();
                            Get.toNamed(Routes.PROFILE);
                            Get.put(CustomBottomNavigationController()).selectedIndex.value=3;
                          },
                          icon: Icon(Icons.account_circle_outlined,color: AppColors.bodyTextColor,size: 20.sp,),
                          text: "Profile",
                        textColor: AppColors.bodyTextColor
                      ),
                      drawerButton(
                          onTap: (){
                            Get.back();
                            Get.toNamed(Routes.CONTACT_US);
                            Get.put(CustomBottomNavigationController()).selectedIndex.value=2;
                          },
                          icon: Icon(Icons.near_me_outlined,color: AppColors.bodyTextColor,size: 20.sp,),
                          text: "Contact Us",
                        textColor: AppColors.bodyTextColor
                      ),
                      drawerButton(
                          onTap: (){
                            Get.back();
                            Get.toNamed(Routes.FAQ);
                            Get.put(CustomBottomNavigationController()).selectedIndex.value=4;
                          },
                          icon: Icon(Icons.question_mark,color: AppColors.bodyTextColor,size: 20.sp,),
                          text: "FAQ",
                        textColor: AppColors.bodyTextColor
                      ),
                      Divider(),

                      drawerButton(
                          onTap: (){
                            controller.logOut();
                          },
                          icon: Icon(Icons.logout,color: AppColors.bodyTextColor,size: 20.sp,),
                          text: "Log Out",
                          textColor: AppColors.bodyTextColor
                      ),
                      if(Platform.isIOS)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          iconColor: AppColors.primaryColor,
                          onTap: () {
                            controller.removeAccount();
                          },
                          leading:  Icon(Icons.delete,size: 20.sp,),
                          title: const HeaderText(
                            text: "Delete Your Account",
                            align: TextAlign.start,
                            color: AppColors.primaryColor,
                          ),
                        ),
                    ],
                  )),
            ),
            if (controller.isLoading.value) const LoadingScreen()
          ],
        ),
      ),
    );
  }


  Widget drawerButton(
      {required VoidCallback onTap,
        required Widget icon,
        required String text,
        double? textSize,
        Color? textColor
      })
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r)),
      child: Material(
        color: Colors.transparent,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: AppDimensions.widgetPadding.w,
                ),
                HeaderText(
                  text: text,
                  size: textSize??14,
                  fontWeight: FontWeight.normal,
                  color: textColor??AppColors.headerTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
