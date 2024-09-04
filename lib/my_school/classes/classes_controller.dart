import 'dart:async';

import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../shared/utils/utils.dart';

class ClassesListController extends GetxController {
  RxList<Map<String, dynamic>> classes = RxList();

  var box = GetStorage(school_info_storage_container);
  dynamic? boxSub;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    boxSub = box.listen(() {
      dprint("value");
      getClasses();
    });
    dprint("Got $boxSub");
    getClasses();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getClasses() async {
    List<dynamic> sclasses = await box.read("classes") ?? [];
    classes.value = List<Map<String, dynamic>>.from(sclasses);
    // dprint(classes.value.first);
  }
}
