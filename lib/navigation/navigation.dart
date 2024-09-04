import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/bottom_navigation/bottom_navigation.dart';
import 'package:flutter_utils/bottom_navigation/models.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/profile/profile.dart';
import 'package:moe_som_app/reports/reports.dart';
import '../attendance/attendance.dart';
import '../my_school/my_school.dart';
import '../my_school/my_school_controller.dart';

var primary = Get.theme.primaryColor;

// ignore: must_be_immutable
class BottomNavigationPage extends StatelessWidget {
  static const routeName = "/home";
  BottomNavigationPage({super.key});
  AuthController authController = Get.find<AuthController>();
  MySchoolController mySchoolCont =
      Get.put<MySchoolController>(MySchoolController());

  @override
  Widget build(BuildContext context) {
    return SistchLayoutWithDrawerBottomNavigation(
      name: 'main',
      tabs: [
        BottomNavigationItem(
          widget: AttendanceWidget(),
          barItem: BottomNavigationBarItem(
            icon: const Icon(Iconsax.calendar_1),
            label: "Attendance".ctr,
            backgroundColor: primary,
          ),
        ),
        BottomNavigationItem(
          widget: MySchoolPage(),
          barItem: BottomNavigationBarItem(
            icon: const Icon(Iconsax.buildings),
            label: "My School".ctr,
            backgroundColor: primary,
          ),
        ),
        BottomNavigationItem(
          widget: ReportsPage(),
          barItem: BottomNavigationBarItem(
            icon: const Icon(Iconsax.chart_1),
            label: "Reports".ctr,
            backgroundColor: primary,
          ),
        ),
        BottomNavigationItem(
          widget: ProfilePage(),
          barItem: BottomNavigationBarItem(
            icon: const Icon(Iconsax.profile_circle),
            label: "Profile".ctr,
            backgroundColor: primary,
          ),
        )
      ],
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  logout() async {
    await authController.logout();
  }
}
