// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/navigation/navigation.dart';
import 'package:moe_som_app/profile/profile_base_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/utils/utils.dart';
import 'help_controller.dart';

// ignore: must_be_immutable
class HelpMenu extends StatelessWidget {
  HelpMenu({super.key});

  AuthController authController = Get.find<AuthController>();

  var helpOptions = [
    HelpOptions(
      label: 'Contact Us',
      routeName: '/contact-us',
    ),
    HelpOptions(
      label: 'View User Manual',
      routeName: 'https://sisitech.github.io/UNICEFSomaliaDocs/',
      isInternal: false,
    ),
    HelpOptions(
      label: 'Download User Manual',
      routeName: 'https://somdash.request.africa/unicef-somalia-manual.pdf',
      isInternal: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var helpCont = Get.put(HelpController());
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 14,
          ),
          Text(
            'Frequently Asked Questions'.ctr,
            style: Get.theme.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: helpCont.supportQuestions.value.length,
              itemBuilder: (context, index) {
                var tile = helpCont.supportQuestions.value[index];
                return ExpansionTile(
                  title: Text(
                    tile.title.ctr,
                    style: Get.theme.textTheme.bodyMedium,
                  ),
                  collapsedBackgroundColor: Get.theme.primaryColor,
                  textColor: Get.theme.primaryColor,
                  children: <Widget>[
                    ListTile(
                        title: Text(
                      tile.content.ctr,
                      style: Get.theme.textTheme.bodyMedium,
                    )),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Text('');
              },
            );
          }),
          const SizedBox(
            height: 20,
          ),
          Text(
            'More Support Options'.ctr,
            style: Get.theme.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 330,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: helpOptions.length,
              itemBuilder: (context, index) {
                var tile = helpOptions[index];
                return ElevatedButton(
                  onPressed: () {
                    if (tile.isInternal) {
                      Get.toNamed(tile.routeName);
                    } else {
                      launchURL(tile.routeName);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Get.theme.primaryColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(tile.label.ctr),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Text('');
              },
            ),
          ),
        ],
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
