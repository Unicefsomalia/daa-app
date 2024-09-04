import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/offline_http_cache/offline_http_cache.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moe_som_app/my_school/my_school_controller.dart';

import '../shared/utils/utils.dart';

class OfflineAttendanceController extends SuperController {
  RxList<OfflineHttpCall> ofllineStudentsData = RxList.empty();
  RxList<OfflineHttpCall> ofllineAttendanceData = RxList.empty();

  Rx<DateTime?> lastSyncAttendance = Rx(null);
  Rx<DateTime?> lastSyncEnrolment = Rx(null);

  var schoolBox = GetStorage(school_info_storage_container);
  var offlineAttendanceBox = GetStorage(offline_attendance_storage);
  var offlineStudentsBox = GetStorage(offline_student_storage);

  var offlineCont = Get.find<OfflineHttpCacheController>();
  var mySchoolCont = Get.find<MySchoolController>();

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  getAllOfflineData() async {
    dprint("Offline status changed...");
    // dprint("The offline keys are");
    // dprint(await offlineCont.getOfflineKeys(offline_student_storage));
    ofllineStudentsData.value =
        await offlineCont.getOfflineCaches(offline_student_storage);
    ofllineAttendanceData.value =
        await offlineCont.getOfflineCaches(offline_attendance_storage);

    var box = GetStorage(offline_attendance_storage);
    dprint(await box.getKeys());
    getOfflineLastSync();
  }

  getOfflineLastSync() async {
    lastSyncAttendance.value = await mySchoolCont.getLastDataSyncAttendance();
    lastSyncEnrolment.value = await mySchoolCont.getLastDataSyncEnrolment();
    // dprint(lastSyncAttendance);
    // dprint(lastSyncEnrolment);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllOfflineData();
    offlineAttendanceBox.listen(getAllOfflineData);
    offlineStudentsBox.listen(getAllOfflineData);
    schoolBox.listen(getAllOfflineData);
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

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
