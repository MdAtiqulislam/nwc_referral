import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';

class CustomDropDownField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? title;
  final String? value;
  final bool? showBorder;
  final Color? bgColor;
  final bool required;
  final int? itemIndex;
  final Function(String?)? onChange;
  final List<String> itemList;
  final String? Function(String?)? validator;
  final String? validatorText;

  const CustomDropDownField({
    required this.itemList,
    required this.onChange,
    this.required=false,
    this.value,
    this.itemIndex,
    this.labelText,
    this.hintText,
    this.showBorder,
    this.bgColor,
    this.title,
    this.validator,
    this.validatorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      iconSize: 25,
      iconEnabledColor: AppColors.primaryColor,
      iconDisabledColor: AppColors.primaryColor,
      validator: validatorText != null
          ? (value) {
        if ((value ?? "").isEmpty) {
          return validatorText;
        }
        return null;
      }
          : validator,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.bodyTextColor),
      decoration: InputDecoration(
        counterText: "",
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.borderRadius.r),
          borderSide:
              const BorderSide(color: AppColors.inactiveColor),
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.borderRadius.r),
          borderSide:
              const BorderSide(color: AppColors.inactiveColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.borderRadius.r),
          borderSide:
              const BorderSide(color: AppColors.levelTextColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.borderRadius.r),
          borderSide:
              const BorderSide(color: AppColors.primaryColor),
        ),
        contentPadding: EdgeInsets.only(
            left: 24,
            right: 15,
            bottom: 16.h,
            top: 16.h//AppDimensions.widgetPaddingVer
        ),
         hintText: hintText,
        labelText: required?"$labelText*":labelText,
        floatingLabelStyle: const TextStyle(
            color: AppColors.headerTextColor,
            fontWeight: FontWeight.bold),
        //  prefixIcon: preFix,
        //  suffixIcon: suffix,
        hintStyle:  TextStyle(color: AppColors.levelTextColor,fontSize: 14.sp),
        labelStyle:  TextStyle(color: AppColors.levelTextColor,fontSize: 12.sp),
      ),
      items: itemList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: BodyText(text: value,maxLine: 3,align: TextAlign.start,),
        );
      }).toList(),
      onChanged:onChange,
      value: value,
    );

  }
}
