import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../common_widgets/custom_circle_avatar.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/app_strings.dart';
import '../../../constraints/body_text.dart';
import 'app_bar_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? minimal;
  final VoidCallback? openDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackButton;

  CustomAppBar({
    this.scaffoldKey,
    this.openDrawer,
    this.minimal,
    this.showBackButton = false, // Default to showing the back button
    super.key,
  });

  final appBarController = Get.put(AppBarController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => appBarController.isLoading.value
          ? AppBar()
          : Column(
            children: [
              SizedBox(height:MediaQuery.of(context).padding.top ),
              Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.shadowColor, width: 1.h),
                    ),
                  ),
                  height: 70.h,
                  child: Row(
                    children: [
                      if (showBackButton &&
                          Navigator.canPop(
                              context)) // Show back button if there's a previous route
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: const BackButton(
                            color: AppColors.iconColor,
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.only(left: showBackButton ? 0 : 24.w),
                        decoration: BoxDecoration(
                          border: minimal ?? true
                              ? const Border()
                              : Border(
                                  bottom: BorderSide(
                                      color: AppColors.primaryColor, width: 2.h),
                                ),
                        ),
                        height: 70.h,
                        child: Image.asset(
                          AppImagePath.appLogo,
                          height: 70.h,
                          width: 100.w,
                         // fit: BoxFit.fitHeight,

                        ),
                      ),
                      if (!(minimal ?? true))
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                             /* Container(
                                clipBehavior: Clip.hardEdge,
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.shadowColor,
                                      spreadRadius: 1,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: IgnorePointer(
                                    ignoring: appBarController.isLoading.value,
                                    child: InkWell(
                                      onTap: () {
                                        appBarController.qFormShare();
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              color: AppColors.shadowColor,
                                            ),
                                            child: const Icon(
                                              Icons.bolt_sharp,
                                              color: AppColors.iconColor,
                                            ),
                                          ),
                                          const BodyText(
                                            text: "Q-form",
                                            size: 8,
                                            fontWeight: FontWeight.bold,
                                            resizeAble: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),*/

                            /*  IconButton(
                                onPressed: () {
                                  // Handle notification click
                                },
                                icon: Stack(
                                  clipBehavior: Clip.none, // Allows badge to overflow
                                  children: [
                                    Image.asset("assets/icons/notification_icon.png"),

                                    // 🔴 Red Circle Badge (Only if there are notifications)
                                    if (appBarController.notificationCount.value > 0)
                                      Positioned(
                                        right: 2.w,
                                        top: 2.h,
                                        child: Container(
                                          width: 12, // Small red circle
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),*/

                              SizedBox(
                                width: 8.w,
                              ),
                              InkWell(
                                onTap: () {
                                  scaffoldKey?.currentState?.openDrawer();
                                },
                                child: CustomCircleAvatar(
                                  border: 2,
                                  bgColor: AppColors.inactiveColor,
                                  width: 40,
                                  height: 40,
                                  image: appBarController
                                          .homeData.value.data?.userInfo?.avatar ??
                                      "",
                                ),
                              ),
                              SizedBox(
                                width: 24.w,
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, 70.h);
}
