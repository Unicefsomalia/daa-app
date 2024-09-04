import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../shared/widgets/base_auth_page.dart';
import 'options.dart';

class ForgotPassword extends StatelessWidget {
  static const routeName = "/forgot-password";
  const ForgotPassword({super.key, this.override_options});

  final Map<String, dynamic>? override_options;
  @override
  Widget build(BuildContext context) {
    return BaseAuthPage(
      hasAppBar: true,
      name: "Forgot Password",
      child: Center(
        child: SizedBox(
          width: 330,
          child: Column(
            children: [
              MyCustomForm(
                formItems: override_options ?? options,
                url: "api/v1/users/forgot-password/",
                submitButtonText: "Continue",
                submitButtonPreText: "",
                loadingMessage: "Loading...",
                onSuccess: (res) async {
                  Get.toNamed(
                    '/reset-password',
                    arguments: res,
                  );
                },
                formGroupOrder: const [
                  ["username"],
                ],
                name: "Forgot",
                formTitle: "",
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                // <-- TextButton
                onPressed: () {
                  Get.toNamed('/login');
                },
                icon: const Icon(
                  Iconsax.login,
                  size: 14.0,
                ),
                label: Text(
                  'Back To Login',
                  style: Get.theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
