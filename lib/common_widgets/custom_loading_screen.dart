import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/header_text.dart';

import '../constraints/app_colors.dart';


class LoadingScreen extends StatelessWidget {
  final bool showText;

  const LoadingScreen({this.showText=false,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
     // color: Colors.black12,
      child:  Center(child: Stack(
        children: [

          Image.asset("assets/logo/loading.gif",height: 80,),
         // CircularProgressIndicator(color: AppColors.primaryColor,),
          if(showText)BodyText(text: "Please Wait...")
        ],
      ),),
    );
  }
}
