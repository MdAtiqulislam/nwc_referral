import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/controllers/add_or_update_student_new_controller.dart';
import 'package:nwc_referral/app/modules/leadList/controllers/lead_list_controller.dart';
import 'package:nwc_referral/app/routes/app_pages.dart';
import 'package:nwc_referral/constraints/body_text.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';

class CompletionSection extends GetView<AddOrUpdateStudentNewController> {
  const CompletionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>
          Stack(
            children: [
              if (!controller.isLoading.value)
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.contentPadding.w,
                      vertical: AppDimensions.contentPadding.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 24.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 10,
                                  spreadRadius: 3)
                            ],
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  HeaderText(
                                    text: controller.isUpdateForm.value
                                        ? "Update Student Info"
                                        : "Add New Student",
                                    color: AppColors.primaryColor,
                                    size: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: AppColors.primaryColor,
                                      size: 36,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppDimensions.sectionPadding.h),
                             studentDetails(),
                              SizedBox(height: AppDimensions.sectionPadding.h),
                              AppButton(
                                text: "View All Students",
                                textTransform: TextTransform.none,
                                onTap: () {
                                  controller.resetFields();
                                  Get.find<LeadListController>().getLeadListData();
                                  Get.find<LeadListController>().getEstimatedIncome();
                                  Get.offAndToNamed(Routes.LEAD_LIST);
                                },
                                bgColor: AppColors.primaryColor,
                                showBorder: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (controller.isUpdating.value || controller.isLoading.value)
                const LoadingScreen()
            ],
          ),
    );
  }

 Widget studentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderText(text: "${controller.firstNameController.text} ${controller.lastNameController.text}"),
        _buildDetailsRow(key: "Email", value: controller.emailController.text),
        _buildDetailsRow(key: "+${controller.selectedPhoneCountry.value.callingCode}${controller.phoneController.text}", value: controller.phoneController.text),
        SizedBox(height: AppDimensions.contentPadding.h,),
        Divider(thickness: 1.5,color: AppColors.headerTextColor,),
        _buildDetailsRow(key: "Destination", value: controller.destinationCountry.value.name??""),
        _buildDetailsRow(key: "Intake", value: controller.selectedMonth.value.substring(controller.selectedMonth.value.indexOf(" ") + 1)),
        _buildDetailsRow(key: "Intended Course", value: controller.selectedLevel.value.name??""),
        _buildDetailsRow(key: "Intended University", value: controller.selectedUniversity.value.name??""),
        _buildDetailsRow(key: "Tuition Fee Range", value: controller.selectedRange.value),
        _buildDetailsRow(key: "Previous visa refusal", value: controller.hasVisaRefusal.value?"Yes":"No"),
        _buildDetailsRow(key: "Referring", value: controller.isSelfReferring.value?"Self":"Others"),
        SizedBox(height: AppDimensions.sectionPadding*2.h,),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              height: 1.5,
              fontWeight: FontWeight.w600
            ),
            children: [
              TextSpan(text: "Your information "),
              TextSpan(text: "are need to be"),
              TextSpan(text: " monetized under "),
              TextSpan(
                text: "Admission Group",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: " policy.\nWhen confirmed we will notify you."),
            ],
          ),
        )


      ],
    );
 }

 Widget _buildDetailsRow({required String key,required String value}){
    return   Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      HeaderText(text: "$key:",size: 12,),
      SizedBox(width: AppDimensions.contentPadding.w,),
      Expanded(child: BodyText(text: value,size: 12,align: TextAlign.start,),),
    ],);
 }
}
