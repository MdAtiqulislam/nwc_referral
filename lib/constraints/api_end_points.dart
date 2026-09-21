import 'package:get/get.dart';

class APIEndPoints{

  //for Dev
 // static const baseURL = "https://v-sams-crm.samscrm.co.uk/";
 //  static const baseURL = "https://app.samscrm.co.uk/";
  //for Test
  // static const baseURL = "https://test-c2.samscrm.co.uk/";
  //for live
  static const baseURL = "https://app.samscrm.co.uk/";

  static var httpErrorMSG = "".obs;
  static const login="api/v2/sub-agent/auth/login";
  static const officeList="api/v2/sub-agent/auth/common_office_list";
  static const countryList="api/v1/crm-sub-agent/country-code-list";
  static const getOTP="api/v2/sub-agent/auth/email-validation-otp";
  static const verifyOTP="api/v2/sub-agent/auth/verify-email-otp";
  static const signUp="api/v2/sub-agent/auth/sign_up";
  static const resetPassword="api/v2/sub-agent/auth/reset-password";
  static const getHomeData="api/v2/sub-agent/ajax/home_data";
  static const getHomeData2="api/v2/sub-agent/ajax/home_page_details";
  static const getUserData="api/v2/sub-agent/ajax/logged_in_subagent_info";
  static const checkEmail="api/v2/sub-agent/ajax/check_lead_email";

  static const addNewStudent="api/v2/sub-agent/ajax/create_lead_v2";

  static const getLeadList="api/v2/sub-agent/ajax/lead_list_v2";
  static const uploadProfilePic="api/v2/sub-agent/ajax/user_profile_img";
  static const updateProfile="api/v2/sub-agent/ajax/update_user_profile";
  static const updateLead="api/v2/sub-agent/ajax/update_lead_info";
  static const getLeadDetails="api/v2/sub-agent/ajax/lead_details";
  static const getNotification="api/v2/sub-agent/ajax/notification_list";
  static const changeNotificationReadStatus="api/v2/sub-agent/ajax/notification_marked_as_read";
  static const removeNotification="api/v2/sub-agent/ajax/notification_remove_from_app_list";
  static const estimatedIncome="api/v2/sub-agent/ajax/estimated_income_study_group";
  static const removeAccount="api/v2/sub-agent/ajax/remove_account";
  static const uploadLeadAdditionalFile="api/v2/sub-agent/ajax/upload_lead_additional_file";
  static const getLeadAdditionalFile="api/v2/sub-agent/ajax/lead_additional_file_list";
  static const deleteDocument="api/v2/sub-agent/ajax/remove_lead_additional_file";
  static const renameDocument="api/v2/sub-agent/ajax/update_lead_additional_file";
  static const getFAQEndpoint="api/v2/sub-agent/ajax/faq";
  static const getContactUsInfo="api/v2/sub-agent/ajax/about_us";
  static const getUniversityList="api/v2/sub-agent/ajax/university_list";
  static const getCoursesList="api/v2/sub-agent/ajax/level_list";
  static const universitySearch="api/v2/sub-agent/ajax/university_list_search";
  static const destinationCountries="api/v2/sub-agent/ajax/market_countries";
}