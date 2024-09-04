import 'package:flutter/material.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDeletion extends StatelessWidget {
  static const routeName = "/request-account-deletion";
  const AccountDeletion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Text(
          "Request Account Deletion".ctr,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Are you sure you want to request account deletion?'.ctr,
                  style: Get.theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'You will not be able to recover your data or login to your account'
                      .ctr,
                  style: Get.theme.textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url =
                          Uri.parse('https://forms.gle/F6mV1jM7PvmsuRwCA');
                      await launchUrl(url);
                    },
                    child: Text(
                      "Request Account Deletion".ctr,
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
}
