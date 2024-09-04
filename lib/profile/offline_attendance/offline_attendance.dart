import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/shared/utils/utils.dart';
import '../../my_school/my_school_controller.dart';
import 'package:badges/badges.dart' as badges;

import 'offline_attendance_list.dart';

// ignore: must_be_immutable
class OfflineAttendancePage extends StatelessWidget {
  static const routeName = "/offline-attendance";

  OfflineAttendancePage({super.key});
  AuthController authController = Get.find<AuthController>();
  MySchoolController mySchoolCont =
      Get.put<MySchoolController>(MySchoolController());

  @override
  Widget build(BuildContext context) {
    var mySchoolCont = Get.find<MySchoolController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Text(
          "Offline Attendance Status".ctr,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 14,
            ),
            divider,
            const OfflineAttendanceList(),
          ],
        ),
      ),
    );
  }
}
