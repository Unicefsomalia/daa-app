import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/theme/dark_theme/dark_theme.dart';
import '../my_school/my_school_controller.dart';
import 'reports_list.dart';

// ignore: must_be_immutable
class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});

  AuthController authController = Get.find<AuthController>();
  MySchoolController mySchoolCont =
      Get.put<MySchoolController>(MySchoolController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: TextView(
          display_message: '@school_name#',
          data: mySchoolCont.schoolOverview.value,
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
                  'Reports'.ctr,
                  style: Get.theme.textTheme.bodyMedium,
                ),
                tileColor: Get.theme.primaryColor,
              ),
              ReportsList(),
            ],
          ),
        ),
      ),
    );
  }
}
