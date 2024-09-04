import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/my_school/classes/classes_menu.dart';
import 'package:moe_som_app/theme/dark_theme/dark_theme.dart';
import '../shared/utils/utils.dart';
import 'learners/learners_menu.dart';
import 'my_school_controller.dart';
import 'teachers/teachers_menu.dart';

// ignore: must_be_immutable
class MySchoolPage extends StatelessWidget {
  MySchoolPage({super.key});

  AuthController authController = Get.find<AuthController>();
  MySchoolController mySchoolCont =
      Get.put<MySchoolController>(MySchoolController());

  @override
  Widget build(BuildContext context) {
    dprint(mySchoolCont?.schoolOverview.value);
    var is_school_admin = getIsSchoolAdmin();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: TextView(
          display_message: '@school_name#',
          data: mySchoolCont?.schoolOverview.value,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 14,
                ),
                ListTile(
                  title: Text(
                    'Learners'.ctr,
                    style: Get.theme.textTheme.bodyMedium,
                  ),
                  tileColor: Get.theme.primaryColor,
                  trailing: Chip(
                    label: TextView(
                      data: mySchoolCont?.schoolOverview.value,
                      display_message:
                          '@males Males | @females Females | @total Total Learners'
                              .ctr,
                      style: Get.theme.textTheme.labelSmall,
                    ),
                  ),
                ),
                LearnersMenu(),
                if (is_school_admin)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(
                          'Teachers'.ctr,
                          style: Get.theme.textTheme.bodyMedium,
                        ),
                        tileColor: Get.theme.primaryColor,
                        trailing: Chip(
                          label: TextView(
                            display_message: '@teachers Total Teachers'.ctr,
                            data: mySchoolCont?.schoolOverview.value,
                            style: Get.theme.textTheme.labelSmall,
                          ),
                        ),
                      ),
                      TeachersMenu(),
                      ListTile(
                        title: Text(
                          'Classes'.ctr,
                          style: Get.theme.textTheme.bodyMedium,
                        ),
                        tileColor: Get.theme.primaryColor,
                        trailing: Chip(
                          label: TextView(
                            display_message: '@classes Total Classes'.ctr,
                            data: mySchoolCont?.schoolOverview.value,
                            style: Get.theme.textTheme.labelSmall,
                          ),
                        ),
                      ),
                      ClassesMenu(),
                    ],
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
