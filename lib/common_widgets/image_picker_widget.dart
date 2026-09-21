import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/header_text.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(ImageSource source) onImageSelected;
  final String title;
  final String cameraText;
  final String galleryText;
  final Widget? cameraIcon;
  final Widget? galleryIcon;
  final double borderRadius;

  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.title = "Select an action",
    this.cameraText = "Open Camera",
    this.galleryText = "Open Gallery",
    this.cameraIcon,
    this.galleryIcon,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(borderRadius.r),
          topLeft: Radius.circular(borderRadius.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 32.h),
          HeaderText(
            text: title,
            color: AppColors.primaryColor,
            size: 18,
          ),
          SizedBox(height: 32.h),
          const Divider(thickness: 5, color: AppColors.primaryColor),
          SizedBox(height: 32.h),
          _buildOption(
            icon: cameraIcon ?? Icon(Icons.camera_alt, size: 40.h),
            text: cameraText,
            onTap: () => onImageSelected(ImageSource.camera),
          ),
          const Divider(),
          _buildOption(
            icon: galleryIcon ?? Icon(Icons.photo, size: 40.h),
            text: galleryText,
            onTap: () => onImageSelected(ImageSource.gallery),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildOption({required Widget icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Row(
          children: [
            icon,
            SizedBox(width: 24.w),
            HeaderText(text: text),
          ],
        ),
      ),
    );
  }
}
