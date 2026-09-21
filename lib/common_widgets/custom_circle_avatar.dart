/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constraints/app_colors.dart';
import 'custom_network_image.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double width;
  final double height;
  final String image;
  final String? svgNetworkImage;
  final String? localImage;
  final double? radius;
  final double? border;
  final BoxFit? fit;
  final Color? bgColor;
  final bool showEditIcon;
  final VoidCallback? onEditTap;
  final Widget? editIcon; // Dynamic edit icon

  const CustomCircleAvatar({
    required this.width,
    required this.height,
    required this.image,
    this.svgNetworkImage,
    this.localImage,
    this.radius,
    this.border,
    this.fit,
    this.bgColor,
    this.showEditIcon = false,
    this.onEditTap,
    this.editIcon, // Allow dynamic icon
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? AppColors.secondaryLightColor,
          ),
          padding: EdgeInsets.all(border ?? 0),
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: height,
            width: width,
            decoration: radius == null
                ? BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor ?? AppColors.secondaryLightColor,
            )
                : BoxDecoration(
              borderRadius: BorderRadius.circular(radius!),
              color: bgColor ?? AppColors.secondaryLightColor,
            ),
            child: svgNetworkImage != null
                ? SvgPicture.network(svgNetworkImage ?? "", fit: fit ?? BoxFit.cover)
                : CustomNetworkImage(
              image: image,
              localImage: localImage,
              fit: fit,
            ),
          ),
        ),
        if (showEditIcon)
          Positioned(
            bottom: 10,
            right: 0,
            child: Material(
              color: Colors.white, // Transparency ensures splash effect works
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onEditTap,
                borderRadius: BorderRadius.circular(50), // Ensures circular splash
              //  splashColor: Colors.grey.withOpacity(0.3), // Custom splash effect
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: editIcon ?? Icon(Icons.edit, size: 18, color: AppColors.primaryColor),
                ),
              ),
            ),
          ),

      ],
    );
  }
}
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constraints/app_colors.dart';
import 'custom_network_image.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double width;
  final double height;
  final String? image;
  final String? svgNetworkImage;
  final String? localImage;
  final String? memoryImage; // New parameter for memory image
  final double? radius;
  final double? border;
  final BoxFit? fit;
  final Color? bgColor;
  final bool showEditIcon;
  final VoidCallback? onEditTap;
  final Widget? editIcon; // Dynamic edit icon

  const CustomCircleAvatar({
    required this.width,
    required this.height,
    this.image,
    this.svgNetworkImage,
    this.localImage,
    this.memoryImage, // Accept memory image
    this.radius,
    this.border,
    this.fit,
    this.bgColor,
    this.showEditIcon = false,
    this.onEditTap,
    this.editIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? AppColors.secondaryLightColor,
          ),
          padding: EdgeInsets.all(border ?? 0),
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: height,
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor ?? AppColors.secondaryLightColor,
            ),
            child: memoryImage != null
                ? Image.memory(base64Decode(memoryImage??""), fit: fit ?? BoxFit.cover)
                : svgNetworkImage != null
                ? SvgPicture.network(svgNetworkImage!, fit: fit ?? BoxFit.cover)
                : CustomNetworkImage(
              image: image ?? '',
              localImage: localImage,
              fit: fit,
            ),
          ),
        ),
        if (showEditIcon)
          Positioned(
            bottom: 10,
            right: 0,
            child: Material(
              color: Colors.transparent, // Transparency ensures splash effect works
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onEditTap,
                borderRadius: BorderRadius.circular(50), // Ensures circular splash
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: editIcon ?? Icon(Icons.edit, size: 18, color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
