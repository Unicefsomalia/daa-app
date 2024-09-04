import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import '../../reports/reports.dart';
import '../../theme/dark_theme/dark_theme.dart';
import 'options.dart';

const imageSize = 154.0;
const imageSizeSomalia = 250.0;

class EditPassword extends StatelessWidget {
  static const routeName = "/change-password";
  const EditPassword({Key? key, this.override_options}) : super(key: key);

  final Map<String, dynamic>? override_options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Text(
          "Edit Password".ctr,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Image(
                  image: AssetImage('images/unicef-logo.png'),
                  width: imageSize,
                  height: imageSize,
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Proceed with".ctr,
                      style: Get.theme.textTheme.titleSmall,
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Edit Password'.ctr,
                      style: Get.theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 330,
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        MyCustomForm(
                          formItems: override_options ?? options,
                          url: "api/v1/users/me/change-password/",
                          submitButtonText: "Change Password",
                          status: FormStatus.Replace,
                          submitButtonPreText: "",
                          loadingMessage: "Resetting...",
                          instance: const {
                            // "id": "chanxge-password",
                          },
                          customDataValidation: (form) {
                            var new_password = form?["new_password"];
                            var confirm_password = form?["confirm_password"];
                            if (confirm_password != new_password) {
                              return {
                                "confirm_password": "Passwords do not match".ctr
                              };
                            }
                            return null;
                          },
                          onSuccess: (res) async {
                            Get.back();
                            Get.defaultDialog(
                              title: "Successful".ctr,
                              titleStyle: Get.textTheme.titleSmall,
                              content: Text(
                                "Password updated".ctr,
                                style: Get.textTheme.labelMedium,
                              ),
                              onConfirm: () {
                                Get.back();
                              },
                            );
                          },
                          formGroupOrder: const [
                            ["old_password"],
                            ["new_password"],
                            ["confirm_password"],
                          ],
                          formTitle: "",
                          name: "Change",
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Image(
                  image: AssetImage('images/moe-somalia.png'),
                  width: imageSizeSomalia,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
