import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class ViewClassWidget extends StatelessWidget {
  final dynamic stream;

  const ViewClassWidget({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    var index = 0;
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Class @class_name# Learners".interpolate(stream),
              style: Get.textTheme.titleLarge,
            ),
          ),
          MyTable(
            type: MyTableType.list,
            showCount: false,
            noDataWidget: Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height / 2.5),
              child: Center(
                child: Text(
                  "This class has no learners".ctr,
                  style: Get.theme.textTheme.bodySmall,
                ),
              ),
            ),
            data: List<Map<String, dynamic>>.from(stream?["students"]),
            deleteMessageTemplate: "Delete Purchase @name# ?",
            onSelect: (ListViewOptions options, Map<String, dynamic> item) {
              // dprint(item);
            },
            itemBuilder: (context, student, options) {
              index = index + 1;
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
              );
            },
            options: ListViewOptions(
              separator: Divider(),
              physics: NeverScrollableScrollPhysics(),
            ),
            name: "class_learners_list",
            listTypeUrl: '',
          )
        ],
      ),
    );
  }
}
