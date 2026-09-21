import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nwc_referral/app/modules/leadList/views/single_uploaded_document.dart';
import 'package:nwc_referral/app/modules/studentDetailsPage/views/single_university_card.dart';

import '../../../../common_widgets/circular_button.dart';
import '../../../../common_widgets/add_student_button.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../routes/app_pages.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../../filePreview/controllers/file_preview_controller.dart';
import '../../leadList/views/single_selected_document.dart';
import '../Models/lead_details_model.dart';
import '../controllers/student_details_page_controller.dart';
import 'info_dialog.dart';

class StudentDetailsPageView extends GetView<StudentDetailsPageController> {
  StudentDetailsPageView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              key: scaffoldKey,
              appBar: CustomAppBar(
                minimal: false,
                scaffoldKey: scaffoldKey,
              ),
              drawer: MyDrawer(),
              bottomNavigationBar: bottomNavBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w //AppDimensions.horizontalPadding
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      BackButton(
                        color: AppColors.iconColor,
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            elevation: WidgetStatePropertyAll(3),
                            shadowColor:
                                WidgetStatePropertyAll(Colors.black87)),
                      ),
                      SizedBox(height: 16.h // AppDimensions.sectionPaddingVer,
                          ),
                      headerSection(),
                      SizedBox(height: 32.h

                          /// AppDimensions.sectionPaddingVer,
                          ),
                      if ((controller
                                  .leadDetailsModel.value.data?.totalApplied ??
                              [])
                          .isEmpty)
                        const HeaderText(
                          text: "No Applications Available",
                          color: AppColors.bodyTextColor,
                          size: 14,
                        ),
                      universityListSection(),
                      SizedBox(height: 32.h //AppDimensions.sectionPaddingHor,
                          )
                    ],
                  ),
                ),
              ),
            ),
            if (controller.isLoading.value) const LoadingScreen()
          ],
        ),
      ),
    );
  }

  Widget headerSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          const HeaderText(
            text: "Student Details",
            color: AppColors.primaryColor,
            size: 18,
          ),
          if (controller.isAssigned.value)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircularButton(
                    callback: () {},
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: Get.context!,
                            builder: (buildContext) {
                              return InfoDialog(
                                type: "Counsellor",
                                data: controller.leadDetailsModel.value.data
                                        ?.counsellorInfo ??
                                    SupervisorInfo(),
                              );
                            });
                      },
                      icon: Image.asset(
                        AppImagePath.counselorIcon,
                        height: 20.h,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
      SizedBox(height: 16.h // AppDimensions.widgetPaddingVer,
          ),
      HeaderText(
        text:
            "${controller.leadDetailsModel.value.data?.givenName ?? ""} ${controller.leadDetailsModel.value.data?.familyName ?? ""}",
        size: 14,
      ),
      Row(
        children: [
          const HeaderText(
            text: "Ref No: ",
            size: 12,
          ),
          BodyText(
              text: (controller.leadDetailsModel.value.data?.referalNo ?? "")
                  .toString()),
        ],
      ),
      SizedBox(height: 16.h // AppDimensions.widgetPaddingVer,
          ),
      Row(
        children: [
          Icon(
            Icons.mail,
            color: AppColors.primaryColor,
            size: 15.sp,
          ),
          BodyText(
            text: " ${controller.leadDetailsModel.value.data?.email ?? " "}",
          ),
        ],
      ),
      Row(
        children: [
          Icon(
            Icons.call,
            color: AppColors.primaryColor,
            size: 15.sp,
          ),
          BodyText(
              text: " ${controller.leadDetailsModel.value.data?.mobile ?? " "}")
        ],
      ),
      SizedBox(height: 16.h // AppDimensions.widgetPaddingVer,
          ),
    BodyText(
    text: controller.notes.value.toLowerCase().contains("additional notes")
    ? controller.notes.value
        : "Additional Notes: ${controller.notes.value}",
    align: TextAlign.start,
    maxLine: 5,
    ),
    SizedBox(height: 8.h), // AppDimensions.widgetPaddingVer

    if(controller.uploadedDocuments.value.data?.academicDoc?.id!=null)academicDocSection(),
      SizedBox(height: AppDimensions.contentPadding.h,),
      if(controller.uploadedDocuments.value.data?.cv?.id!=null)cvSection(),
      SizedBox(height: AppDimensions.contentPadding.h,),
      if(controller.uploadedDocuments.value.data?.passport?.id!=null)passportSection(),
      SizedBox(height: 8.h // AppDimensions.widgetPaddingVer,
      ),
      additionalFileSection(),
      SizedBox(height: 8.h // AppDimensions.widgetPaddingVer,
      ),
      if(controller.selectedDocuments.isNotEmpty)
        MaterialButton(
          onPressed: (){
            controller.uploadLeadAdditionalFile(leadId: controller.leadDetailsModel.value.data!.id.toString());
          },
          color: AppColors.primaryColor,
          child: Row(
            children: [
              Icon(Icons.upload_outlined,color: Colors.white,),
              SizedBox(width: AppDimensions.widgetPadding.w,),
              HeaderText(text: "Upload selected files",color: Colors.white,)
            ],
          ),
        ),

      const Divider(),
    ]);
  }

  Widget universityListSection() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (buildContext, index) {
        return SingleUniversityCard(
            appliedUniversityModel:
                controller.leadDetailsModel.value.data?.totalApplied?[index] ??
                    AppliedUniversityModel());
      },
      separatorBuilder: (buildContext, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: 16.h //AppDimensions.sectionPaddingVer
              ),
          child: const Divider(
            color: AppColors.headerTextColor,
          ),
        );
      },
      itemCount:
          controller.leadDetailsModel.value.data?.totalApplied?.length ?? 0,
    );
  }




  Widget additionalFileSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderText(text: "Additional Files"),
            InkWell(
              child: Icon(
                Icons.attachment_rounded,
                color: AppColors.primaryColor,
              ),
              onTap: () {
                //controller.handleDocumentSelection();
                _chooseFileOption();
              },
            )
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
         ((controller.uploadedDocuments.value.data?.fileList?.data ?? [])
            .isEmpty &&
            controller.selectedDocuments.isEmpty)
             ?BodyText(text: "You have not attached any file yet.")
             :documentSection(),
      ],
    ));
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
            fileUrl: document?.fileUrl.toString(),
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

  Widget cvSection(){
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
        leading: Image.asset("assets/icons/file.png",height: 25.sp,),
        trailing: Icon(Icons.remove_red_eye_outlined),
        title: HeaderText(text: controller.uploadedDocuments.value.data?.cv?.fileName??"",align: TextAlign.start,),
        subtitle: BodyText(text: controller.uploadedDocuments.value.data?.cv?.fileUrl??"",align: TextAlign.start,maxLine: 2,),
        onTap: (){
          Get.put(FilePreviewController());
          Get.find<FilePreviewController>().fileUrl.value = controller
              .uploadedDocuments.value.data?.cv?.fileUrl ??
              "";
          Get.find<FilePreviewController>().isLocalFile.value=false;
          Get.find<FilePreviewController>().detectFileType();
          Get.find<FilePreviewController>().loadFile();
          Get.toNamed(Routes.FILE_PREVIEW);
        },
      ),
    );
  }

  Widget academicDocSection(){
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
        leading: Image.asset("assets/icons/file.png",height: 25.sp,),
        trailing: Icon(Icons.remove_red_eye_outlined),
        title: HeaderText(text: controller.uploadedDocuments.value.data?.academicDoc?.fileName??"",align: TextAlign.start,),
        subtitle: BodyText(text: controller.uploadedDocuments.value.data?.academicDoc?.fileUrl??"",align: TextAlign.start,maxLine: 2,),
        onTap: (){
          Get.put(FilePreviewController());
          Get.find<FilePreviewController>().fileUrl.value = controller
              .uploadedDocuments.value.data?.academicDoc?.fileUrl ??
              "";
          Get.find<FilePreviewController>().isLocalFile.value=false;
          Get.find<FilePreviewController>().detectFileType();
          Get.find<FilePreviewController>().loadFile();
          Get.toNamed(Routes.FILE_PREVIEW);
        },
      ),
    );
  }

  Widget passportSection(){
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
        leading: Image.asset("assets/icons/file.png",height: 25.sp,),
        trailing: Icon(Icons.remove_red_eye_outlined),
        title: HeaderText(text: controller.uploadedDocuments.value.data?.passport?.fileName??"",align: TextAlign.start,),
        subtitle: BodyText(text: controller.uploadedDocuments.value.data?.passport?.fileUrl??"",align: TextAlign.start,maxLine: 2,),
        onTap: (){
          Get.put(FilePreviewController());
          Get.find<FilePreviewController>().fileUrl.value = controller
              .uploadedDocuments.value.data?.passport?.fileUrl ??
              "";
          Get.find<FilePreviewController>().isLocalFile.value=false;
          Get.find<FilePreviewController>().detectFileType();
          Get.find<FilePreviewController>().loadFile();
          Get.toNamed(Routes.FILE_PREVIEW);
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

  void _chooseFileOption() {
    showCustomBottomSheet(
      title: "Select an action",
      content: Column(
        children: [
          // Camera Option
          Container(
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Material(
              child: InkWell(
                onTap: () {
                  controller.selectImage(source: ImageSource.camera);
                  Get.back(); // Close the bottom sheet
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                    vertical: AppDimensions.verticalPadding.h,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImagePath.cameraIcon,
                        height: 30.h,
                      ),
                      SizedBox(width: AppDimensions.widgetPadding.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          HeaderText(text: "Open Camera"),
                          BodyText(
                            text: "Capture an image using your camera.",
                            size: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(),

          // Gallery Option (Multiple File Selection)
          Container(
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Material(
              child: InkWell(
                onTap: () {
                  controller.handleDocumentSelection();
                  Get.back(); // Close the bottom sheet
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                    vertical: AppDimensions.verticalPadding.h,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImagePath.galleryIcon,
                        height: 30.h,
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          HeaderText(text: "Choose Files (Multiple)"),
                          BodyText(
                            text: "Select multiple files from your gallery.",
                            size: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  bottomNavBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddStudentButton(),
        CustomBottomNavigationBar()
      ],
    );
  }




}
