import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/controllers/add_or_update_student_new_controller.dart';
import 'package:nwc_referral/common_widgets/app_button.dart';
import 'package:nwc_referral/common_widgets/custom_snackbar.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../../other_models/additional_files_model.dart';
import 'package:path/path.dart' as path;

import '../../../routes/app_pages.dart';
import '../../filePreview/controllers/file_preview_controller.dart';

class FileUploadSection extends GetView<AddOrUpdateStudentNewController> {
  const FileUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          HeaderText(
                            text: "Upload Your Documents",
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                          fileSection(),
                          SizedBox(height: AppDimensions.sectionPadding.h),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: "Save And Continue",
                                  textTransform: TextTransform.none,
                                  trailing: Icon(Icons.arrow_forward,color: Colors.white,size: 20.sp,),
                                  onTap: () {
                                    controller.uploadFile();
                                  },
                                  bgColor: AppColors.primaryColor,
                                  showBorder: false,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.nextStep();
                                },
                                child: HeaderText(
                                  text: "Skip",
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
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

  Widget fileSection() {
    return Column(
      children: [
        buildUploadBox(
            title: "Upload Academic Reference",
            selectedFiles: controller.academicFile,
            isMultiple: false,
            fileType: "Academic",
            uploadedFile: controller.uploadedAcademicFile,
          renameAble: false
        ),
        buildUploadBox(
            title: "Upload CV/Resume",
            selectedFiles: controller.cvFile,
            isMultiple: false,
            fileType: "CV",
            uploadedFile: controller.uploadedCVFile,
          renameAble: false
        ),
        buildUploadBox(
          title: "Upload Passport",
          selectedFiles: controller.passportFile,
          isMultiple: false,
          fileType: "Passport",
          uploadedFile: controller.uploadedPassportFile,
          renameAble: false
        ),
        buildUploadBox(
          title: "Upload Additional Documents",
          selectedFiles: controller.additionalFiles,
          isMultiple: true,
          // Supports multiple files
          fileType: "Additional",
          uploadedFile: controller.uploadedAdditionalFiles,
        ),
      ],
    );
  }

  Widget buildUploadBox({
    required String title,
    required RxList<File> selectedFiles,
    required bool isMultiple,
    required String fileType,
    RxList<SingleFile>? uploadedFile,
    bool renameAble=true
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.widgetPadding.h),
        HeaderText(
          text: title,
          fontWeight: FontWeight.normal,
          size: 12,
        ),
        SizedBox(height: 5),
        DottedBorder(
          color: Colors.black,
          strokeWidth: 1,
          dashPattern: [6, 3],
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.contentPadding.w),
            child: Column(
              children: [
                if (selectedFiles.isEmpty && (uploadedFile ?? []).isEmpty)
                  GestureDetector(
                    onTap: () async {
                      if (selectedFiles.isEmpty || isMultiple) {
                        chooseFileOption(fileType: fileType, isMultiple: isMultiple);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/upload.png", height: 25.sp),
                        SizedBox(width: AppDimensions.contentPadding.w),
                        BodyText(
                          text: "Select File",
                          color: AppColors.levelTextColor,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                if (selectedFiles.isNotEmpty && (uploadedFile ?? []).isEmpty)
                  Column(
                    children: [
                      ...selectedFiles.map((file) {
                        int fileSize = file.lengthSync();
                        String fileName = file.path.split('/').last;

                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/file.png",
                                  height: 25.sp,
                                ),
                                SizedBox(width: AppDimensions.contentPadding.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      HeaderText(
                                        text: fileName,
                                        fontWeight: FontWeight.normal,
                                        size: 14,
                                      ),
                                      BodyText(
                                        text: "${(fileSize / 1024).toStringAsFixed(2)} KB",
                                      ),
                                      Obx(() {
                                        double progress = controller.uploadProgress[fileName] ?? 0.0;
                                        return progress > 0.0 && progress < 1.0
                                            ? Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor: Colors.grey[300],
                                            color: AppColors.primaryColor,
                                            minHeight: 5,
                                          ),
                                        )
                                            : SizedBox();
                                      }),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: AppColors.levelTextColor),
                                  onSelected: (value) {
                                    if (value == "Remove") {
                                      selectedFiles.remove(file);
                                      controller.uploadProgress.remove(fileName);
                                    } else if (value == "Rename") {
                                      renameFile(file, selectedFiles);
                                    } else if (value == "Preview") {
                                      controller.filePreview(file);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: "Rename",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: AppColors.levelTextColor),
                                            SizedBox(width: 8),
                                            Text("Rename"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<String>(
                                        value: "Remove",
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text("Remove"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<String>(
                                        value: "Preview",
                                        child: Row(
                                          children: [
                                            Icon(Icons.remove_red_eye, color: AppColors.levelTextColor),
                                            SizedBox(width: 8),
                                            Text("Preview"),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                            if (isMultiple)
                              Divider(color: Colors.grey.shade400, thickness: 0.5, height: 10),
                          ],
                        );
                      }),
                      if (isMultiple)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                              if (result != null) {
                                for (var file in result.files) {
                                  selectedFiles.add(File(file.path!));
                                }
                              }
                            },
                            child: Text("+ Add More", style: TextStyle(color: AppColors.primaryColor)),
                          ),
                        ),
                    ],
                  ),
                // Reactive upload files section
                if (uploadedFile != null && uploadedFile.isNotEmpty)
                  Column(
                    children: [
                      ...uploadedFile.map((file) {
                        String fileName = file.fileName??"";

                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/file.png",
                                  height: 25.sp,
                                ),
                                SizedBox(width: AppDimensions.contentPadding.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      HeaderText(
                                        text: fileName,
                                        fontWeight: FontWeight.normal,
                                        size: 14,
                                      ),
                                      BodyText(
                                        text: file.fileUrl??"",
                                        maxLine: 2,align: TextAlign.start,
                                      ),
                                      Obx(() {
                                        double progress = controller.uploadProgress[fileName] ?? 0.0;
                                        return progress > 0.0 && progress < 1.0
                                            ? Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor: Colors.grey[300],
                                            color: AppColors.primaryColor,
                                            minHeight: 5,
                                          ),
                                        )
                                            : SizedBox();
                                      }),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: AppColors.levelTextColor),
                                  onSelected: (value) {
                                    if (value == "Remove") {
                                      controller.removeUploadedFile(file);
                                    } else if (value == "Rename") {
                                      renameUploadedFile(file,renameAble);
                                    } else if (value == "Preview") {
                                      Get.put(FilePreviewController());
                                      Get.find<FilePreviewController>().fileUrl.value = file.fileUrl??"";
                                      Get.find<FilePreviewController>().isLocalFile.value=false;
                                      Get.find<FilePreviewController>().detectFileType();
                                      Get.find<FilePreviewController>().loadFile();
                                      Get.toNamed(Routes.FILE_PREVIEW);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: "Rename",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: AppColors.levelTextColor),
                                            SizedBox(width: 8),
                                            Text("Rename"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<String>(
                                        value: "Remove",
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text("Remove"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<String>(
                                        value: "Preview",
                                        child: Row(
                                          children: [
                                            Icon(Icons.remove_red_eye, color: AppColors.levelTextColor),
                                            SizedBox(width: 8),
                                            Text("Preview"),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                            if (isMultiple)
                              Divider(color: Colors.grey.shade400, thickness: 0.5, height: 10),
                          ],
                        );
                      }),

                      ...selectedFiles.map((file) {
                        int fileSize = file.lengthSync();
                        String fileName = file.path.split('/').last;

                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/file.png",
                                  height: 25.sp,
                                ),
                                SizedBox(width: AppDimensions.contentPadding.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      HeaderText(
                                        text: fileName,
                                        fontWeight: FontWeight.normal,
                                        size: 14,
                                      ),
                                      BodyText(
                                        text: "${(fileSize / 1024).toStringAsFixed(2)} KB",
                                      ),
                                      Obx(() {
                                        double progress = controller.uploadProgress[fileName] ?? 0.0;
                                        return progress > 0.0 && progress < 1.0
                                            ? Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor: Colors.grey[300],
                                            color: AppColors.primaryColor,
                                            minHeight: 5,
                                          ),
                                        )
                                            : SizedBox();
                                      }),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: AppColors.levelTextColor),
                                  onSelected: (value) {
                                    if (value == "Remove") {
                                      selectedFiles.remove(file);
                                      controller.uploadProgress.remove(fileName);
                                    } else if (value == "Rename") {
                                      renameFile(file, selectedFiles);
                                    } else if (value == "Preview") {
                                      controller.filePreview(file);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: "Rename",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, color: AppColors.levelTextColor),
                                            SizedBox(width: 8),
                                            Text("Rename"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<String>(
                                        value: "Remove",
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text("Remove"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<String>(
                                        value: "Preview",
                                        child: Row(
                                          children: [
                                            Icon(Icons.remove_red_eye, color: AppColors.levelTextColor),
                                            SizedBox(width: 8),
                                            Text("Preview"),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                            if (isMultiple)
                              Divider(color: Colors.grey.shade400, thickness: 0.5, height: 10),
                          ],
                        );
                      }),

                      if (isMultiple)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                              if (result != null) {
                                for (var file in result.files) {
                                  selectedFiles.add(File(file.path!));
                                }
                              }
                            },
                            child: Text("+ Add More", style: TextStyle(color: AppColors.primaryColor)),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }


 /* void chooseFileOption({required String fileType, required isMultiple}) {
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
                  controller.selectImage(
                      source: ImageSource.camera, fileType: fileType);
                  // Close the bottom sheet after selecting
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w,
                      vertical: AppDimensions.verticalPadding.h),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImagePath.cameraIcon,
                        height: 30.h,
                      ),
                      SizedBox(
                        width: AppDimensions.widgetPadding.w,
                      ),
                      const HeaderText(text: "Open Camera"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(),

          // Gallery Option
          Container(
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            child: Material(
              child: InkWell(
                onTap: () async {
                  // Use the FilePicker to select files from the gallery
                  controller.handleDocumentSelection(
                      fileType: fileType, isMultiple: isMultiple);
                  // Close the bottom sheet after selecting
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w,
                      vertical: AppDimensions.verticalPadding.h),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImagePath.galleryIcon,
                        height: 30.h,
                      ),
                      SizedBox(
                        width: 16.w, // Adjust padding if needed
                      ),
                     isMultiple? const HeaderText(text: "Choose Files"):const HeaderText(text: "Choose File"),
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
*/
  /*  void chooseFileOption({required String fileType, required bool isMultiple}) {
    showCustomBottomSheet(
      title: "Select an action",
      content: Column(
        children: [
          // Camera Option
          _buildOption(
            iconPath: AppImagePath.cameraIcon,
            text: "Open Camera",
            onTap: () {
              controller.selectImage(source: ImageSource.camera, fileType: fileType);
              Get.back(); // Close bottom sheet
            },
          ),
          const Divider(),

          // Gallery Option
          _buildOption(
            iconPath: AppImagePath.galleryIcon,
            text: isMultiple ? "Choose Files (Multiple)" : "Choose File",
            subText: isMultiple ? "You can select multiple files" : null,
            onTap: () {
              controller.handleDocumentSelection(fileType: fileType, isMultiple: isMultiple);
              Get.back(); // Close bottom sheet
            },
          ),
        ],
      ),
    );
  }

 Widget _buildOption({
    required String iconPath,
    required String text,
    String? subText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Row(
              children: [
                Image.asset(iconPath, height: 30.h),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(text: text),
                    if (subText != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: BodyText(text: subText, size: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/

  void chooseFileOption({required String fileType, required bool isMultiple}) {
    showCustomBottomSheet(
      title: "Select an action",
      content: Column(
        children: [
          // Camera Option
          _buildOption(
            iconPath: AppImagePath.cameraIcon,
            text: "Open Camera",
            subText: "Capture an image using your camera",
            onTap: () {
              controller.selectImage(source: ImageSource.camera, fileType: fileType);
              Get.back(); // Close bottom sheet
            },
          ),
          const Divider(),

          // Gallery Option
          _buildOption(
            iconPath: AppImagePath.galleryIcon,
            text: isMultiple ? "Choose Files (Multiple)" : "Choose File",
            subText: isMultiple ? "Select multiple files from gallery" : "Select a single file from gallery",
            onTap: () {
              controller.handleDocumentSelection(fileType: fileType, isMultiple: isMultiple);
              Get.back(); // Close bottom sheet
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String iconPath,
    required String text,
    required String subText,
    required VoidCallback onTap,
  })
  {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Row(
              children: [
                Image.asset(iconPath, height: 30.h),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(text: text),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: BodyText(text: subText, size: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void renameFile(File file, RxList<File> selectedFiles) async {
    String filePath = file.path;
    String fileExtension = filePath.split('.').last; // Extract extension
    String fileNameWithoutExtension = filePath
        .split('/')
        .last
        .split('.')
        .first; // Extract name without extension

    TextEditingController renameController =
        TextEditingController(text: fileNameWithoutExtension);

    Get.defaultDialog(
      title: "Rename File",
      content: Column(
        children: [
          TextField(
            minLines: 1,
            maxLines: 10,
            maxLength: 58,
            controller: renameController,
            decoration: InputDecoration(
              hintText: "Enter new file name",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            String newFileName = renameController.text.trim();
            if (newFileName.isNotEmpty) {
              String directory = filePath.substring(
                  0, filePath.lastIndexOf('/')); // Get directory path
              String newPath =
                  "$directory/$newFileName.$fileExtension"; // Preserve extension
              File newFile = await file.rename(newPath);

              // Replace the old file in the list
              int index = selectedFiles.indexOf(file);
              if (index != -1) {
                selectedFiles[index] = newFile;
              }

              Get.back(); // Close dialog
            }
          },
          child: Text("Rename"),
        ),
      ],
    );


  }


  void renameUploadedFile(SingleFile uploadedFile,bool renameAble)
  async {
    if(renameAble){
      {
        String fileExtension = (uploadedFile.fileName??"").split('.').last; // Extract extension
        final fileNameWithoutExt =
        path.basenameWithoutExtension(uploadedFile.fileName??""); // Remove extension

        TextEditingController renameController =
        TextEditingController(text: fileNameWithoutExt);

        Get.defaultDialog(
          title: "Rename Document",
          content: Column(
            children: [
              TextField(
                minLines: 1,
                maxLines: 10,
                maxLength: 58,
                controller: renameController,
                decoration: InputDecoration(
                  hintText: "Enter new file name",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newFileName = renameController.text.trim();
                if (newFileName.isNotEmpty) {
                  controller.renameUploadedDocument(newName: newFileName+fileExtension);
                  Get.back(); // Close dialog
                }
              },
              child: Text("Rename"),
            ),
          ],
        );
      }
    }else{
      CustomSnackBar(
        isSuccess: false,
        msg: "This document is read-only and cannot be renamed."
      ).showSnackBar();
    }
  }


}
