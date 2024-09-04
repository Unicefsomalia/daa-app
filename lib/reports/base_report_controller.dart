import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../shared/widgets/class_selector_scaffold_base/class_selector_with_date_base_controller.dart';

class BaseReportController extends ListClassListWithDateBase {
  TableController? tableController;
  var auth_controller = Get.find<AuthController>();

  Rx<Map<String, dynamic>?> instanceStats = Rx(null);
  Rx<List<PieChartSectionData>> pieData = Rx([]);

  @override
  onDateClassChange() async {
    // TODO: implement onDateClassChange
    super.onDateClassChange();
    dprint("Date or clase  chafed");

    var args = getArgs();
    dprint("Dem args");
    dprint(args);

    tableController?.args = args;
    await tableController?.getData();
  }

  getArgs() {
    dprint("Getting paramada,");
    // dprint(auth_controller.profile.value);
    var isTrainingSchool =
        auth_controller.profile.value?["is_training_school"] ?? false;

    var queryPrams = {
      "stream": "${stream.value}",
      "date": getCurrentDate(),
    };
    if (isTrainingSchool) {
      queryPrams["is_training_school"] = isTrainingSchool.toString();
    }
    dprint(queryPrams);

    return queryPrams;
  }

  getPieChartData() {
    int total_present = 0;
    int total_absent = 0;
    instanceStats.value = null;
    pieData.value = [];
    var piePoints = [];

    dprint("Getting the data\n");
    instanceStats.value = null;
    if (tableController == null) {
      dprint("No controller");
      return [];
    }
    if (tableController?.results.value?.isEmpty ?? true) {
      dprint("No data found");
      return [];
    }

    var instance_stats =
        tableController?.results.value?[0] as Map<String, dynamic>?;
    var absent = "absent";
    var present = "present";
    var total = "total";

    for (int i = 0; i < instance_stats!.keys.length; i++) {
      var key = instance_stats!.keys.toList()[i];
      if (key.contains("present")) {
        total_present = total_present + instance_stats?[key] as int;
        piePoints.add({"name": key, "value": instance_stats[key]});
      } else if (key.contains("absent")) {
        total_absent = total_absent + instance_stats?[key] as int;
        piePoints.add({"name": key, "value": instance_stats[key]});
      }
    }
    instance_stats["total_present"] = total_present;
    instance_stats["total_absent"] = total_absent;
    instanceStats.value = instance_stats;

    pieData.value = piePoints.map((e) {
      // dprint("Here is e");
      // dprint(e);
      var value = e["value"];
      var name = e["name"]?.replaceAll("_", " ");

      var colorsMap = {
        "present_males": Get.theme.primaryColor,
        "absent_males": const Color.fromARGB(165, 255, 71, 71),
        "present_females": Colors.deepPurple,
        "absent_females": const Color.fromARGB(255, 238, 101, 124),
      };
      return PieChartSectionData(
        value: double.parse("${e["value"]}"),
        radius: Get.width * .9 / 2,
        color: colorsMap[e["name"]],
        title: "$value $name",
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      );
      // return e;
    }).toList();
  }
}
