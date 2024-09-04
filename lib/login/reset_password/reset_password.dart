import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/login/login.dart';

import '../../shared/widgets/base_auth_page.dart';
import 'options.dart';

class ResetPassword extends StatelessWidget {
  static const routeName = "/reset-password";
  const ResetPassword({Key? key, this.override_options}) : super(key: key);

  final Map<String, dynamic>? override_options;

  @override
  Widget build(BuildContext context) {
    return BaseAuthPage(
      hasAppBar: true,
      name: "Password Reset",
      child: Center(
        child: SizedBox(
          width: 330,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              MyCustomForm(
                formItems: override_options ?? options,
                url: "api/v1/users/reset-password/",
                submitButtonText: "Reset Password",
                submitButtonPreText: "",
                loadingMessage: "Resetting...",
                onSuccess: (res) async {
                  Get.offAllNamed(LoginPage.routeName);
                },
                formGroupOrder: const [
                  ["reset_code"],
                  ["new_password"],
                  ["confirm_password"],
                ],
                formTitle: "Reset",
                name: 'Reset',
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
