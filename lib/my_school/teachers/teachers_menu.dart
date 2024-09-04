import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/my_school/teachers/teachers_list.dart';

import '../../shared/utils/utils.dart';
import '../../shared/widgets/my_school_menu.dart';

// ignore: must_be_immutable
class TeachersMenu extends StatelessWidget {
  TeachersMenu({super.key});

  AuthController authController = Get.find<AuthController>();

  var teachersIconList = [
    MySchoolTile(
        label: "Add / Edit / Deactivate Teachers",
        iconData: Iconsax.add_square,
        routeName: TeachersList.routeName),
  ];

  @override
  Widget build(BuildContext context) {
    return SchoolMenuList(items: teachersIconList);
  }
}
