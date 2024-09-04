import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/internalization/language_controller.dart';
import 'package:flutter_utils/internalization/select_locale.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/utils.dart';

const imageSize = 154.0;
const imageSizeSomalia = 250.0;

// ignore: must_be_immutable
class BaseAuthPage extends StatelessWidget {
  final Widget child;
  final String name;
  final bool hasAppBar;

  BaseAuthPage({
    super.key,
    required this.child,
    required this.name,
    this.hasAppBar = false,
  });

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasAppBar
          ? AppBar(
              backgroundColor: Get.theme.primaryColor,
              centerTitle: false,
              title: Text(
                name,
                style: Get.theme.textTheme.titleLarge,
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                      style: Get.theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      name.ctr,
                      style: Get.theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                child,
                const SizedBox(
                  height: 5,
                ),
                const LocaleSelectorWidget(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChangeLanguageWidget(),
                  ],
                )),
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

  logout() async {
    await authController.logout();
  }
}

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localeCont = Get.find<LocaleController>();
    return TextButton.icon(
      onPressed: () {
        mixpanelTrackEvent('change_language_pressed');
        localeCont.selectLocale();
      },
      icon: Icon(
        Iconsax.language_circle,
        size: 14.0,
        color: Theme.of(context).primaryColor,
      ),
      label: Text(
        'Change Language / Badel Luuqada',
        style: Get.theme.textTheme.labelMedium,
      ),
    );
  }
}
