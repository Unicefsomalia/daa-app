import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badges;
import '../../shared/utils/utils.dart';
import '../../shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import 'add_learner/add_learner.dart';
import 'deactivate_learner/deactivate_learner.dart';

// ignore: must_be_immutable
class LearnersList extends StatelessWidget {
  static const routeName = "/learners-list";
  LearnersList({super.key});

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // return SchoolMenuList(items: iconList);
    return ClassSelectorScaffoldBasePage(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.primaryColor,
        onPressed: () async {
          mixpanelTrackEvent('add_learner_button_pressed');
          var res = await Get.toNamed(AddLeaner.routeName);
          dprint(res);
        },
        child: const Icon(Icons.add),
      ),
      // ignore: prefer_const_constructors
      // header: Padding(
      //   padding: const EdgeInsets.only(
      //     top: 20.0,
      //     bottom: 10,
      //     left: 10,
      //     right: 10,
      //   ),
      //   // ignore: prefer_const_constructors
      //   child: searchBar,
      // ),
      name: "learners",
      title: "Learners".ctr,
      itemBuilder: (student, context, index) {
        return ListTile(
          leading: badges.Badge(
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Color(0xFF00AEEE),
                padding: EdgeInsets.all(8),
              ),
              badgeContent: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )),
          title: TextView(
            display_message: "@full_name#",
            data: student,
            style: Get.theme.textTheme.titleMedium,
          ),
          subtitle: Row(
            children: [
              TextView(
                display_message: "@student_id#",
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
                      display_message: "@gender#",
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
          trailing: Wrap(
            spacing: 30, // space between two icons
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Get.toNamed(AddLeaner.routeName,
                      arguments: {"instance": student});
                  dprint("Edit");
                },
                icon: const Icon(
                  Iconsax.edit,
                  size: 22.0,
                  color: Color(0xFF00AEEE),
                ),
              ),
              IconButton(
                onPressed: () {
                  dprint("Delete");
                  Get.bottomSheet(
                    DeactivateLearner(arguments: {"instance": student}),
                  );
                  mixpanelTrackEvent('deactivate_learner_pressed');
                },
                icon: const Icon(
                  Iconsax.profile_delete,
                  size: 22.0,
                  color: Color.fromARGB(255, 238, 55, 52),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return divider;
      },
    );
  }
}
