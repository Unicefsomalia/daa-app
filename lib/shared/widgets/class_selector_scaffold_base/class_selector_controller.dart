import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../my_school/my_school_controller.dart';
import '../../utils/utils.dart';

class ClassSelectorController extends SuperController {
  final box = GetStorage("school");
  Rx<dynamic?> selectedClass = Rx(null);
  int? selectedId;
  var students = [].obs;
  var classes = [].obs;

  MySchoolController mySchoolController = Get.find<MySchoolController>();

  StreamSubscription? boxSubscription;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    dprint("MySchool vallss");
    initial();
    boxSubscription = mySchoolController.updareRequred.listen((value) {
      dprint("Listening to the updarerequired");
      initial();
    });
  }

  @override
  onClose() {
    super.onClose();
    boxSubscription?.cancel();
  }

  initial() async {
    // dprint(await box.getKeys());
    classes.value = [];
    var read_classes = await readClasses();
    if (read_classes == null) {
      return;
    }
    var index = 0;
    classes.value = read_classes;
    if (selectedId != null) {
      var selectedIndex =
          classes.map((element) => element["id"]).toList().indexOf(selectedId);
      if (selectedIndex > 0) {
        index = selectedIndex;
      }
    }

    if (classes.value.length > index) {
      selectClass(classes.value[index]);
    }
  }

  selectClass(dynamic stream) {
    selectedClass.value = stream;
    students.value = stream["students"];
    selectedId = stream["id"];
    // dprint(stream["students"][0]);
  }

  readClasses() async {
    return await box.read("classes");
  }

  bool isStreamSelected(dynamic stream) {
    if (selectedClass.value == null) return false;
    try {
      return stream["id"] == selectedId;
    } catch (e) {
      dprint(e);
      return false;
    }
  }

  openClassesModal() async {
    await readClasses();
    var bottomSheetWidget = Card(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            SizedBox(
              height: 20,
            ),
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Classes".ctr,
                style: Get.theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (contex, index) {
                var stream = classes[index];
                var isSelected = isStreamSelected(stream);
                // dprint("IS selected $isSelected");
                return getStreamTile(stream, selectClass, isSelected);
              },
              separatorBuilder: (contex, index) {
                return divider;
              },
              itemCount: classes.length,
            )
          ],
        ),
      ),
    );
    var res = await Get.bottomSheet(bottomSheetWidget);
    dprint(res);
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
    initial();
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
