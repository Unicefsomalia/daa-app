import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/graphs/bar.dart';
import 'package:flutter_utils/graphs/graphs_models.dart';
import 'package:flutter_utils/graphs/pie.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';

import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moe_som_app/reports/reports_learner/reports_learner_controller.dart';

import '../../shared/utils/utils.dart';
import '../reports_class/report_class_controller.dart';
import 'learner_retention_controller.dart';

class LearnerRetentionRate extends StatelessWidget {
  late dynamic student;
  LearnerRetentionRate({super.key, this.student});

  LearnerRetentionReportController learnerRetentionReportController =
      Get.put(LearnerRetentionReportController());

  @override
  Widget build(BuildContext context) {
    LearnerReportController learnerCont = Get.find<LearnerReportController>();
    dprint(student);
    return Card(
      child: SingleChildScrollView(
        child: Builder(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTable(
                type: MyTableType.list,
                pageSize: 10,
                showCount: false,
                onControllerSetup: (controller) {
                  learnerRetentionReportController.tableController = controller;
                },
                args: {
                  "stream": "${learnerCont.stream.value}",
                  "start_date": learnerCont.getCurrentDate(),
                  "student": "${student["value"]}"
                },
                childBuilder: (cont1) {
                  var cont = learnerRetentionReportController.tableController;
                  var id = cont?.count.value;

                  dprint("Getting the data ada");

                  dprint(cont?.results);
                  learnerRetentionReportController.getPieChartData();

                  if (cont?.isLoading?.value ?? false) {
                    return Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * .25),
                        child: Text(
                          "Loading...",
                          style: Get.textTheme.titleMedium,
                        ),
                      ),
                    );
                  }
                  var is_present_greater = student["percentage_present"] >
                      student["percentage_absent"];
                  var absent_opacity = is_present_greater ? 0.5 : 1;
                  var present_opacity = is_present_greater ? 1 : .5;

                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Weekly Attendance Chart".ctr,
                              ),
                              TextView(
                                display_message: "@full_name#",
                                data: student,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                          bottom: 0.0,
                          right: 10.0,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CustomBarGraph(
                                data: List<Map<String, dynamic>>.from(
                                    cont?.results.value ?? []),
                                xAxisField: "value",
                                maxY: 7,
                                yAxisFields: [
                                  CustomBarChartRodData(
                                      field:
                                          'present_${student['gender'].toString().toLowerCase()}s'),
                                  CustomBarChartRodData(
                                      color: Colors.amber,
                                      field:
                                          'absent_${student['gender'].toString().toLowerCase()}s'),
                                ],
                              ),
                              // child: UtilsPieChart(
                              //   data: PieChartData(
                              //       sections: learnerRetentionReportController
                              //           .pieData.value),
                              // ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: ReporsStatsCard(
                          data: student,
                          title: 'Retention Risk',
                          subtitle:
                              "This is the probability calculated by number of days the student has appeared present",
                          backgroundColor: Get.theme.primaryColor
                              .withOpacity(present_opacity * 1.0),
                          count: '@percentage_present#%',
                          countColor: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: ReporsStatsCard(
                          data: student,
                          title: 'Dropout Risk',
                          subtitle:
                              "This is the risk of the student dropping out based on absent days",
                          backgroundColor:
                              const Color.fromARGB(165, 255, 71, 71)
                                  .withOpacity(absent_opacity * 1.0),
                          count: '@percentage_absent#%',
                          countColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                },
                name: 'weekly',
                listTypeUrl: 'api/v1/attendances/stats/week',
              ),
            ],
          );
        }),
      ),
    );
  }
}
