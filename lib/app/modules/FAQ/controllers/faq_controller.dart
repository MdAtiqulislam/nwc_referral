import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/FAQ/Models/faq_model.dart';
import 'package:nwc_referral/app/utils/utils.dart';
import 'package:nwc_referral/constraints/api_end_points.dart';
import 'package:nwc_referral/services/remote_services.dart';

class FaqController extends GetxController {
  var faqs = <Faq>[].obs;
  var faqModel=FaqModel().obs;
  var isLoading = true.obs;
  var expandedIndex = (-1).obs; // -1 means no item is expanded
  var expandedIndices = <bool>[].obs;

  @override
  void onInit() {
    updateStatusBar();
    fetchFAQs();
    super.onInit();
  }

  Future<void> fetchFAQs() async {
    var endPoint=APIEndPoints.getFAQEndpoint;
    try {
      isLoading(true);
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response!=null){
        faqModel.value=FaqModel.fromJson(response);
        faqs.value=faqModel.value.data?.faq??[];

        expandedIndices.value = List.generate(faqs.length, (index) => false);
      }
    } catch (e) {
      print("Error fetching FAQs: $e");
    } finally {
      isLoading(false);
    }
  }

  void toggleExpansion(int index) {
    expandedIndices[index] = !expandedIndices[index];
    expandedIndices.refresh(); // Force GetX to rebuild UI
  }
}
