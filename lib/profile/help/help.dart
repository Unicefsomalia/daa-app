import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/profile/help/help_menu.dart';
import '../../theme/dark_theme/dark_theme.dart';

class Help extends StatelessWidget {
  static const routeName = "/help";
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Text(
          "Help and Support",
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HelpMenu(),
          ],
        ),
      ),
    );
  }
}
