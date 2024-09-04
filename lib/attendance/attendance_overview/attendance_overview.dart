import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/graphs/pie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:iconsax/iconsax.dart';
import '../../my_school/absence/absence_list.dart';
import '../../shared/utils/utils.dart';
import '../../theme/dark_theme/dark_theme.dart';

class DailyAttendanceOverview extends StatelessWidget {
  static const routeName = "/attendance-overview";
  const DailyAttendanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    var radius = Get.width * .9 / 2;
    var present_males = data["present_males"];
    var absent_males = data["absent_males"];
    var present_females = data["present_females"];
    var absent_females = data["absent_females"];
    var total_present = present_males + present_females;
    var total_absent = absent_males + absent_females;
    var total = present_males + present_females + absent_males + absent_females;

    var authCont = Get.find<AuthController>();

    dprint("Attendance $total");
    dprint(authCont.profile.value);

    dprint(data);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: false,
        title: Text(
          "Daily Attendance Report".ctr,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  bottom: 0.0,
                  right: 10.0,
                ),
                child: Card(
                  color: const Color.fromARGB(30, 0, 174, 238),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 5.0,
                        ),
                        child: TextView(
                          display_message:
                              'Thank you, @first_name# @last_name#'.ctr,
                          data: data,
                          style: Get.theme.textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: UtilsPieChart(
                          data: PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: present_males * 1.0,
                                radius: radius,
                                color: Get.theme.primaryColor,
                                title: '@present_males Present Males'
                                    .ctr
                                    .interpolate({
                                  "present_males": present_males,
                                }),
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              PieChartSectionData(
                                value: absent_males * 1.0,
                                radius: radius,
                                color: const Color.fromARGB(165, 255, 71, 71),
                                title: '@absent_males Absent Males'
                                    .ctr
                                    .interpolate(
                                        {"absent_males": absent_males}),
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              PieChartSectionData(
                                value: present_females * 1.0,
                                radius: radius,
                                color: Colors.deepPurple,
                                title: '@present_females Present Females'
                                    .ctr
                                    .interpolate({
                                  "present_females": present_females,
                                }),
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              PieChartSectionData(
                                value: absent_females * 1.0,
                                radius: radius,
                                color: const Color.fromARGB(255, 238, 101, 124),
                                title: '@absent_females Absent Females'
                                    .ctr
                                    .interpolate(
                                        {"absent_females": absent_females}),
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Get.theme.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Present Learners'.ctr,
                        style: Get.theme.textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        "Present Boys @present_males \nPresent Girls @present_females#"
                            .ctr
                            .interpolate({
                          "present_males": present_males,
                          "present_females": present_females
                        }),
                        style: Get.theme.textTheme.titleMedium?.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      trailing: badges.Badge(
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Colors.white,
                          padding: EdgeInsets.all(8),
                        ),
                        badgeContent: Text(
                          "$total_present",
                          style: const TextStyle(
                            color: Color(0xFF00AEEE),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: Card(
                  color: const Color.fromARGB(165, 255, 71, 71),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        'Absent Learners'.ctr,
                        style: Get.theme.textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        "Absent Boys @absent_males \nAbsent Girls @absent_females#"
                            .ctr
                            .interpolate({
                          "absent_males": absent_males,
                          "absent_females": absent_females
                        }),
                        style: Get.theme.textTheme.titleMedium?.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      trailing: badges.Badge(
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Colors.white,
                          padding: EdgeInsets.all(8),
                        ),
                        badgeContent: Text(
                          "$total_absent",
                          style: const TextStyle(
                            color: Color.fromARGB(164, 154, 144, 144),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AbsenceList.routeName, arguments: data);
                  mixpanelTrackEvent(
                      'attendance_overview_absence_reason_pressed');
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: const Color.fromARGB(190, 208, 48, 48),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Update Reasons For Absence'.ctr,
                          style: Get.theme.textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(Iconsax.arrow_right),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
