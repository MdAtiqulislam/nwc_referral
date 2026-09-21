import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:nwc_referral/app/modules/leadList/views/single_selected_document.dart';
import 'package:nwc_referral/app/utils/extensions.dart';
import 'package:nwc_referral/common_widgets/custom_bottom_sheet.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_drop_down_field.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/custom_phone_text_field.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../../filePreview/controllers/file_preview_controller.dart';
import '../../leadList/views/single_uploaded_document.dart';
import '../controllers/add_student_page_controller.dart';

class AddStudentPageView extends GetView<AddStudentPageController> {
  AddStudentPageView({super.key});

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          minimal: false,
          scaffoldKey: scaffoldKey,
        ),
        drawer: MyDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () => Stack(
            children: [
              if (!controller.isLoading.value)
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, //AppDimensions.horizontalPadding,
                        vertical: 8.h //AppDimensions.contentPaddingVer
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  HeaderText(
                                    text: controller.isUpdateForm.value
                                        ? "Update Student info"
                                        : "Add New Student",
                                    color: AppColors.secondaryLightColor,
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
                                  height:
                                      32.h //AppDimensions.sectionPaddingVer,
                                  ),
                              addStudentForm()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (controller.isUpdating.value) const LoadingScreen()
            ],
          ),
        ),
      ),
    );
  }

  Widget addStudentForm() {
    return Form(
      key: _formKey,
      child: Column(
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
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),
          CustomTextField(
            levelText: "Additional Notes",
            hintText: "Additional Notes",
            maxLine: 10,
            minLine: 3,
            controller: controller.notesController,
          ),
          SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
              ),
          Row(
            children: [
              BodyText(text: "Attach documents"),
              IconButton(
                onPressed: () {
                  _chooseFileOption();
                },
                icon: Icon(Icons.attachment_rounded),
              ),
            ],
          ),
          if(controller.selectedDocuments.isNotEmpty||
              (controller.uploadedDocuments.value.data?.fileList?.data??[]).isNotEmpty
          )documentSection(),
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
            text: controller.isUpdateForm.value ? "Update" : "Confirm",
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                controller.isUpdateForm.value
                    ? controller.updateUserInfo()
                    : controller.addStudent();
              }
            },
            bgColor: AppColors.primaryColor,
          )
        ],
      ),
    );
  }

  Widget selectedDocumentsSection() {
    return Obx(() {
      return ListView.separated(
        itemCount: controller.selectedDocuments.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final document = controller.selectedDocuments[index];
          return SingleSelectedDocument(
                  document: document,
                  onRename: (newName) {
                    controller.renameDocument(index, newName);
                  },
                  onDelete: () {
                    controller.removeSelectedDocument(index);
                  },
            onPreview:(){
              Get.put(FilePreviewController());
              Get.find<FilePreviewController>().fileUrl.value = document["path"];
              Get.find<FilePreviewController>().fileType.value=document["extension"];
              Get.find<FilePreviewController>().isLocalFile.value=true;
              Get.find<FilePreviewController>().loadFile();
              Get.toNamed(Routes.FILE_PREVIEW);
            }
          )
              ;
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      );
    });
  }

  Widget uploadedDocumentSection() {
    return Obx(() {
      return ListView.separated(
        itemCount: (controller.uploadedDocuments.value.data?.fileList?.data ?? []).length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final document =
              controller.uploadedDocuments.value.data?.fileList?.data?[index];
          return SingleUploadedDocument(
            fileName: document?.fileName ?? 'Unnamed Document',
            fileUrl: document?.fileUrl,
            comments: document?.comments,
            onPreview: () {
              Get.put(FilePreviewController());
              Get.find<FilePreviewController>().fileUrl.value = controller
                      .uploadedDocuments.value.data?.fileList?.data?[index].fileUrl ??
                  "";
              Get.find<FilePreviewController>().isLocalFile.value=false;
              Get.find<FilePreviewController>().detectFileType();
              Get.find<FilePreviewController>().loadFile();
              Get.toNamed(Routes.FILE_PREVIEW);
            },
            onRename: (newName) {
              controller.renameUploadedDocument(
                id: document?.id,
                newName: newName,
              );
            },
            onDelete: () {
              controller.deleteDocument(id: document?.id);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      );
    });
  }

  Widget documentSection(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow:  [
            BoxShadow(
                color: AppColors.successColor.withAlpha(80),
                blurRadius: 10,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
       leading: Icon(Icons.folder,size: 48,color: Colors.amberAccent,),
        trailing: Icon(Icons.remove_red_eye_outlined),
        title: Column(
          children: [
           if(controller.selectedDocuments.isNotEmpty) Row(
              children: [
                Icon(Icons.arrow_upward,color: Colors.red,size: AppDimensions.bodyTextSize,),
                controller.selectedDocuments.length>1
                    ?BodyText(text: "${controller.selectedDocuments.length} files Selected")
                    :BodyText(text: "${controller.selectedDocuments.length} file Selected"),
              ],
            ),
            if(controller.selectedDocuments.isNotEmpty && (controller.uploadedDocuments.value.data?.fileList?.data??[]).isNotEmpty)Divider(),
            if((controller.uploadedDocuments.value.data?.fileList?.data??[]).isNotEmpty)Row(
              children: [
                Icon(Icons.arrow_upward,color: Colors.green,size: AppDimensions.bodyTextSize,),
                (controller.uploadedDocuments.value.data?.fileList?.data??[]).length>1
                    ? BodyText(text: "${controller.uploadedDocuments.value.data?.fileList?.data?.length} files Uploaded")
                    : BodyText(text: "${controller.uploadedDocuments.value.data?.fileList?.data?.length} file Uploaded"),
              ],
            ),
          ],
        ),
        onTap: (){
         _showDocuments();
        },
      ),
    );
  }

  void _showDocuments(){
    showCustomBottomSheet(title: "Documents",
        content: Column(
          children: [
            uploadedDocumentSection(),
            SizedBox(height: 8.h // AppDimensions.contentPaddingVer,
            ),
            selectedDocumentsSection(),
          ],
        )
    );
  }
  void _chooseFileOption(){
    showCustomBottomSheet(
        title: "Select an action",
        content: Column(
          children: [

            Container(
              margin: const EdgeInsets.all(5),
              color: Colors.white,
              child: Material(
                child: InkWell(
                  onTap: () {
                    controller.selectImage(source: ImageSource.camera);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.horizontalPadding.w,
                        vertical: AppDimensions.verticalPadding.h
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImagePath.cameraIcon,
                          height: 30.h,
                        ),
                        SizedBox(
                            width:AppDimensions.widgetPadding.w,
                        ),
                        const HeaderText(text: "Open Camera"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            // SizedBox(height: Dimensions.widgetPaddingVer,),
            Container(
              margin: const EdgeInsets.all(5),
              color: Colors.white,
              child: Material(
                child: InkWell(
                  onTap: () {
                    controller.handleDocumentSelection();
                  //  controller.selectImage(source: ImageSource.gallery);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:AppDimensions.horizontalPadding.w,
                        vertical: AppDimensions.verticalPadding.h
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImagePath.galleryIcon,
                          height: 30.h,
                        ),
                        SizedBox(
                            width:16.w// AppDimensions.widgetPaddingHor,
                        ),
                        const HeaderText(text: "Choose Files"),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }

}
