import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';
import '../shared/utils/utils.dart';

const v1 = "api/v1";

const Map offlineAvailableItems = {
  "states": "$v1/states/",
  "regions": "$v1/regions/",
  "districts": "$v1/districts/",
  "villages": "$v1/villages/",
  "support_questions": "$v1/support-questions/",
  "special_needs": "$v1/special-needs/",
};

class MySchoolController extends SuperController {
  AuthProvider authProv = Get.put<AuthProvider>(AuthProvider());

  final bool listenToBackground;

  MySchoolController({this.listenToBackground = false});

  final box = GetStorage("school");
  Rx<Map<String, dynamic>?> schoolOverview = Rx(null);

  StreamSubscription<dynamic>? backgroundSub;
  var updareRequred = false.obs;

  @override
  void onInit() {
    super.onInit();
    initialGet();
    if (listenToBackground) {
      listenToBackgroundChanges();
    } else {
      dprint("Not listening to background");
    }
  }

  @override
  void onClose() {
    backgroundSub?.cancel();
    super.onClose();
  }

  listenToBackgroundChanges() {
    dprint("Listening to background");

    ReceivePort receivePort = Get.find<ReceivePort>();

    backgroundSub = receivePort.listen((message) async {
      try {
        dprint(message);

        dprint("Main Offline sync is done");
        dprint("Reinitialize db");
        var keysMpa = List<Map<String, dynamic>>.from(json.decode(message));

        for (var element in keysMpa) {
          try {
            var box = GetStorage(element.keys.first);
            await box.remove(element.values.first);
          } catch (e, trace) {
            dprint(e);
            dprint(trace);
          }
        }
        var mySchoolCont = Get.find<MySchoolController>();
        await mySchoolCont.updateClassList();
      } catch (e, trace) {
        dprint(e);
        dprint(trace);
      }
    });
  }

  initialGet() async {
    // dprint(await box.getKeys());
    try {
      // dprint("getting overview");
      var overview = await box.read("overview");
      schoolOverview.value = new Map<String, dynamic>.from(overview);
    } catch (er) {
      dprint(er);
    }
    // dprint(schoolOverview.value);
  }

  getOfflineCacheItem() async {
    for (var i = 0; i < offlineAvailableItems.keys.length; i++) {
      var name = offlineAvailableItems.keys.toList()[i];
      var path = offlineAvailableItems[name];
      var items = await getItemFromApi(path);
      // dprint(items);
      // if (name == "states") {
      //   dprint(items);
      // }
      if (items != null) {
        await box.write(name, items);
        dprint("Saved $name");
      }
    }
    dprint("Notifiy people");
    updareRequred.toggle();
  }

  Future<dynamic?> getItemFromApi(path) async {
    try {
      var res = await authProv.formGet(path);
      if (res.statusCode == 200) {
        try {
          return res.body["results"];
        } catch (e) {
          return res.body;
        }
      } else {
        dprint(res.statusCode);
        dprint(res.body);
      }
    } catch (e) {
      dprint("Failed");
      dprint(e);
    }

    dprint("Returning nothing..");
    return null;
  }

  updateOverviewStreams() async {
    List<dynamic> streams = await box.read("classes");
    streams = streams.map((e) {
      e["males"] = e["students"].where((st) => st["gender"] == "M").length;
      e["females"] = e["students"].where((st) => st["gender"] == "F").length;
      e["total"] = e["students"].length;
      dprint("NMales ${e['males']} females ${e['females']}");
      return e;
    }).toList();

    // TODO: Sort the classes
    // streams.sort((a,b)=>a["base_class"])
    var total_males = streams
        .map((element) => element["males"])
        .reduce((value, element) => element + value);

    var total_females = streams
        .map((element) => element["females"])
        .reduce((value, element) => element + value);
    var total_learners = streams
        .map((element) => element["total"])
        .reduce((value, element) => element + value);

    dprint("$total_males + $total_females = $total_learners ");
    var overview = await box.read("overview");
    var schoolOverview = {
      ...overview,
      "classes": streams.length,
      "males": total_males,
      "females": total_females,
      "total": total_females + total_males,
    };

    await box.write("overview", schoolOverview);
    await box.write("classes", streams);

    for (int i = 0; i < streams.length; i++) {
      var stream = streams[i];
      var id = "stream_${stream['id']}";
      await box.write(id, stream);
    }

    initialGet();
  }

  var isUpdatinClassList = false.obs;
  updateClassList() async {
    try {
      isUpdatinClassList.value = true;
      dprint("Getting class list");
      var url = "api/v1/users/teacher/school-info/";
      var res = await authProv.formGet(url);
      if (res.statusCode != 200) {
        dprint("Failed");
        dprint(res.statusCode);
        return;
      }
      await box.erase();

      dprint("Cleared stoage");
      // dprint(await box.getKeys());
      var body = res.body;
      var teachers = res.body["teachers"];
      await box.write("teachers", teachers);
      await box.write("classes", res.body["streams"]);
      var schoolOverview = {
        "school_name": body["school_name"],
        "school": body["school"],
        "teachers": teachers.length,
        "classes": 0,
        "males": 0,
        "females": 0,
        "total": 0,
      };
      // dprint("Saving ");
      // dprint(schoolOverview);
      await box.write("overview", schoolOverview);
      await updateOverviewStreams();
      // dprint(await box.getKeys());
    } catch (e) {
      dprint(e);
    }
    await getOfflineCacheItem();
    isUpdatinClassList.value = false;

    // Update last sync

    await updateLastDataSyncEnrollment();
  }

  updateLastDataSyncAttendance() async {
    var offlineBox = GetStorage(school_info_storage_container);
    dprint("Saving attendance last sync data");
    await offlineBox.write(last_sync_attendance_key, DateTime.now().toString());
  }

  updateLastDataSyncEnrollment() async {
    var offlineBox = GetStorage(school_info_storage_container);
    await offlineBox.write(last_sync_enrolment_key, DateTime.now().toString());
  }

  getLastDataSyncAttendance() async {
    var offlineBox = GetStorage(school_info_storage_container);
    var value = await offlineBox.read(last_sync_attendance_key);
    if (value == null) {
      return null;
    }
    return DateTime.parse(value);
  }

  getLastDataSyncEnrolment() async {
    var offlineBox = GetStorage(school_info_storage_container);
    var value = await offlineBox.read(last_sync_enrolment_key);
    if (value == null) {
      return null;
    }
    return DateTime.parse(value);
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
