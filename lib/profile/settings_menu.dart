import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/profile/profile_base_page.dart';
import '../../shared/utils/utils.dart';

// ignore: must_be_immutable
class SettingsMenu extends StatelessWidget {
  SettingsMenu({super.key});

  AuthController authController = Get.find<AuthController>();

  var iconList = [
    MySchoolTile(
        label: "Offline Attendance Status",
        iconData: Iconsax.cloud_change,
        routeName: "/offline-attendance"),
    MySchoolTile(
        label: "Offline Enrolment Status",
        iconData: Iconsax.cloud_add,
        routeName: "/offline-enrolment"),
    MySchoolTile(
        label: "Request Account Deletion",
        iconData: Iconsax.profile_delete,
        routeName: "/request-account-deletion"),
    MySchoolTile(
        label: "Help and Support",
        iconData: Iconsax.message_question,
        routeName: "/help"),
    MySchoolTile(
      label: "Logout",
      iconData: Iconsax.logout,
      routeName: "/logout",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfileBasePage(items: iconList);
  }
}
