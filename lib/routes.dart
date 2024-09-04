import 'package:get/get.dart';
import 'package:moe_som_app/login/login.dart';
import 'package:moe_som_app/login/reset_password/reset_password.dart';
import 'package:moe_som_app/my_school/classes/add_classes/add_classes.dart';
import 'package:moe_som_app/my_school/learners/learners_list.dart';
import 'package:moe_som_app/my_school/teachers/add_teachers/add_teachers.dart';
import 'package:moe_som_app/my_school/teachers/teachers_list.dart';
import 'package:moe_som_app/profile/account_deletion/account_deletion.dart';
import 'package:moe_som_app/profile/edit_password/edit_password.dart';
import 'package:moe_som_app/profile/offline_attendance/offline_attendance.dart';
import 'package:moe_som_app/profile/offline_enrolment/offline_enrolment.dart';
import 'package:moe_som_app/reports/contact_us/contact_us.dart';
import 'package:moe_som_app/reports/reports.dart';
import 'attendance/attendance_overview/attendance_overview.dart';
import 'login/forgot_password/forgot_password.dart';
import 'my_school/absence/absence_list.dart';
import 'my_school/classes/classes_list.dart';
import 'my_school/learners/add_learner/add_learner.dart';
import 'my_school/learners/add_learner/add_learner_guardian.dart';
import 'my_school/learners/deactivate_learner/deactivated_list.dart';
import 'my_school/learners/move_learner/move_learner.dart';
import 'navigation/navigation.dart';
import 'profile/help/help.dart';
import 'profile/logout/logout.dart';
import 'reports/reports_class/reports_class.dart';
import 'reports/reports_learner/reports_learner.dart';

List<GetPage<dynamic>> appRoutes = [
  GetPage(
    name: BottomNavigationPage.routeName,
    page: () => BottomNavigationPage(),
  ),
  GetPage(
    name: LoginPage.routeName,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: LearnersList.routeName,
    page: () => LearnersList(),
  ),
  GetPage(
    name: AddLeaner.routeName,
    page: () => const AddLeaner(),
  ),
  GetPage(
      name: AddLearnerGuardianPage.routeName,
      page: () => const AddLearnerGuardianPage()),
  GetPage(
    name: AbsenceList.routeName,
    page: () => AbsenceList(),
  ),
  GetPage(
    name: MoveLearners.routeName,
    page: () => MoveLearners(),
  ),
  GetPage(
    name: DailyAttendanceOverview.routeName,
    page: () => const DailyAttendanceOverview(),
  ),
  GetPage(
    name: ReportsClassPage.routeName,
    page: () => ReportsClassPage(),
  ),
  GetPage(
    name: LogoutPage.routeName,
    page: () => LogoutPage(),
  ),
  GetPage(
    name: OfflineEnrolmentPage.routeName,
    page: () => OfflineEnrolmentPage(),
  ),
  GetPage(
    name: OfflineAttendancePage.routeName,
    page: () => OfflineAttendancePage(),
  ),
  GetPage(
    name: ReportsLearnerPage.routeName,
    page: () => ReportsLearnerPage(),
  ),
  GetPage(
    name: Help.routeName,
    page: () => const Help(),
  ),
  GetPage(
    name: ForgotPassword.routeName,
    page: () => const ForgotPassword(),
  ),
  GetPage(
    name: ResetPassword.routeName,
    page: () => const ResetPassword(),
  ),
  GetPage(
    name: EditPassword.routeName,
    page: () => const EditPassword(),
  ),
  GetPage(
    name: ContactUs.routeName,
    page: () => ContactUs(),
  ),
  GetPage(
    name: ClassesList.routeName,
    page: () => const ClassesList(),
  ),
  GetPage(
    name: AddClasses.routeName,
    page: () => const AddClasses(),
  ),
  GetPage(
    name: DeactivatedLearnersList.routeName,
    page: () => DeactivatedLearnersList(),
  ),
  GetPage(
    name: TeachersList.routeName,
    page: () => const TeachersList(),
  ),
  GetPage(
    name: AddTeachers.routeName,
    page: () => const AddTeachers(),
  ),
  GetPage(
    name: AccountDeletion.routeName,
    page: () => const AccountDeletion(),
  ),
];
