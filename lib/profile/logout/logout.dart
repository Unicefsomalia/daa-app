import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/login/login.dart';
import '../../my_school/my_school_controller.dart';

// ignore: must_be_immutable
class LogoutPage extends StatelessWidget {
  static const routeName = "/logout";
  LogoutPage({super.key});
  AuthController authController = Get.find<AuthController>();
  MySchoolController mySchoolCont =
      Get.put<MySchoolController>(MySchoolController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Text(
          "Logout".ctr,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Logged in".ctr,
              style: Get.theme.textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  'Are you sure you want to logout?'.ctr,
                  style: Get.theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'You can log back in offline mode with this account'.ctr,
                  style: Get.theme.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await logout();
                      Get.offAllNamed(LoginPage.routeName);
                    },
                    child: Text(
                      "Logout".ctr,
                      style: Get.theme.textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  logout() async {
    await authController.lock();
  }
}
