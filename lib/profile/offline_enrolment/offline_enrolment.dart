import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/shared/utils/utils.dart';
import '../../my_school/my_school_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_utils/internalization/extensions.dart';
import 'offline_enrolment_list.dart';
import 'offline_saved_learners.dart';

// ignore: must_be_immutable
class OfflineEnrolmentPage extends StatelessWidget {
  static const routeName = "/offline-enrolment";

  OfflineEnrolmentPage({super.key});
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
          "Offline Enrolment Status",
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
            Center(
              child: Obx(() {
                return Column(
                  children: [
                    // ignore: prefer_const_constructors
                    divider,
                    OfflineEnrolmentList(),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: mySchoolCont.isUpdatinClassList.value
                          ? null
                          : mySchoolCont.updateClassList,
                      child: Text(mySchoolCont.isUpdatinClassList.value
                          ? 'Updating class list...'.ctr
                          : "Update Class List".ctr),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OfflineSavedLearnersList()
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
