/*

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nwc_referral/common_widgets/custom_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart' as custom;

class CustomImageSlider extends StatefulWidget {
  final List<String> images; // List of image URLs (network)
  final List<String>? localImages; // List of image URLs (local)
  final List<Slider> slider;
  final bool autoScroll; // Control auto-scrolling
  final double height; // Customizable height
  final int duration; // Auto-scroll duration
  final BoxFit fit; // Image fit style

   CustomImageSlider({
    super.key,
    this.images =  const [], // Default empty list
    this.localImages,
    this.duration = 5,
     required this.slider,
    this.fit = BoxFit.cover,
    this.autoScroll = true, // Default: Auto-scroll enabled
    this.height = 200, // Default height 200, but customizable
  }) : assert(
  (localImages != null && localImages.isNotEmpty) ||
      (images.isNotEmpty), // Ensure at least one of them is provided
  'You must provide either localImages or images.',
  );

  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  int _currentIndex = 0;
  final custom.CarouselController _carouselController =
  custom.CarouselController(); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    // Determine which image list to use (network or local)
    List<String> imageList = widget.localImages ?? widget.images;

    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController, // Pass the controller here
          options: CarouselOptions(
            height: widget.height, // Use customizable height
            autoPlay: widget.autoScroll, // Enable/disable auto-scroll
            enlargeCenterPage: true,
            aspectRatio: 1,
            viewportFraction: 1,
            autoPlayInterval: Duration(seconds: widget.duration),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index; // Update the current index when page changes
              });
            },
          ),
          items: imageList.map((imageUrl) {
            // Check if the image is local or network image
            bool isLocal = widget.localImages != null && widget.localImages!.contains(imageUrl);
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomNetworkImage(
                image: imageUrl,
                fit: widget.fit,
                localImage: isLocal ? imageUrl : null, // Set the localImage if it's a local image
              ),
            );
          }).toList(),
        ),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageList.asMap().entries.map((entry) {
            int index = entry.key;
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
*/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_controller.dart'; //as custom;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/homePage/models/home_page_data_model.dart';
import 'package:nwc_referral/common_widgets/custom_network_image.dart';
import 'package:nwc_referral/constraints/body_text.dart';
import 'package:nwc_referral/constraints/dimensions.dart';
import 'package:nwc_referral/constraints/header_text.dart';


class CustomImageSlider extends StatefulWidget {
  final List<SliderModel> slider; // ✅ List of Slider objects
  final bool autoScroll;
  final double height;
  final int duration;
  final BoxFit fit;

  const CustomImageSlider({
    super.key,
    required this.slider, // ✅ Required slider list
    this.autoScroll = true,
    this.height = 200,
    this.duration = 5,
    this.fit = BoxFit.cover,
  });

  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Image Slider with Title & Description
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoScroll,
            enlargeCenterPage: true,
            aspectRatio: 1,
            viewportFraction: 1,
            autoPlayInterval: Duration(seconds: widget.duration),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.slider.map((sliderItem) {
            return Stack(
              children: [
                // ✅ Background Image
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r)
                  ),
                  width: Get.width,
                  height: widget.height.sp,
                  child: //Image.asset("assets/images/slider_image.png",fit: widget.fit,),
                  CustomNetworkImage(
                    image: sliderItem.img ?? "", // Use img from Slider model
                    fit: widget.fit,
                  )
                ),

                // ✅ Title & Description Overlay
                Positioned(
                  top: 20.sp,
                  left: 20,
                  right: 100.sp,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                     // color: Colors.black.withOpacity(0.6), // Transparent background
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Title
                        HeaderText(
                          text:sliderItem.imgInfo?.imgTitle ?? "",
                          color: Colors.white,
                          size: 20,
                          align: TextAlign.start,
                          maxLine: 2,
                        ),
                        const SizedBox(height: 5),
                        // ✅ Description
                        BodyText(
                          text:sliderItem.imgInfo?.imgDescription ?? "No Description",
                          color: Color(0xffcecece),
                          align: TextAlign.start,
                          maxLine: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),

        // ✅ Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.slider.asMap().entries.map((entry) {
            int index = entry.key;
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
