import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../shared/widgets/class_selector_scaffold_base/class_selector_controller.dart';

class AbsenceListController extends GetxController {
  StreamSubscription? sub;

  var attendance_date = DateTime.now().obs;

  var stream;

  FormControl dateControl = FormControl<DateTime>(
    value: DateTime.now(),
  );

  TableController? tableController;
  ClassSelectorController classCont = Get.find<ClassSelectorController>();

  @override
  void onInit() {
    dprint("Init the list...");
    // TODO: implement onInit
    super.onInit();

    // dprint(Get.arguments);
    setPreSelectedDateandStream(Get.arguments);
    sub = classCont.selectedClass.listen((value) async {
      // dprint("The args new are");
      refreshList(tableController);
    });
  }

  setPreSelectedDateandStream(dynamic? streamDetails) {
    if (streamDetails?.containsKey("date") ?? false) {
      attendance_date.value =
          DateFormat("yyyy-MM-dd").parse(streamDetails?["date"]);
    }
    if (streamDetails?.containsKey("stream") ?? false) {
      var stream = classCont.classes.value
          .where((element) => element["stream"] == streamDetails?["stream"]);
      if (stream.isNotEmpty) {
        // dprint(stream);
        classCont.selectClass(stream.first);
      } else {
        dprint("Not stream of id ${streamDetails?['id']} found");
      }
    }
  }

  getCurrentDate() {
    return DateFormat("yyyy-MM-dd").format(attendance_date.value);
  }

  refreshAll() {
    refreshList(tableController);
  }

  refreshList(tableCont) async {
    var date = DateFormat("yyyy-MM-dd").format(attendance_date.value);
    tableCont?.args = {
      "stream": "${classCont.selectedClass.value?["id"]}",
      "date": date
    };
    dprint("Table absent args");
    dprint(tableCont?.args);
    await tableCont?.getData();
    dprint(" The Results are");
    dprint(tableController?.count);
    dprint(tableController?.entireBody.statusCode);
    dprint(tableController?.results.length);
  }

  @override
  void onDestroy() {
    sub?.cancel();

    super.onInit();
  }

  chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: attendance_date.value,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
      //initialEntryMode: DatePickerEntryMode.input,
      // initialDatePickerMode: DatePickerMode.year,
      helpText: 'Select Attendance Date',
      cancelText: 'Close',
      confirmText: 'Confirm',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter valid date range',
      fieldLabelText: 'DOB',
      fieldHintText: 'Month/Date/Year',
    );
    if (pickedDate != null && pickedDate != attendance_date.value) {
      attendance_date.value = pickedDate;
      refreshList(tableController);
    }
  }

  classChange() {}
}
