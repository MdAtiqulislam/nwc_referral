import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/controllers/add_or_update_student_new_controller.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/models/level_list_model.dart';
import 'package:nwc_referral/app/utils/extensions.dart';
import 'package:nwc_referral/common_widgets/custom_country_dropdown.dart';
import 'package:nwc_referral/common_widgets/custom_leve_dropdown.dart';
import 'package:nwc_referral/common_widgets/custom_university_dropdown.dart';
import 'package:nwc_referral/common_widgets/immigration_visa_radio.dart';
import 'package:nwc_referral/common_widgets/rafering_radio.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_drop_down_field.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_phone_text_field.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';

class BasicInfoForm extends GetView<AddOrUpdateStudentNewController> {
  final _formKey = GlobalKey<FormState>();

  BasicInfoForm({super.key});

  @override
  Widget build(BuildContext context) {

    print(controller.isSelfReferring.value);


    return Obx(
      () => Stack(
        children: [
          if (!controller.isLoading.value)
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal:AppDimensions.contentPadding.w,
                    vertical: AppDimensions.contentPadding.h
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          //AppDimensions.horizontalPadding,
                          vertical: 24.h //AppDimensions.verticalPadding
                          ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 10,
                                spreadRadius: 3)
                          ],
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HeaderText(
                                text: controller.isUpdateForm.value
                                    ? "Update Student info"
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
                              )
                            ],
                          ),
                          SizedBox(
                              height: 32.h //AppDimensions.sectionPaddingVer,
                              ),
                          addStudentForm()
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

  Widget addStudentForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            isRequired: true,
            levelText: "First Name",
            hintText: "First Name",
            validatorText: "Required",
            controller: controller.firstNameController,
          ),
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),
          CustomTextField(
            isRequired: true,
            levelText: "Last Name",
            hintText: "Last Name",
            validatorText: "Required",
            controller: controller.lastNameController,
          ),
          SizedBox(height: 8.h //AppDimensions.contentPaddingVer,
              ),

          CustomPhoneTextField(
            callingCode:
                controller.selectedPhoneCountry.value.callingCode ?? "",
            countryList: controller.countryList,
            selectedCountry: controller.selectedPhoneCountry.value,
            onChange: (value) {
              controller.selectedPhoneCountry.value = value;
              controller.countryCodeController.text = value.iso31662 ?? "";
            },
            controller: controller.phoneController,
          ),

          //phoneTextField(),
          SizedBox(height: 8.h //AppDimensions.contentPaddingVer,
              ),
          CustomTextField(
            isRequired: true,
            levelText: "Email",
            hintText: "Email",
            // textInputType: TextInputType.emailAddress,
            validator: (value) {
              return (value ?? "").isEmpty
                  ? "Email is Required"
                  : (value!.isValidEmail() ? null : "Email is not valid");
            },
            controller: controller.emailController,
            //validatorText: "please try with a different email address",
          ),
          if (!controller.isEmailExist.value)
            const BodyText(
              text: "please try with a different email address",
              color: AppColors.primaryColor,
            ),
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),
          CustomDropDownField(
            labelText: "Select Gender",
            showBorder: true,
            itemList: controller.genderList,
            onChange: (value) {
              controller.selectedGender.value = value ?? "";
            },
            value: controller.selectedGender.value.isEmpty
                ? null
                : controller.selectedGender.value,
          ),
          //countryDropdown(),
          SizedBox(height: 8.h),
          CustomCountryDropdown(
            countryList: controller.destinationCountryList,
            labelText: "Destination",
            hintText: "Choose Destination",
            required: true,
            onChange: (value) {
              controller.destinationCountry.value = value;
              controller.getUniversityListByDestination(destinationId: value.id.toString());
            },
            selectedCountry: controller.destinationCountry.value.id == null
                ? null
                : controller.destinationCountry.value,
          ),
          SizedBox(height: 8.h),
          BodyText(text: "Intake:",align: TextAlign.start,color: AppColors.headerTextColor,size: 14,),

          SizedBox(height: AppDimensions.widgetPadding.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomDropDownField(
                  labelText: "Month",
                  required: true,
                  showBorder: true,
                  validatorText: "Required",
                  itemList: controller.months,
                  onChange: (value) {
                    controller.selectedMonth.value = value ?? "";
                  },
                  value: controller.selectedMonth.value.isEmpty
                      ? null
                      : controller.selectedMonth.value,
                ),
              ),
              SizedBox(width: AppDimensions.contentPadding.w,),
              Expanded(
                flex: 2,
                child: CustomDropDownField(
                  labelText: "Year",
                  required: true,
                  showBorder: true,
                  validatorText: "Required",
                  itemList: controller.yearsList,
                  onChange: (value) {
                    controller.selectedYear.value = value ?? "";
                  },
                  value: controller.selectedYear.value.isEmpty
                      ? null
                      : controller.selectedYear.value,
                ),
              ),
            ],
          ),
          //countryDropdown(),
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),
          CustomUniversityDropdown(
            universityList: controller.universityList.value.data?.uniData ?? [],
            labelText: "Intended University",
            hintText: "Choose University",
            required: true,
            selectedUniversity: controller.selectedUniversity.value.id == null
                ? null
                : controller.selectedUniversity.value,
            onChange: (value){
              controller.selectedUniversity.value=value;
              controller.selectedLevel.value=SingleCourse();
              controller.getCoursesList(uniID: value.id.toString());
            },
          ),
          SizedBox(height: 8.h),
          CustomCoursesDropDown(
            coursesList: controller.courseList.value.data?.coursesData ?? [],
            labelText: "Intended Course",
            hintText: "Choose Course",
            required: true,
            onChange: (value) {
              controller.selectedLevel.value = value;
            },
            selectedCourse: controller.selectedLevel.value.id==null?null:controller.selectedLevel.value,
          ),
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),



          CustomDropDownField(
            labelText: "Tuition Fee Range",
            showBorder: true,
            required: true,
            itemList: controller.tuitionFeeRanges,
            validatorText: "Required",
            onChange: (value) {
              controller.selectedRange.value = value ?? "";
            },
            value: controller.selectedRange.value.isEmpty||!controller.tuitionFeeRanges.contains(controller.selectedRange.value)
                ? null
                : controller.selectedRange.value,
          ),

          //countryDropdown(),
          SizedBox(height: 8.h),
          ImmigrationHistoryRadio(
              selectedOption: controller.hasVisaRefusal.value?"Yes":"No",
              onChanged: (value) {
            controller.hasVisaRefusal.value = value.toLowerCase() == "yes";

          }),
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),
          ReferringRadio(
              selectedOption: controller.isSelfReferring.value?"Self":"Others",
              onChanged: (value) {
            controller.isSelfReferring.value = value.toLowerCase() == "self";
          }),
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),
          CustomTextField(
            levelText: "Additional Notes",
            hintText: "Additional Notes",
            maxLine: 10,
            minLine: 3,
            controller: controller.notesController,
          ),
          SizedBox(height: 16.h //AppDimensions.widgetPaddingVer,
              ),
          CheckboxListTile(
              value: controller.isAccepted.value,
              activeColor: AppColors.primaryColor,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const BodyText(
                text:
                    "I accept the terms & conditions of Admission Group Policy",
                size: 10,
                align: TextAlign.start,
              ),
              /* secondary: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.info_outlined,
                  color: AppColors.infoColor,
                ),
              ),*/
              onChanged: (value) {
                controller.isAccepted.value = value!;
              }),
          SizedBox(height: 16.h //AppDimensions.widgetPaddingVer,
              ),
          AppButton(
            text: "Save And Continue",//controller.isUpdateForm.value ? "Update" : "Next",
            textTransform: TextTransform.none,
            trailing: Icon(Icons.arrow_forward,color: Colors.white,size: 20.sp,),
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                controller.isUpdateForm.value ?controller.updateStudent():controller.addStudent();
              }
            },
            bgColor: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}
