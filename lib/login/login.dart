import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/mixpanel/mixpanel_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/login/options.dart';
import '../my_school/my_school_controller.dart';
import '../navigation/navigation.dart';
import '../shared/utils/utils.dart';
import '../shared/widgets/base_auth_page.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/Login";
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    MySchoolController mySchoolCont =
        Get.put<MySchoolController>(MySchoolController());

    return BaseAuthPage(
      name: "Login",
      child: Center(
        child: SizedBox(
          width: 330,
          child: Column(
            children: [
              LoginWidget(
                override_options: options,
                enableOfflineLogin: true,
                onLoginChange: (val) async {
                  dprint("Login status is");
                  // dprint(val);
                  try {
                    MixPanelController? mixCont =
                        Get.find<MixPanelController>();
                    mixCont.setLoggedInUser();
                    // dprint("Set the mixpanel user");
                  } catch (e) {
                    // dprint("Error setting mixpanel user");
                    dprint(e);
                  }
                  await mySchoolCont.updateClassList();

                  Get.offAllNamed(BottomNavigationPage.routeName);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                onPressed: () {
                  mixpanelTrackEvent('forgot_password_pressed');
                  Get.toNamed('/forgot-password');
                },
                icon: Icon(
                  Iconsax.password_check,
                  size: 14.0,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Forgot Password'.ctr,
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
