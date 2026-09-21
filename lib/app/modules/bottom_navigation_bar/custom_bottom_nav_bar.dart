import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import 'custom_bottom_nav_bar_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({super.key});

  final CustomBottomNavigationController controller = Get.put(CustomBottomNavigationController());

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.list, 'label': 'Student List'},
    {'icon': Icons.near_me_outlined, 'label': 'Contact Us'},
    {'icon': Icons.account_circle_outlined, 'label': 'Profile'},
    {'icon': Icons.question_mark, 'label': 'FAQ'},
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(.3),
                blurRadius: 5,
                offset: const Offset(0, -2)
              )
            ],
            border: Border(top: BorderSide(color: AppColors.shadowColor,width: .5.h))
          ),
          child: BottomNavigationBar(
            selectedItemColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.selectedIndex.value,
            unselectedFontSize: 10.sp,
            selectedFontSize: 12.sp,
            selectedIconTheme: IconThemeData(size: 25.sp),
            iconSize: 22.sp,
            onTap: (index) {
              controller.changeIndex(index);
            },
            items: navItems.map((item) {
            //  bool isSelected = controller.selectedIndex.value == navItems.indexOf(item);
              return BottomNavigationBarItem(

                icon: Icon(item['icon'],)/*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.inactiveColor,
                      //size: isSelected ? 20 : 20,
                    ),
                    HeaderText(
                      text: item['label'],
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.inactiveColor,
                      size: isSelected ? 12 : 12,
                    ),
                  ],
                )*/,
                label: item['label'],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
