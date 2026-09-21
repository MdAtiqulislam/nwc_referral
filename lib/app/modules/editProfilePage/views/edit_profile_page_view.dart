import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nwc_referral/app/utils/extensions.dart';
import 'package:nwc_referral/common_widgets/image_picker_widget.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_circle_avatar.dart';
import '../../../../common_widgets/custom_country_dropdown.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_office_dropdown.dart';
import '../../../../common_widgets/custom_phone_text_field.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../registration/models/office_list_model.dart';
import '../controllers/edit_profile_page_controller.dart';

class EditProfilePageView extends GetView<EditProfilePageController> {
  EditProfilePageView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Obx(
          () => Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w //AppDimensions.horizontalPadding
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      controller.base64ImageProfile.isNotEmpty
                          ? CustomCircleAvatar(
                              width: 100.spMax,
                              height: 100.spMax,
                              memoryImage: controller.base64ImageProfile.value,
                              border: 5,
                              bgColor: AppColors.inactiveColor,
                              showEditIcon: true,
                              editIcon: Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.primaryColor,
                                size: 18.sp,
                              ),
                              onEditTap: () {
                                Get.bottomSheet(
                                  ImagePickerWidget(
                                      cameraIcon: Image.asset(
                                        AppImagePath.cameraIcon,
                                        height: 40.h,
                                      ),
                                      galleryIcon: Image.asset(
                                        AppImagePath.galleryIcon,
                                        height: 40.h,
                                      ),
                                      onImageSelected: (source) async {
                                        final picker = ImagePicker();
                                        final pickedFile = await picker.pickImage(
                                            source: source);
                                        if (pickedFile != null) {
                                          controller.selectImage(
                                              image: pickedFile);
                                        }
                                      }),
                                );
                              },
                            )
                          : CustomCircleAvatar(
                              width: 100.spMax,
                              height: 100.spMax,
                              image: controller.userData.value.avatar ?? "",
                              border: 5,
                              bgColor: AppColors.inactiveColor,
                              showEditIcon: true,
                              editIcon: Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.primaryColor,
                                size: 18.sp,
                              ),
                              onEditTap: () {
                                Get.bottomSheet(
                                  ImagePickerWidget(
                                      cameraIcon: Image.asset(
                                        AppImagePath.cameraIcon,
                                        height: 40.h,
                                      ),
                                      galleryIcon: Image.asset(
                                        AppImagePath.galleryIcon,
                                        height: 40.h,
                                      ),
                                      onImageSelected: (source) async {
                                        final picker = ImagePicker();
                                        final pickedFile = await picker.pickImage(
                                            source: source);
                                        if (pickedFile != null) {
                                          controller.selectImage(
                                              image: pickedFile);
                                        }
                                      }),
                                );
                              },
                            ),
                      SizedBox(
                        height: AppDimensions.contentPadding.h,
                      ),
                      HeaderText(
                        text: controller.userData.value.name ?? "",
                        size: 18,
                      ),
                      SizedBox(height: AppDimensions.sectionPadding.h),
                      registrationForm(),
                      SizedBox(height: 32.h //AppDimensions.sectionPaddingVer,
                          ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value) const LoadingScreen()
            ],
          ),
        ),
      ),
    );
  }

  Widget registrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            isRequired: true,
            hintText: "Name",
            levelText: "Name",
            validatorText: "Name is required",
            controller: controller.nameController,
            // textInputType: TextInputType.name,
          ),
          SizedBox(height: 16.h //AppDimensions.widgetPaddingVer,
              ),
          CustomTextField(
            isRequired: true,
            hintText: "Occupation",
            levelText: "Occupation",
            validatorText: "Occupation is required",
            controller: controller.occupationController,
          ),
          SizedBox(height: 16.h //AppDimensions.widgetPaddingVer,
              ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.borderRadius.r),
                color: AppColors.inactiveColor.withAlpha(128),
              ),
              child: CustomTextField(
                isRequired: true,
                hintText: "xyz@mail.com",
                levelText: "Email",
                // textInputType: TextInputType.emailAddress,
                validator: (value) {
                  return (value ?? "").isEmpty
                      ? "Email is Required"
                      : (value!.isValidEmail() ? null : "Email is not valid");
                },
                controller: controller.emailController,
              ),
            ),
          ),
          SizedBox(height: 16.h //AppDimensions.widgetPaddingVer,
              ),
          if (!controller.isLoading.value)
            CustomPhoneTextField(
              countryList: controller.countryList,
              selectedCountry: controller.selectedPhoneCountry.value,
              onChange: (value) {
                controller.selectedPhoneCountry.value = value;
                controller.phoneCountryController.text = value.iso31662 ?? "";
              },
              controller: controller.phoneController,
              callingCode:
                  controller.selectedPhoneCountry.value.callingCode ?? "",
            ),
          SizedBox(height: 16.h //AppDimensions.widgetPaddingVer,
              ),
          CustomCountryDropdown(
            labelText: "Present Country",
            countryList: controller.countryList,
            required: true,
            selectedCountry: controller.selectedCountry.value,
            onChange: (value) {
              controller.selectedCountry.value = value;
              controller.countryController.text = value.name ?? "";
            },
          ),
          SizedBox(height: 16.h // AppDimensions.widgetPaddingVer,
              ),
          CustomTextField(
            isRequired: true,
            hintText: "Present City",
            levelText: "Present City",
            validatorText: "City is required",
            controller: controller.cityController,
          ),
          SizedBox(height: 16.h // AppDimensions.widgetPaddingVer,
              ),
          IgnorePointer(
            ignoring: controller.disableOffice.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.borderRadius.r),
                color: controller.disableOffice.value
                    ? AppColors.inactiveColor.withAlpha(128)
                    : null,
              ),
              child: CustomOfficeDropdown(
                hintText: "Select Nearest Office",
                labelText: "Select Nearest Office",
                required: true,
                selectedOffice: controller.selectedOffice.value,
                officeList: controller.officeList,
                onChange: (value) {
                  controller.selectedOffice.value = value;
                  controller.officeController.text = value.name ?? "";
                },
              ),
            ),
          ),
          // phoneTextField(),
          SizedBox(height: 32.h //AppDimensions.sectionPaddingVer,
              ),
          AppButton(
            text: "Update",
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                controller.updateUser();
              }
            },
            bgColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  List<SingleOffice> getSuggestions(String query) {
    List<SingleOffice> matches = <SingleOffice>[];
    matches.addAll(controller.officeList);

    matches.retainWhere(
        (s) => (s.name ?? "").toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
