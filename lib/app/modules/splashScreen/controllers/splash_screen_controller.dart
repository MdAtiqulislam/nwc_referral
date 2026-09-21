import 'package:get/get.dart';
import 'package:nwc_referral/app/utils/extensions.dart';

import '../../../../services/local_services.dart';
import '../../../data/user_data_model.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }


  @override
  void onClose() {}

  void fetchData() async {
    Future.delayed(const Duration(milliseconds: 500));
    await LocalServices.getToken().then((value) async {
      if (value != null) {
        await LocalServices.getUser().then((value) async {
          if (await (value ?? UserDataModel()).userStatus()) {

            Get.offAndToNamed(Routes.HOME_PAGE);
          }
          else{
            Get.offAllNamed(Routes.PENDING_PAGE);
          }
        });
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }
}
