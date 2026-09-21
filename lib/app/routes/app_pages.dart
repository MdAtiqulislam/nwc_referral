import 'package:get/get.dart';

import '../modules/FAQ/bindings/faq_binding.dart';
import '../modules/FAQ/views/faq_view.dart';
import '../modules/addOrUpdateStudentNew/bindings/add_or_update_student_new_binding.dart';
import '../modules/addOrUpdateStudentNew/views/add_or_update_student_new_view.dart';
import '../modules/addStudentPage/bindings/add_student_page_binding.dart';
import '../modules/addStudentPage/views/add_student_page_view.dart';
import '../modules/contactUs/bindings/contact_us_binding.dart';
import '../modules/contactUs/views/contact_us_view.dart';
import '../modules/editProfilePage/bindings/edit_profile_page_binding.dart';
import '../modules/editProfilePage/views/edit_profile_page_view.dart';
import '../modules/filePreview/bindings/file_preview_binding.dart';
import '../modules/filePreview/views/file_preview_view.dart';
import '../modules/homePage/bindings/home_page_binding.dart';
import '../modules/homePage/views/home_page_view.dart';
import '../modules/leadList/bindings/lead_least_binding.dart';
import '../modules/leadList/views/lead_list_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notificationPage/bindings/notification_page_binding.dart';
import '../modules/notificationPage/views/notification_page_view.dart';
import '../modules/otpPage/bindings/otp_page_binding.dart';
import '../modules/otpPage/views/otp_page_view.dart';
import '../modules/pendingPage/bindings/pending_page_binding.dart';
import '../modules/pendingPage/views/pending_page_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/registration/bindings/reggistration_binding.dart';
import '../modules/registration/views/registration_view.dart';
import '../modules/splashScreen/bindings/splash_screen_binding.dart';
import '../modules/splashScreen/views/splash_screen_view.dart';
import '../modules/studentDetailsPage/bindings/student_details_page_binding.dart';
import '../modules/studentDetailsPage/views/student_details_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;
  // static const INITIAL = Routes.PENDING_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.LEAD_LIST,
      page: () => LeadListView(),
      binding: LeadListBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGGISTRATION,
      page: () => RegistrationView(),
      binding: ReggistrationBinding(),
    ),
    GetPage(
      name: _Paths.OTP_PAGE,
      page: () => OtpPageView(),
      binding: OtpPageBinding(),
    ),
    GetPage(
      name: _Paths.PENDING_PAGE,
      page: () => const PendingPageView(),
      binding: PendingPageBinding(),
    ),
    GetPage(
      name: _Paths.ADD_STUDENT_PAGE,
      page: () => AddStudentPageView(),
      binding: AddStudentPageBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_DETAILS_PAGE,
      page: () => StudentDetailsPageView(),
      binding: StudentDetailsPageBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_PAGE,
      page: () => EditProfilePageView(),
      binding: EditProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_PAGE,
      page: () => NotificationPageView(),
      binding: NotificationPageBinding(),
    ),
    GetPage(
      name: _Paths.FILE_PREVIEW,
      page: () => FilePreviewView(),
      binding: FilePreviewBinding(),
    ),
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () =>  HomePageView(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => const ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.ADD_OR_UPDATE_STUDENT_NEW,
      page: () =>  AddOrUpdateStudentNewView(),
      binding: AddOrUpdateStudentNewBinding(),
    ),
  ];
}
