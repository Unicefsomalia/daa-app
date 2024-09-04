import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../shared/utils/utils.dart';
import '../../shared/widgets/my_school_menu.dart';
import 'deactivate_learner/deactivated_list.dart';

// ignore: must_be_immutable
class LearnersMenu extends StatelessWidget {
  LearnersMenu({super.key}) {
    var isAdmin = getIsSchoolAdmin();
    if (isAdmin) {
      iconList.addAll([
        // MySchoolTile(
        //     label: "Promote Learners",
        //     iconData: Iconsax.arrow_square_up,
        //     adminOnly: true,
        //     routeName: "/"),
        MySchoolTile(
            label: "Move Learners",
            iconData: Iconsax.arrange_square,
            routeName: "/move-learner"),
        MySchoolTile(
            label: "Reactivate Learners",
            iconData: Iconsax.minus_square,
            adminOnly: true,
            routeName: DeactivatedLearnersList.routeName),
      ]);
    }
  }

  AuthController authController = Get.find<AuthController>();

  var iconList = [
    MySchoolTile(
        label: "Add / Edit / Deactivate Learners",
        iconData: Iconsax.add_square,
        routeName: "/learners-list"),
    MySchoolTile(
        label: "Update Reasons For Absence",
        iconData: Iconsax.personalcard,
        routeName: "/absence-list"),
  ];

  @override
  Widget build(BuildContext context) {
    return SchoolMenuList(items: iconList);
  }
}
