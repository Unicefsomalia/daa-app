import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/package_info/package_info_widget.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/profile/profile_menu.dart';
import 'package:moe_som_app/profile/settings_menu.dart';
import 'package:moe_som_app/theme/dark_theme/dark_theme.dart';
import '../my_school/my_school_controller.dart';
import '../shared/widgets/base_auth_page.dart';
import 'offline_status_controller.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  AuthController authController = Get.find<AuthController>();
  MySchoolController mySchoolCont =
      Get.put<MySchoolController>(MySchoolController());
  OfflineAttendanceController offAttCont =
      Get.find<OfflineAttendanceController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: TextView(
          display_message: '@school_name#'.ctr,
          data: mySchoolCont?.schoolOverview.value,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 14,
              ),
              ListTile(
                title: Text(
                  'User Profile'.ctr,
                  style: Get.theme.textTheme.bodyMedium,
                ),
                tileColor: Get.theme.primaryColor,
              ),
              ProfileMenu(),
              ListTile(
                title: Text(
                  'Application Settings'.ctr,
                  style: Get.theme.textTheme.bodyMedium,
                ),
                tileColor: Get.theme.primaryColor,
              ),
              SettingsMenu(),
              const SizedBox(
                height: 10,
              ),
              ChangeLanguageWidget(),
              PackageInfoWidget(
                widgetBuilder: (context, packageInfo) {
                  return TextButton.icon(
                    // <-- TextButton
                    onPressed: () {},
                    icon: const Icon(
                      Iconsax.mobile_programming,
                      size: 14.0,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Version: ${packageInfo?.version ?? 'Loading...'}'.ctr,
                      style: Get.theme.textTheme.labelMedium,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
