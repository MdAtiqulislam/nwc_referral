import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/controllers/add_or_update_student_new_controller.dart';

import '../app/modules/addStudentPage/controllers/add_student_page_controller.dart';
import '../app/routes/app_pages.dart';
import '../constraints/app_colors.dart';
import '../constraints/header_text.dart';


class AddStudentButton extends StatelessWidget {

  final bool? disable;
  const AddStudentButton({
    this.disable,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
           15.r// AppDimensions.borderRadius,
          ),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderText(
            text: "Add New Student",
            size: 16,
            color: Colors.white,
          ),
          IgnorePointer(
            ignoring: /*disable??*/false,
            child: IconButton(
              onPressed: () {
                Get.put(AddOrUpdateStudentNewController());
                Get.find<AddOrUpdateStudentNewController>().resetFields();
                Get.find<AddOrUpdateStudentNewController>().getPrimaryData();
                Get.toNamed(Routes.ADD_OR_UPDATE_STUDENT_NEW);
              },
              icon: const Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
