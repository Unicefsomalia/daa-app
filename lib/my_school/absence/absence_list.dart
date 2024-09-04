import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';
import '../../shared/utils/utils.dart';
import '../../shared/widgets/class_selector_scaffold_base/class_selector_controller.dart';
import '../../shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import '../../theme/dark_theme/dark_theme.dart';
import 'absence-reasons.dart';
import 'absence_controller.dart';

// ignore: must_be_immutable
class AbsenceList extends StatelessWidget {
  static const routeName = "/absence-list";
  AbsenceList({super.key});

  AuthController authController = Get.find<AuthController>();
  ClassSelectorController classCont = Get.find<ClassSelectorController>();
  AbsenceListController absenceCont = Get.put(AbsenceListController());

  onSelectAbsentStudent() async {
    dprint("Selected");
    var bottomSheetWidget = Card(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Provide Reason For Absence".ctr,
                style: Get.theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
    var res = await Get.bottomSheet(bottomSheetWidget);
  }

  @override
  Widget build(BuildContext context) {
    // return SchoolMenuList(items: iconList);

    return ClassSelectorScaffoldBasePage(
      name: "absence".ctr,
      title: "View Absent Student List".ctr,
      // ignore: prefer_const_constructors
      header: Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          bottom: 10,
          left: 10,
          right: 10,
        ),
        // ignore: prefer_const_constructors
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing Absent List For'.ctr,
                      style: Get.theme.textTheme.titleMedium?.copyWith(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        absenceCont.chooseDate();
                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Iconsax.calendar_1,
                              size: 20,
                            ),
                          ),
                          Text(
                            DateFormat("dd-MM-yyyy")
                                .format(absenceCont.attendance_date.value)
                                .toString(),
                            style: Get.theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            divider,
            const SizedBox(
              height: 10,
            ),
            // searchBar,
          ],
        ),
      ),
      child: Obx(() {
        dprint("Changedd");
        var date =
            DateFormat("yyyy-MM-dd").format(absenceCont.attendance_date.value);

        var args = {
          "stream": "${classCont.selectedClass.value?["id"]}",
          "date": date,
        };
        return MyTable(
          type: MyTableType.list,
          pageSize: 100,
          enableDelete: true,
          args: args,
          showCount: false,
          noDataWidget: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height / 2.5),
            child: Center(
              child: Text(
                "No absent list for this date".ctr,
                style: Get.theme.textTheme.bodySmall,
              ),
            ),
          ),
          onControllerSetup: (controller) {
            absenceCont.tableController = controller;
          },
          enableEdit: true,
          // updateWidget: () => AddPurchase(),
          enableView: true,
          // transformRow: (row) => transformPurchase(row),

          // deleteMessageTemplate: "Delete Purchase @name# ?",
          onSelect: (ListViewOptions options, Map<String, dynamic> item) {
            // dprint(item);
          },
          itemBuilder: (context, student, options) {
            var index = 0;
            var has_given_reason = student["reason_absent"] != null;
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
                    onTap: () {
                      Get.bottomSheet(
                        AbsenceReasons(arguments: {"instance": student}),
                      );
                    },
                    child: IconButton(
                      onPressed: () {
                        dprint("Delete");
                        Get.bottomSheet(
                          AbsenceReasons(arguments: {"instance": student}),
                        );
                      },
                      icon: has_given_reason
                          ? const Icon(
                              Iconsax.user_tick,
                              size: 22.0,
                              color: Colors.green,
                            )
                          : const Icon(
                              Iconsax.user_add,
                              size: 22.0,
                              color: Color(0xFFD86745),
                            ),
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
          name: "absence_list",
          // listTypeUrl: "api/v1/students/",
          listTypeUrl: "api/v1/students/absents",
        );
      }),
      separatorBuilder: (context, index) {
        return divider;
      },
    );
  }
}
