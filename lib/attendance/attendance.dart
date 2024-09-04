import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/mixpanel/mixpanel_controller.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../my_school/my_school_controller.dart';
import '../shared/utils/utils.dart';
import '../shared/widgets/class_selector_scaffold_base/class_selector_controller.dart';
import '../shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import 'package:badges/badges.dart' as badges;

import 'attendance_controller.dart';

const name = "attendance";

// ignore: must_be_immutable
class AttendanceWidget extends StatelessWidget {
  AttendanceWidget({super.key});
  MySchoolController mySchoolCont = Get.find<MySchoolController>();

  AttendanceController attendanceCont = Get.put(AttendanceController());
  ClassSelectorController classCont = Get.find<ClassSelectorController>();
  NetworkStatusController netCont = Get.find<NetworkStatusController>();

  @override
  Widget build(BuildContext context) {
    return ClassSelectorScaffoldBasePage(
      name: name,
      title: "Mark Attendance".ctr,
      disableSelect: true,
      header: GestureDetector(
        onTap: () {
          mixpanelTrackEvent('attendance_date_picker_pressed');
          attendanceCont.chooseDate();
        },
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing Class List For'.ctr,
                      style: Get.theme.textTheme.titleMedium?.copyWith(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    Row(
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
                              .format(attendanceCont.attendance_date.value)
                              .toString(),
                          style: Get.theme.textTheme.titleMedium?.copyWith(
                            fontSize: 13,
                          ),
                        ),
                        if (attendanceCont.attendance_taken.value)
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                              right: 5.0,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            divider
          ],
        ),
      ),
      footer: Obx(() {
        if (classCont.selectedClass.value?["students"].isEmpty ?? true) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              if (!netCont.isDeviceConnected.value)
                Text(
                  "Taking attendance offline".ctr,
                  style: Get.textTheme.labelMedium
                      ?.copyWith(color: Get.theme.errorColor),
                ),
              ElevatedButton(
                onPressed: attendanceCont.isLoading.value
                    ? null
                    : () {
                        attendanceCont.takeAttendace();
                        mixpanelTrackEvent('attendance_pressed');
                      },
                child: Text(
                  attendanceCont.isLoading.value
                      ? "Submitting...".ctr
                      : attendanceCont.attendance_taken.value
                          ? 'Update attendance'.ctr
                          : "Submit".ctr,
                  style: Get.theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        );
      }),
      itemBuilder: (student, context, index) {
        return ListTile(
          leading: GestureDetector(
            onTap: () => showStudentMetaData(student),
            child: badges.Badge(
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
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () => showStudentMetaData(student),
            child: Container(
              color: Colors.transparent,
              child: TextView(
                display_message: "@full_name#",
                data: student,
                style: Get.theme.textTheme.titleMedium,
              ),
            ),
          ),
          subtitle: GestureDetector(
            onTap: () => showStudentMetaData(student),
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextView(
                    display_message: "@student_id#",
                    data: student,
                    style: Get.theme.textTheme.labelMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Wrap(spacing: 10, children: <Widget>[
                      badges.Badge(
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
                      if (student["has_special_needs"] == true)
                        badges.Badge(
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Colors.purple,
                              padding: EdgeInsets.all(5),
                            ),
                            badgeContent: TextView(
                              display_message: "LWD".ctr,
                              data: student,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ))
                    ]),
                  ),
                ],
              ),
            ),
          ),
          trailing: Obx(() {
            return Transform.scale(
              scale: 1.2,
              child: Checkbox(
                activeColor: Get.theme.primaryColor,
                onChanged: (bool? value) {
                  dprint(value);
                  attendanceCont.setStatus(student, value);
                },
                value: attendanceCont.present.value.contains(student["id"]),
              ),
            );
          }),
        );
      },
      separatorBuilder: (context, index) {
        return divider;
      },
    );
  }
}
