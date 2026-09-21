import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constraints/app_colors.dart';

Future<XFile?> picImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: imageSource);
  if (file != null) {
    return file;
  } else {
    return null;
  }
}

Future<String> getImageAsBase64(CroppedFile imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

Future<CroppedFile?> cropImage({required String filePath, CropStyle? cropStyle}) async {
  return await ImageCropper().cropImage(
    sourcePath: filePath,

    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Edit',
        toolbarColor: Colors.white,
        toolbarWidgetColor: AppColors.primaryColor,
        lockAspectRatio: false,
        showCropGrid: true, // Optional: Show grid while cropping
        cropStyle: cropStyle??CropStyle.circle, // Circle cropping style
      ),
      IOSUiSettings(
        title: 'Edit',
        aspectRatioLockEnabled: false, // Unlock aspect ratio
        cropStyle: cropStyle??CropStyle.circle, // Circle cropping style
      ),
    ],
  );
}

String formatDate(String? date) {
  if (date != null && date.isNotEmpty) {
    DateTime dDate = DateFormat('y-M-d').parse(date);
    return DateFormat("MMM -yy").format(dDate);
  } else {
    return "";
  }
}



Future<List<Map<String, dynamic>>> selectDocuments() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any, // You can specify FileType.custom for specific types
    );

    if (result != null) {
      // Map the selected files to a list of maps with necessary details
      return result.files.map((file) {
        return {
          'name': file.name,
          'path': file.path,
          'size': file.size, // File size in bytes
          'extension': file.extension, // File extension
        };
      }).toList();
    } else {
      // User canceled the picker
      return [];
    }
  } catch (e) {
    print("Error selecting documents: $e");
    return [];
  }
}
/// Open the file location or file in a file explorer

void openDownloadLocation(String filePath) async {
  try {
    File file = File(filePath);

    if (await file.exists()) {
      if (Platform.isAndroid) {
        // Open the file's directory in Android's default file manager
        String directoryPath = file.parent.path;
        await launchUrl(Uri.parse("file://$directoryPath"), mode: LaunchMode.externalApplication);
      } else if (Platform.isIOS) {
        // Open the file directly on iOS
        await launchUrl(Uri.file(filePath), mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Platform not supported.");
      }
    } else {
      Get.snackbar("Error", "File not found at: $filePath");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to open file location: $e");
  }
}



/// Converts "January" and a year into "YYYY-MM-01"
String getFormattedDateFromMonth(String month, String year) {
  Map<String, String> monthMap = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12",
  };

  String? monthNumber = monthMap[month];

  if (monthNumber == null) return ""; // Handle invalid month input

  return "$year-$monthNumber-01"; // Format as YYYY-MM-01
}

/// Converts "YYYY-MM-01" to "MM. MonthName"
String getFormattedMonthFromDate(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date); // Parse date string
    String formattedMonth = DateFormat('MMMM').format(parsedDate); // Format as "MM. MonthName"
    return formattedMonth;
  } catch (e) {
    return ""; // Return empty string on invalid input
  }
}

String getYearFromDate(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date); // Parse date string
    return DateFormat('yyyy').format(parsedDate); // Format as "YYYY"
  } catch (e) {
    return ""; // Return empty string on invalid input
  }
}

void updateStatusBar(){
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Your desired color
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  });

}