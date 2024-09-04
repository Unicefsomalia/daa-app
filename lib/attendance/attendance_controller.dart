import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/offline_http_cache/offline_http_cache.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:moe_som_app/my_school/my_school_controller.dart';
import 'package:moe_som_app/navigation/navigation.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../shared/utils/utils.dart';
import '../shared/widgets/class_selector_scaffold_base/class_selector_controller.dart';
import 'attendance_overview/attendance_overview.dart';

class AttendanceController extends GetxController {
  var cacheAttendance;
  final box = GetStorage();

  var attendance_taken = false.obs;

  FormControl dateControl = FormControl<DateTime>(
    value: DateTime.now(),
  );

  var attendance_date = DateTime.now().obs;
  Rx<dynamic?> stream = Rx(null);

  ClassSelectorController classCont = Get.find<ClassSelectorController>();
  AuthController authCont = Get.find<AuthController>();
  AuthProvider authProv = Get.find<AuthProvider>();
  NetworkStatusController netCont = Get.find<NetworkStatusController>();
  OfflineHttpCacheController offlnCont = Get.find<OfflineHttpCacheController>();
  MySchoolController myschoolCont = Get.find<MySchoolController>();

  var present = [].obs;

  StreamSubscription? classChangeSubscription;

  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    classChangeSubscription = classCont.selectedClass.listen((value) {
      dprint("Class changed");

      stream.value = value["id"];
      if (stream.value != null && attendance_date.value != null) {
        getAttendance(stream.value.toString(), attendance_date.value);
      }
    });

    var stream_id = classCont.selectedClass.value?["id"]?.toString() ?? "";
    dprint("$stream_id Clas");
    getAttendance(stream_id, attendance_date.value);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    classChangeSubscription?.cancel();
    super.onClose();
  }

  bool getStatus(student) {
    return false;
  }

  var now = DateTime.now();

  chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: attendance_date.value,
      firstDate: DateTime.now().add(Duration(days: -7)),
      lastDate: DateTime.now(),
      helpText: 'Select Attendance Date'.ctr,
      cancelText: 'Close'.ctr,
      confirmText: 'Confirm'.ctr,
      errorFormatText: 'Enter valid date'.ctr,
      errorInvalidText: 'Enter valid date range'.ctr,
      fieldLabelText: 'DOB'.ctr,
      fieldHintText: 'Month/Date/Year'.ctr,
    );
    if (pickedDate != null && pickedDate != attendance_date.value) {
      attendance_date.value = pickedDate;
      if (stream.value != null) {
        getAttendance(stream.value, attendance_date.value);
      }
    }
  }

  takeAttendace() async {
    dprint("Taking attendance");
    dprint(present.value);

    var card = Card(
      child: TextView(
        display_message: "Taking attendance".ctr,
      ),
    );
    var date = DateFormat("yyyy-MM-dd").format(attendance_date.value);
    var students = classCont.selectedClass.value?["students"] ?? [];
    var all_students = students.map((elem) => elem["id"]).toList();

    var males = students
        .where((stud) => stud["gender"] == "M")
        .map((elem) => elem["id"])
        .toList();
    var females = students
        .where((stud) => stud["gender"] == "F")
        .map((elem) => elem["id"])
        .toList();

    var males_present =
        males.where((id) => present.value.contains(id)).toList();

    var females_present =
        females.where((id) => present.value.contains(id)).toList();

    var absent =
        all_students.where((id) => !present.value.contains(id)).toList();

    var data = {
      "class_name": classCont.selectedClass.value["class_name"],
      "stream": stream.value,
      "present": present.value.length,
      "absent": absent.length,
      "date": date,
      "present_males": males_present.length,
      "absent_males": males.length - males_present.length,
      "present_females": females_present.length,
      "absent_females": females.length - females_present.length,
    };
    // dprint(data);
    Get.defaultDialog(
        title: 'Take Attendance'.ctr,
        titleStyle: Get.theme.textTheme.titleLarge,
        cancelTextColor: Colors.white,
        confirmTextColor: Colors.black,
        buttonColor: Get.theme.primaryColor,
        textCancel: "Cancel".ctr,
        textConfirm: "Take".ctr,
        onConfirm: () async {
          var att_data = {
            "present": present.value,
            "absent": absent,
            "stream": stream.value,
            "date": date
          };
          // dprint(att_data);
          Get.back();

          // authProv
          String url = "api/v1/attendances/";
          if (!netCont.isDeviceConnected.value) {
            var action = "Submit";
            if (attendance_taken.value) {
              action = "Update";
            }
            var name = "$action Attendance Stream @stream on @date#"
                .interpolate(att_data);
            OfflineHttpCall offlineHttpCall = OfflineHttpCall(
                name: name,
                httpMethod: "POST",
                urlPath: url,
                formData: att_data,
                storageContainer: offline_attendance_storage);
            offlnCont.saveOfflineCache(offlineHttpCall,
                taskPrefix: myform_work_manager_tasks_prefix);

            attendance_taken.value = true;
            var key = getDateKey(att_data["stream"], att_data["date"]);
            var profile = await authCont.getProfile();
            data = {...data, ...?profile};
            await box.write(key, att_data);
            Get.toNamed(DailyAttendanceOverview.routeName, arguments: data);
            return;
          }

          try {
            isLoading.value = true;
            var res = await authProv.formPost(url, att_data);
            isLoading.value = false;
            if (res.statusCode == 201) {
              dprint("Attendance taking");
              // dprint(res);
              attendance_taken.value = true;
              var key = getDateKey(att_data["stream"], att_data["date"]);
              var profile = await authCont.getProfile();
              data = {...data, ...?profile};
              await box.write(key, res.body);
              await myschoolCont.updateLastDataSyncAttendance();
              Get.snackbar(
                'Mark Attendance',
                'Attendance submitted successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.toNamed(DailyAttendanceOverview.routeName, arguments: data);
              mixpanelTrackEvent('attendance_marked');
            } else {
              dprint("Failed to take attendance");
            }
            dprint(res.statusCode);
            dprint(res.body);
          } catch (e) {
            isLoading.value = false;
            dprint("Faueld to send");
            dprint(e);
          }
        },
        onCancel: () {},
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextView(
              style: Get.theme.textTheme.labelMedium,
              display_message:
                  "Take attendance for class @class_name with @present learners present and @absent learners absent on @date#."
                      .ctr,
              data: data,
            )
          ],
        ),
        radius: 10.0);
    dprint("Take attendanc");
  }

  getDateKey(String stream_id, String date) {
    return "att${stream_id}_${date}".replaceAll("-", "_");
  }

  setStatus(student, status) {
    dprint(" Stream ${classCont.selectedClass.value?['id']} $stream ");
    var id = student["id"];
    var isPreset = present.value.contains(id);
    // dprint(student);
    // dprint(status);
    if (status) {
      if (!isPreset) {
        present.add(id);
      }
    } else {
      if (isPreset) {
        present.remove(id);
      }
    }
  }

  getLocalStorage() {}

  changeStream(dynamic stream) {}

  getAttendance(String stream_id, DateTime att_date) async {
    dprint("Getting attendance");
    present.value = [];
    if (stream.value != stream_id) {
      stream.value = stream_id;
    }
    attendance_date.value = att_date;
    var date = DateFormat("yyyy-MM-dd").format(att_date);

    var key = getDateKey(stream_id, date);
    dprint("Attendance $key");
    var previous_attendance = await box.read(key);
    attendance_taken.value = previous_attendance != null;
    if (previous_attendance != null) {
      present.value = previous_attendance["present"];
    }
    dprint("Attendance taken $attendance_taken");
  }
}
