import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/pending_page_controller.dart';

class PendingPageView extends GetView<PendingPageController> {
  const PendingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          minimal: true,
        ),
        body: Obx(
          () => RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () {
              return Future.delayed(
                  const Duration(seconds: 1), () => controller.reloadData());
            },
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w,//AppDimensions.horizontalPadding,
                            vertical: 16.h//AppDimensions.contentPaddingVer
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:8.h// AppDimensions.contentPaddingVer,
                              ),
                              const HeaderText(
                                text: "Thank you for registering",
                                color: AppColors.primaryColor,
                                size: 25,
                                align: TextAlign.start,
                              ),
                              SizedBox(
                                height: 32.h//AppDimensions.sectionPaddingVer,
                              ),
                              Text.rich(
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.bodyTextColor),
                                const TextSpan(
                                    text:"Thank you very much for registering."
                                        " It has been forwarded to our central office for verification. "
                                        "You will be notified once your account is active within the next two days.",
                                       style: TextStyle(
                                      color: AppColors.headerTextColor,
                                    ),

                                ),
                              ),

                              SizedBox(
                                height: 32.h,
                              ),

                              const HeaderText(
                                text: "Account Summary",
                                color: AppColors.primaryColor,
                                size: 18,
                              ),
                              SizedBox(
                                height:16.h// AppDimensions.widgetPaddingVer,
                              ),
                              //name
                              HeaderText(
                                text: controller.userData.value.name ?? "",
                                size: 14,
                              ),
                              //email
                              BodyText(
                                  text:
                                      "Email: ${controller.userData.value.email ?? ""}"),
                              BodyText(
                                  text:
                                      "Phone: ${controller.userData.value.phone ?? ""}"),
                              BodyText(
                                  text:
                                      "${controller.userData.value.sourceOccupation ?? ""}"),
                              BodyText(
                                  text:
                                      "${controller.userData.value.city ?? ""}, ${controller.selectedCountry.value.name ?? ""}"),

                              SizedBox(
                                height: 32.h,
                              ),
                              Row(
                                children: [
                                  const BodyText(text: "Have another account?"),
                                  SizedBox(
                                    width:8.w// AppDimensions.contentPaddingHor,
                                  ),
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: AppColors.primaryColor
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Get.offAllNamed(Routes.LOGIN);
                                        },
                                        child:  Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 32.w,
                                            vertical: 5.h,),
                                          child: BodyText(
                                            text: "Sign In".toUpperCase(),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                if (controller.isLoading.value) const LoadingScreen()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
