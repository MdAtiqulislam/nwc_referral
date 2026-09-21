import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:nwc_referral/constraints/app_colors.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Contact Us", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
      
          var data = controller.contactUsModel.value.data;
          if (data == null) {
            return const Center(
                child: Text("Failed to load contact information"));
          }
      
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppDimensions.sectionPadding.h),
                      _buildSectionTitle("About Us"),
                      BodyText(
                          text: data.aboutUsText ?? "",
                          size: 12,
                          maxLine: 20,
                          align: TextAlign.justify),
                      SizedBox(height: AppDimensions.widgetPadding.h),
                      _buildFeatureItem(
                          "Refer & Earn", " – Share with friends & earn rewards"),
                      _buildFeatureItem("Instant Tracking",
                          " – Monitor your referrals in real-time"),
                      SizedBox(height: AppDimensions.widgetPadding.h),
                      _buildSectionTitle("For any queries,"),
                      _buildSectionTitle("FEEL FREE TO CONTACT US.",
                          fontSize: 20),
                      SizedBox(height: AppDimensions.sectionPadding.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.horizontalPadding * 2.w),
                        child: Column(
                          children: [
                            _buildContactItem("assets/icons/avater_icon.png",
                                data.contactInfo?.name),
                            _buildContactItem("assets/icons/contact_icon.png",
                                data.contactInfo?.mob,
                                onTap: data.contactInfo?.mob != null
                                    ? () =>
                                        _launchUrl("tel:${data.contactInfo!.mob}")
                                    : null),
                            _buildContactItem("assets/icons/wa_icon.png",
                                data.contactInfo?.whatsApp,
                                onTap: data.contactInfo?.whatsApp != null
                                    ? () => _launchUrl(
                                        "https://wa.me/${data.contactInfo!.whatsApp!.replaceAll('+', '')}")
                                    : null),
                            _buildContactItem("assets/icons/location_icon.png",
                                data.contactInfo?.address, onTap: () {
                              String encodedAddress = Uri.encodeComponent(
                                  data.contactInfo?.address ?? "");
                              _launchUrl(
                                  "https://www.google.com/maps/search/?api=1&query=$encodedAddress");
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.sectionPadding.h),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 200.sp,
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding.w,
          vertical: AppDimensions.verticalPadding.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.r)),
      ),
      child: Center(child: Image.asset("assets/images/contact_us_bg.png")),
    );
  }

  Widget _buildSectionTitle(String text, {double fontSize = 16}) {
    return HeaderText(
        text: text, color: AppColors.primaryColor, size: fontSize);
  }

  Widget _buildFeatureItem(String title, String subtitle) {
    return Row(
      children: [
        Image.asset("assets/icons/chevron-last.png", height: 24.spMin),
        HeaderText(text: title, color: AppColors.primaryColor, size: 12),
        BodyText(text: subtitle, size: 12),
      ],
    );
  }

  Widget _buildContactItem(String icon, String? text, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(icon, height: 24.sp),
            SizedBox(width: AppDimensions.contentPadding.w),
            Expanded(
                child: BodyText(
                    text: text ?? "", align: TextAlign.start, size: 14)),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }
}
