import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';

Widget getStudentListTileView(dynamic student, int index) {
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
        ],
      ));
}
