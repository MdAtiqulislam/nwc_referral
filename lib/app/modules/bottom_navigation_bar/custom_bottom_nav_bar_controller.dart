
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/leadList/controllers/lead_list_controller.dart';

import '../../routes/app_pages.dart';

class CustomBottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    actionPerform(index:index);

  }

  void actionPerform({required int index}) {
    if(index==0 && Get.currentRoute!=Routes.HOME_PAGE){
      Get.offAllNamed(Routes.HOME_PAGE);
    }else if(index==1 && Get.currentRoute!=Routes.LEAD_LIST){
      Get.put(LeadListController());
      Get.find<LeadListController>().getLeadListData();
      Get.toNamed(Routes.LEAD_LIST);
    }else if(index==2 && Get.currentRoute!=Routes.CONTACT_US){
     // Get.put(CaseReportController()).clearFilter();
      Get.toNamed(Routes.CONTACT_US);
    }else if(index==3 && Get.currentRoute!=Routes.PROFILE){
    //  Get.put(CaseCategoryController()).getCaseCategory();
      Get.toNamed(Routes.PROFILE);
    }else if(index==4 && Get.currentRoute!=Routes.FAQ){
    //  Get.put(CaseCategoryController()).getCaseCategory();
      Get.toNamed(Routes.FAQ);
    }
  }
}
