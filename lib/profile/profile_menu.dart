import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/profile/profile_base_page.dart';
import '../../shared/utils/utils.dart';

// ignore: must_be_immutable
class ProfileMenu extends StatelessWidget {
  ProfileMenu({super.key});

  AuthController authController = Get.find<AuthController>();

  var iconList = [
    MySchoolTile(
      label: "Edit Password",
      iconData: Iconsax.lock_1,
      routeName: "/change-password",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return ProfileBasePage(items: iconList);
  }
}
