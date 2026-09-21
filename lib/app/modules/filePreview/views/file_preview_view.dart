import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/common_widgets/custom_network_image.dart';
import 'package:nwc_referral/constraints/app_strings.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../../../constraints/app_colors.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/file_preview_controller.dart';

class FilePreviewView extends GetView<FilePreviewController> {
  FilePreviewView({super.key});

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
        floatingActionButton: controller.isLocalFile.value
            ? null
            : FloatingActionButton(
                child: Icon(Icons.cloud_download_outlined),
                onPressed: () => controller.downloadFile(),
              ),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header Row
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                      text: "Preview File",
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
              ),
              // Scrollable content
              Expanded(
                child: Stack(
                  children: [
                    if (controller.isLoading.value)
                      const LoadingScreen()
                    else
                      _buildFilePreview(),
                    if (controller.isDownloading.value)
                      _buildDownloadProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the file preview widget based on file type
  Widget _buildFilePreview() {
    final fileType = controller.fileType.value.toLowerCase();
    final fileUrl = controller.fileUrl.value;

    if (controller.isLocalFile.value) {
      // File is local, use local file preview
      return _buildLocalFilePreview(fileType, fileUrl);
    } else {
      // File is from network, use network preview
      return _buildNetworkFilePreview(fileType, fileUrl);
    }
  }

  /// Build the network file preview widget
  Widget _buildNetworkFilePreview(String fileType, String fileUrl) {
    if (fileType == 'jpeg' || fileType == 'jpg' || fileType == 'png') {
      return Center(
        child: CustomNetworkImage(
          image: fileUrl,
          localImage: AppImagePath.galleryIcon,
        ),
      );
    } else if (fileType == 'pdf') {
      return Center(
        child: SfPdfViewer.network(
          fileUrl,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableTextSelection: true,
          onDocumentLoadFailed: (details) {
            Get.snackbar("Error", "Failed to load PDF: ${details.error}");
          },
        ),
      );
    } else {
      return _buildUnsupportedFilePreview(fileUrl);
    }
  }

  /// Build the local file preview widget
  Widget _buildLocalFilePreview(String fileType, String filePath) {
    final file = File(filePath);
    if (fileType == 'jpeg' || fileType == 'jpg' || fileType == 'png') {
      return Center(
        child: Image.file(file), // Display image from local storage
      );
    } else if (fileType == 'pdf') {
      return Center(
        child: SfPdfViewer.file(
          file,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableTextSelection: true,
          onDocumentLoadFailed: (details) {
            Get.snackbar("Error", "Failed to load PDF: ${details.error}");
          },
        ),
      );
    } else {
      return _buildUnsupportedFilePreview(filePath);
    }
  }

  /// Display a message for unsupported file types
  Widget _buildUnsupportedFilePreview(String fileUrl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file, size: 80),
          const SizedBox(height: 20),
          const Text("Preview not available for this file type."),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _openFileExternally(fileUrl),
            child: const Text("Open File"),
          ),
        ],
      ),
    );
  }

  /// Open the file using the device's default app
  void _openFileExternally(String fileUrl) async {
    if (await canLaunchUrl(Uri.parse(fileUrl))) {
      await launchUrl(Uri.parse(fileUrl), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Unable to open file externally.");
    }
  }

  /// Build a download progress indicator
  Widget _buildDownloadProgressIndicator() {
    return Center(
      child: AlertDialog(
        title: Text("Downloading..."),
        content: Obx(() {
          final progress =
              (controller.downloadProgress.value * 100).toStringAsFixed(1);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: controller.downloadProgress.value),
              SizedBox(height: 10),
              Text("$progress% completed"),
            ],
          );
        }),
      ),
    );
  }
}
