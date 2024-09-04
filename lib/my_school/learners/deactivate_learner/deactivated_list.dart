import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/my_school/learners/reactivate_learner/reactivate_learner.dart';

import '../../../shared/utils/utils.dart';
import 'package:badges/badges.dart' as badges;

import '../../../theme/dark_theme/dark_theme.dart';

class DeactivatedLearnersList extends StatelessWidget {
  static const routeName = "/deactivated-list";

  DeactivatedLearnersList({super.key});

  TableController? controller;
  @override
  Widget build(BuildContext context) {
    int index = 0;
    AuthController authCont = Get.find<AuthController>();
    var profile = authCont.getProfile();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reactivate Learners".ctr,
          style: Get.theme.textTheme.titleLarge,
        ),
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: MyTable(
                type: MyTableType.list,
                pageSize: 100,
                enableDelete: true,
                args: {"school": "${profile?["school"]}", "active": "false"},
                showCount: false,
                noDataWidget: Padding(
                  padding: EdgeInsets.symmetric(vertical: Get.height / 2.5),
                  child: Center(
                    child: Text(
                      "No learners found".ctr,
                      style: Get.theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
                onControllerSetup: (cont) {
                  controller = cont;
                },
                enableEdit: true,
                enableView: true,
                onSelect: (ListViewOptions options, Map<String, dynamic> item) {
                  // dprint(item);
                },
                itemBuilder: (context, student, options) {
                  index += 1;
                  var has_given_reason = student["reason_absent"] != null;
                  return ListTile(
                    leading: badges.Badge(
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Color(0xFF00AEEE),
                          padding: EdgeInsets.all(8),
                        ),
                        badgeContent: Text(
                          "${index}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        )),
                    title: TextView(
                      display_message: "@full_name#".ctr,
                      data: student,
                      style: Get.theme.textTheme.titleSmall,
                    ),
                    subtitle: Row(
                      children: [
                        TextView(
                          display_message: "@student_id#\n@class_name#".ctr,
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
                            ),
                          )
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 30, // space between two icons
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: IconButton(
                            onPressed: () async {
                              dprint("Delete");
                              await Get.bottomSheet(
                                ReactivateLearner(
                                    arguments: {"instance": student}),
                              );

                              controller?.getData();
                            },
                            icon: Icon(Icons.person_add),
                          ),
                        ),
                        GestureDetector(
                          child: IconButton(
                            onPressed: () async {
                              dprint("Call Guardian");
                              await launchGuardianCall(student);
                            },
                            icon: const Icon(
                              Iconsax.call,
                              size: 22.0,
                              color: Color(0xFF00AEEE),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                options: ListViewOptions(
                  separator: Divider(),
                  physics: NeverScrollableScrollPhysics(),
                  // imageField: "image",
                ),
                name: "deactivate_learners_list",
                listTypeUrl: "api/v1/students/",
              ),
            )
          ],
        ),
      )),
    );
  }
}
