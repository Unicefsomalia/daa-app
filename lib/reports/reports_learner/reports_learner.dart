import 'package:flutter/material.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/graphs/pie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:moe_som_app/reports/reports_class/report_class_controller.dart';
import 'package:moe_som_app/reports/reports_learner/reports_learner_controller.dart';
import 'package:moe_som_app/shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import '../../../my_school/absence/absence_list.dart';
import '../../../theme/dark_theme/dark_theme.dart';
import '../../shared/utils/utils.dart';
import 'learner_retention_rate.dart';

class ReportsLearnerPage extends StatelessWidget {
  static const routeName = "/report-learner";
  ReportsLearnerPage({super.key});

  LearnerReportController learnerReportController =
      Get.put(LearnerReportController());

  onSelectStudent(dynamic student) async {
    dprint("Selected");
    var bottomSheetWidget = LearnerRetentionRate(student: student);
    var res = await Get.bottomSheet(bottomSheetWidget);
  }

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    var radius = Get.width * .9 / 2;
    if (data != null) {
      var date = data?["date"];
      if (date != null) {
        learnerReportController.changeDate(date);
      }
    }

    return ClassSelectorScaffoldBasePage(
      name: 'reports',
      title: 'Learner Attendance Report',
      child: MyTable(
        type: MyTableType.list,
        pageSize: 20,
        showCount: false,
        onControllerSetup: (cont) {
          learnerReportController.tableController = cont;
        },
        args: learnerReportController.getArgs(),
        childBuilder: (cont1) {
          var cont = learnerReportController.tableController;
          var id = cont?.count.value;
          // learnerReportController.getPieChartData();
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
                            'Showing Attendance from'.ctr,
                            style: Get.theme.textTheme.titleMedium?.copyWith(
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: learnerReportController.chooseDate,
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
                                      .format(learnerReportController
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
                    divider,
                    if (learnerReportController
                            .tableController?.results.value.isEmpty ??
                        false)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * .25),
                        child: Center(
                            child: Text("No attendance taken".ctr,
                                style: Get.theme.textTheme.bodySmall)),
                      ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        dprint("Index is $index");
                        dprint(learnerReportController
                            .tableController?.results.value.length);
                        var student = learnerReportController
                            .tableController?.results.value[index];
                        dprint(student);
                        double percentage = student["present_count"] *
                            100 /
                            student["total_attendances_taken"] *
                            1.0;
                        var percentageInt = percentage.round();
                        // dprint(percentageInt);
                        student["percentage_present"] = percentageInt;
                        student["percentage_absent"] = 100 - percentageInt;

                        double value = student["percentage_present"] / 100;
                        // calculate the red and green values based on the percentage
                        int redValue = (255 * (1 - value)).round();
                        int greenValue = (255 * value).round();
                        // set the color based on the red and green values
                        var retentionColor =
                            Color.fromRGBO(redValue, greenValue, 0, 1);

                        return LearnerAttendance(
                          student: student,
                          onSelect: (stud) {
                            onSelectStudent(stud);
                          },
                          color: retentionColor,
                          index: index + 1,
                          subtitle:
                              "Present @present_count Times \nAbsent @absent_count Times",
                          title: "@full_name#",
                          trailing: '@percentage_present#% Present',
                        );
                      },
                      separatorBuilder: (context, index) {
                        return divider;
                      },
                      itemCount: learnerReportController
                              ?.tableController?.results.value?.length ??
                          0,
                    ),
                  ],
                ),
              ),
            );
          });
        },
        name: 'learner_report',
        listTypeUrl: 'api/v1/attendances/stats/student',
      ),
    );
  }
}

class LearnerAttendance extends StatelessWidget {
  late String title;
  late String subtitle;
  late int index;
  late Color color;
  late String trailing;
  late Map<String, dynamic> student;
  late Function(Map<String, dynamic>)? onSelect;

  LearnerAttendance({
    super.key,
    required this.index,
    required this.subtitle,
    required this.title,
    required this.trailing,
    required this.student,
    required this.color,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onSelect != null) {
          onSelect!(student);
        }
      },
      child: ListTile(
        leading: badges.Badge(
          badgeStyle: badges.BadgeStyle(
            badgeColor: Color(0xFF00AEEE),
            padding: EdgeInsets.all(8),
          ),
          badgeContent: Text(
            "$index",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        title: TextView(
          data: student,
          display_message: title.ctr,
          style: Get.theme.textTheme.titleSmall,
        ),
        subtitle: TextView(
          data: student,
          display_message: subtitle.ctr,
          // "Present 17 Times \n" "Absent 21 Times",
          style: Get.theme.textTheme.labelMedium,
        ),
        trailing: Wrap(
          spacing: 30,
          children: <Widget>[
            TextView(
              data: student,
              display_message: trailing.ctr,
              style: Get.theme.textTheme.titleSmall?.copyWith(
                color: color,
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
            ),
          ],
        ),
      ),
    );
  }
}
