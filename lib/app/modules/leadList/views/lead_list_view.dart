import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:nwc_referral/app/modules/leadList/views/student_list_screen.dart';
import 'package:nwc_referral/common_widgets/add_student_button.dart';
import '../../../../common_widgets/my_drawer.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/lead_list_controller.dart';
import 'empty_screen.dart';

class LeadListView extends GetView<LeadListController> {
  LeadListView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child:
      Obx(
        () => Stack(
          children: [
            Scaffold(
                    key: scaffoldKey,
                    appBar: CustomAppBar(
                      minimal: false,
                      scaffoldKey: scaffoldKey,
                      showBackButton: false,
                    ),
                    drawer: MyDrawer(),
                    bottomNavigationBar: bottomNavBar(),
                    body: RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(const Duration(seconds: 1),
                            () => controller.reloadData());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, //AppDimensions.horizontalPadding,
                            vertical: 16.h //AppDimensions.widgetPaddingVer
                            ),
                        child: homeScreen(),
                      ),
                    ),
                  ),
           // if(controller.isLoading.value || controller.isLoadingLeadList.value)LoadingScreen()
          ],
        ),
      ),
    );
  }

  Widget homeScreen() {
    return controller.isLoadingLeadList.value
        ? Container(
      color: Colors.white,
      child: Center(child: Image.asset("assets/logo/loading.gif",height: 80,),),
    )
        : (controller.leadListModel.value.data?.data?.length ?? 0) <= 0
            ? const EmptyScreen()
            : StudentListScreen();
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
