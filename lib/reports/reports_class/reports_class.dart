import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/graphs/pie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:moe_som_app/reports/reports_class/report_class_controller.dart';
import 'package:moe_som_app/shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import '../../../my_school/absence/absence_list.dart';
import '../../../theme/dark_theme/dark_theme.dart';
import '../../shared/utils/utils.dart';
import '../reports_learner/reports_learner.dart';

class ReportsClassPage extends StatelessWidget {
  static const routeName = "/report-class";
  ReportsClassPage({super.key});

  ClassReportController classReportController =
      Get.put(ClassReportController());

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    var radius = Get.width * .9 / 2;
    // var present_males = data["present_males"];
    // var absent_males = data["absent_males"];
    // var present_females = data["present_females"];
    // var absent_females = data["absent_females"];
    var auth_controller = Get.find<AuthController>();
    var present_males = 1;
    var absent_males = 1;
    var present_females = 1;
    var absent_females = 1;
    var total_present = present_males + present_females;
    var total_absent = absent_males + absent_females;
    var total = present_males + present_females + absent_males + absent_females;
    var is_training_school =
        auth_controller.profile.value?["is_training_school"] ?? false;
    dprint("Attendance $total");

    return ClassSelectorScaffoldBasePage(
      name: 'reports',
      title: 'Attendance Report',
      child: MyTable(
        type: MyTableType.list,
        pageSize: 20,
        showCount: false,
        onControllerSetup: (cont) {
          classReportController.tableController = cont;
        },
        args: {
          "stream": "${classReportController.stream.value}",
          "date": classReportController.getCurrentDate(),
          "is_training_school": is_training_school.toString(),
        },
        childBuilder: (cont1) {
          var cont = classReportController.tableController;
          var id = cont?.count.value;
          classReportController.getPieChartData();
          if (cont?.isLoading?.value ?? false) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * .25),
                child: Text(
                  "Loading...".ctr,
                  style: Get.textTheme.titleMedium,
                ),
              ),
            );
          }

          return Obx(() {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Showing Class List For'.ctr,
                            style: Get.theme.textTheme.titleSmall?.copyWith(
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: classReportController.chooseDate,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Iconsax.calendar_1,
                                    size: 20,
                                    color: Color(0xFF00AEEE),
                                  ),
                                ),
                                Text(
                                  DateFormat("dd-MM-yyyy")
                                      .format(classReportController
                                          .attendance_date.value)
                                      .toString(),
                                  style: Get.theme.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (classReportController.instanceStats.value == null)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * .25),
                        child: Center(
                            child: Text("No attendance taken".ctr,
                                style: Get.theme.textTheme.bodySmall)),
                      ),
                    if (classReportController.instanceStats.value != null)
                      Column(
                        children: [
                          divider,
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
                                    padding: const EdgeInsets.all(10.0),
                                    child: UtilsPieChart(
                                      data: PieChartData(
                                          sections: classReportController
                                              .pieData.value),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: ReporsStatsCard(
                              data: classReportController.instanceStats.value,
                              title: 'Present Learners',
                              subtitle: "Present Boys @present_males# \n"
                                  "Present Girls @present_females#",
                              backgroundColor: Get.theme.primaryColor,
                              count: '@total_present#',
                              countColor: Color(0xFF00AEEE),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: ReporsStatsCard(
                              data: classReportController.instanceStats.value,
                              title: 'Absent Learners',
                              subtitle: "Absent Boys @absent_males# \n"
                                  "Absent Girls @absent_females#",
                              backgroundColor:
                                  const Color.fromARGB(165, 255, 71, 71),
                              count: '@total_absent#',
                              countColor: Color.fromARGB(164, 154, 144, 144),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(ReportsLearnerPage.routeName,
                                  arguments: {
                                    "date": classReportController
                                        .attendance_date.value
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                color: const Color.fromARGB(190, 208, 48, 48),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Attendance Report By Learner'.ctr,
                                      style: Get.theme.textTheme.titleLarge
                                          ?.copyWith(
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
                  ],
                ),
              ),
            );
          });
        },
        name: 'class_report',
        listTypeUrl: 'api/v1/attendances/stats/day',
      ),
    );
  }
}
