import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../my_school/my_school_controller.dart';
import '../../shared/widgets/base_auth_page.dart';
import 'options.dart';

class ContactUs extends StatelessWidget {
  static const routeName = "/contact-us";
  ContactUs({Key? key, this.override_options}) : super(key: key);
  AuthController authController = Get.find<AuthController>();

  final Map<String, dynamic>? override_options;

  @override
  Widget build(BuildContext context) {
    dprint('12121');
    dprint(authController.profile.value);

    MySchoolController mySchoolController = Get.find<MySchoolController>();
    var extraFields = {
      "school": mySchoolController.schoolOverview.value?['school'],
    };
    return BaseAuthPage(
      hasAppBar: true,
      name: "Contact Us",
      child: Center(
        child: SizedBox(
          width: 330,
          child: Column(
            children: [
              MyCustomForm(
                formItems: override_options ?? options,
                url: "api/v1/support-requests/",
                submitButtonText: "Submit",
                submitButtonPreText: "",
                loadingMessage: "Signing in...",
                onSuccess: (res) async {
                  Get.back();
                  Get.snackbar(
                    'Contact Us',
                    'Your support request has been successfully received!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                extraFields: extraFields,
                formGroupOrder: const [
                  ["name"],
                  ["email"],
                  ["phone"],
                  ["subject"],
                  ["body"]
                ],
                formTitle: "",
                name: "Contact",
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                // <-- TextButton
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Iconsax.back_square,
                  size: 14.0,
                  color: Colors.white,
                ),
                label: Text(
                  'Back To Help',
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
