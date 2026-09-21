
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/app_colors.dart';

class CustomAppBarTheme{

static  AppBarTheme appBarTheme=AppBarTheme(
  color: Colors.white,
  foregroundColor: AppColors.headerTextColor,
  surfaceTintColor: Colors.white,
  iconTheme: const IconThemeData(color: AppColors.primaryColor),
  elevation: 2,
  centerTitle: true,
  actionsIconTheme: const IconThemeData(color: Colors.white),
  shadowColor: Colors.transparent,
  titleTextStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,color: AppColors.headerTextColor),

);
}