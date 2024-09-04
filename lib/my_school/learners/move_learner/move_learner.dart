import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import '../../../shared/utils/utils.dart';
import 'package:badges/badges.dart' as badges;
import '../../../shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import 'move_learner_controller.dart';

// ignore: must_be_immutable
class MoveLearners extends StatelessWidget {
  static const routeName = "/move-learner";
  MoveLearners({super.key});

  AuthController authController = Get.find<AuthController>();
  MoveLearnersController moveLearnersController =
      Get.put(MoveLearnersController());
  @override
  Widget build(BuildContext context) {
    return ClassSelectorScaffoldBasePage(
      name: "move".ctr,
      title: "Move Learners".ctr,
      // ignore: prefer_const_constructors
      // header: Padding(
      //   padding: const EdgeInsets.only(
      //     top: 15.0,
      //     bottom: 10,
      //     left: 10,
      //     right: 10,
      //   ),
      //   // ignore: prefer_const_constructors
      //   child: searchBar,
      // ),
      itemBuilder: (student, context, index) {
        return ListTile(
          leading: Obx(() {
            return Checkbox(
              activeColor: Get.theme.primaryColor,
              onChanged: (bool? value) {
                dprint(value);
                moveLearnersController.setStatus(student, value);
              },
              value:
                  moveLearnersController.students.value.contains(student["id"]),
            );
          }),
          // leading: GestureDetector(
          //   child: const Icon(Icons.radio_button_off),
          // ),
          title: TextView(
            display_message: "@full_name#".ctr,
            data: student,
            style: Get.theme.textTheme.titleSmall,
          ),
          subtitle: Row(
            children: [
              TextView(
                display_message: "@student_id#".ctr,
                data: student,
                style: Get.theme.textTheme.labelMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: student["gender"] == "M"
                          ? Get.theme.primaryColor
                          : Colors.pink,
                      padding: const EdgeInsets.all(6),
                    ),
                    badgeContent: TextView(
                      display_message: "@gender#".ctr,
                      data: student,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    )),
              ),
              if (student["has_special_needs"] == true)
                badges.Badge(
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.purple,
                      padding: EdgeInsets.all(5),
                    ),
                    badgeContent: TextView(
                      display_message: "LWD",
                      data: student,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ))
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return divider;
      },
      footer: SizedBox(
        width: 300,
        child: ElevatedButton(
          onPressed: () {
            mixpanelTrackEvent('move_learners_pressed');
            moveLearnersController.selectClassToMove();
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Get.theme.primaryColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: const Text("Move Learners"),
        ),
      ),
    );
  }
}
