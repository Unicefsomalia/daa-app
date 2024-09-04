import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../shared/utils/utils.dart';
import '../../shared/widgets/my_school_menu.dart';

// ignore: must_be_immutable
class ClassesMenu extends StatelessWidget {
  ClassesMenu({super.key});

  AuthController authController = Get.find<AuthController>();

  var classesIconList = [
    MySchoolTile(
        label: "Add / Edit / Deactivate Classes",
        iconData: Iconsax.add_square,
        routeName: "/classes-list"),
  ];

  @override
  Widget build(BuildContext context) {
    return SchoolMenuList(items: classesIconList);
  }
}
