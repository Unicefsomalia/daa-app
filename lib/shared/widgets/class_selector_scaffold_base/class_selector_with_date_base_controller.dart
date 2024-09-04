import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/class_selector_scaffold_base/class_selector_controller.dart';

class ListClassListWithDateBase extends GetxController {
  var attendance_date = DateTime.now().obs;
  Rx<dynamic?> stream = Rx(null);
  ClassSelectorController classCont = Get.find<ClassSelectorController>();
  AuthProvider authProv = Get.find<AuthProvider>();
  var students = [].obs;

  StreamSubscription? classChangeSubscription;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    classChangeSubscription = classCont.selectedClass.listen((value) {
      dprint("Class changed");
      stream.value = value["id"];
      onDateClassChange();
    });

    var stream_id = classCont.selectedClass.value?["id"]?.toString() ?? "";
    stream.value = stream_id;
    // getAttendance(stream_id, attendance_date.value);
    onDateClassChange();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    classChangeSubscription?.cancel();
    super.onClose();
  }

  getCurrentDate() {
    return DateFormat("yyyy-MM-dd").format(attendance_date.value);
  }

  setStatus(student, status) {
    dprint(" Stream ${classCont.selectedClass.value?['id']} $stream ");
    var id = student["id"];
    var isPreset = students.value.contains(id);
    // dprint(student);
    // dprint(status);
    if (status) {
      if (!isPreset) {
        students.add(id);
      }
    } else {
      if (isPreset) {
        students.remove(id);
      }
    }
  }

  onDateClassChange() {
    students.value = [];
  }

  changeDate(DateTime pickedDate) {
    attendance_date.value = pickedDate;
    if (stream.value != null) {
      onDateClassChange();
    }
  }

  chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: attendance_date.value,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
      helpText: 'Select Date'.ctr,
      cancelText: 'Close'.ctr,
      confirmText: 'Confirm'.ctr,
      errorFormatText: 'Enter valid date'.ctr,
      errorInvalidText: 'Enter valid date range'.ctr,
      fieldLabelText: 'Date'.ctr,
      fieldHintText: 'Month/Date/Year'.ctr,
    );
    if (pickedDate != null && pickedDate != attendance_date.value) {
      attendance_date.value = pickedDate;
      changeDate(pickedDate);
    }
  }
}
