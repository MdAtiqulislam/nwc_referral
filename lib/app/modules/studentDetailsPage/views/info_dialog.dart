/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../Models/lead_details_model.dart';

class InfoDialog extends StatelessWidget {
  final SupervisorInfo data;
  final String type;

  const InfoDialog({required this.data, required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              width: Get.width,
              color: AppColors.primaryColor,
              child: HeaderText(
                text: type,
                color: Colors.white,
                align: TextAlign.start,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.name != null) HeaderText(text: data.name ?? ""),
                  if (data.name != null)
                    SizedBox(
                      height: 16.h,
                    ),
                  if (data.phone != null)
                    InkWell(
                      onTap: () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path:data.phone,
                        );
                        await launchUrl(launchUri);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.call),
                          SizedBox(
                            width: 8.w,
                          ),
                          HeaderText(text: data.phone)
                        ],
                      ),
                    ),
                  if (data.phone != null)
                    SizedBox(
                      height: 16.h,
                    ),
                  if (data.mobile != null)
                    InkWell(
                      onTap: () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: data.mobile,
                        );
                        await launchUrl(launchUri);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.phone_android_rounded),
                          SizedBox(
                            width: 8.w,
                          ),
                          HeaderText(text: data.phone)
                        ],
                      ),
                    ),

                  if(data.whatsApp==null)
                    Padding(
                      padding:  EdgeInsets.only(top: 16.h),
                      child: Row(
                        children: [
                           Image.asset("assets/icons/wa_icon.png",height: 25.sp,),
                          SizedBox(
                            width: 8.w,
                          ),
                          HeaderText(text: data.phone)
                        ],
                      ),
                    ),
                  if (data.email != null)
                    Column(
                      children: [
                        Divider(),
                        InkWell(
                          onTap: () async {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: data.email,
                            );

                            launchUrl(emailLaunchUri);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.mail,
                                size: 18.sp,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                  child: BodyText(
                                text: data.email ?? "",
                                maxLine: 2,
                                align: TextAlign.start,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 32.h,
                  ),
                  AppButton(
                    text: "Back",
                    onTap: () {
                      Get.back();
                    },
                    splashColor: AppColors.primaryColor.withAlpha(50),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../Models/lead_details_model.dart';

class InfoDialog extends StatelessWidget {
  final SupervisorInfo data;
  final String type;

  const InfoDialog({required this.data, required this.type, super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.name != null) ...[
                    HeaderText(text: data.name!),
                    SizedBox(height: 16.h),
                  ],
                  if (data.phone != null&& (data.phone!="")) _buildContactRow(Icons.call, data.phone!),
                  if (data.mobile != null&& (data.mobile!="")) _buildContactRow(Icons.phone_android, data.mobile!),
                  if (data.whatsApp != null && (data.whatsApp!="")) _buildWhatsAppRow(data.whatsApp!),
                  if (data.email != null) _buildEmailRow(data.email!),
                  SizedBox(height: 32.h),
                  _buildBackButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      width: Get.width,
      color: AppColors.primaryColor,
      child: HeaderText(text: type, color: Colors.white, align: TextAlign.start),
    );
  }

  Widget _buildContactRow(IconData icon, String contact) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () => _launchUrl('tel:$contact'),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8.w),
            HeaderText(text: contact),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsAppRow(String contact) {
    return InkWell(
      onTap: () => _launchUrl('https://wa.me/$contact'),
      child: Row(
        children: [
          Image.asset("assets/icons/wa_icon.png", height: 25.sp),
          SizedBox(width: 8.w),
          HeaderText(text: contact),
        ],
      ),
    );
  }

  Widget _buildEmailRow(String email) {
    return Column(
      children: [
        Divider(),
        InkWell(
          onTap: () => _launchUrl('mailto:$email'),
          child: Row(
            children: [
              Icon(Icons.mail, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: BodyText(
                  text: email,
                  maxLine: 2,
                  align: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return AppButton(
      text: "Back",
      onTap: Get.back,
      splashColor: AppColors.primaryColor.withAlpha(50),
    );
  }
}

