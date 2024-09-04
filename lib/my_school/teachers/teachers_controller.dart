import 'dart:async';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../shared/utils/utils.dart';

class TeachersListController extends GetxController {
  RxList<Map<String, dynamic>> teachers = RxList();

  var box = GetStorage(school_info_storage_container);
  dynamic? boxSub;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    boxSub = box.listen(() {
      dprint("value");
      getTeachers();
    });
    dprint("Got $boxSub");
    getTeachers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getTeachers() async {
    List<dynamic> steachers = await box.read("teachers");
    teachers.value = List<Map<String, dynamic>>.from(steachers);
    // dprint(teachers.value.first);
  }
}
