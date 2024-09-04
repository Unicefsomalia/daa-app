import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/shared/utils/utils.dart';

import '../../../shared/widgets/class_selector_scaffold_base/class_selector_with_date_base_controller.dart';
import '../../my_school_controller.dart';

class MoveLearnersController extends ListClassListWithDateBase {
  Rx<dynamic?> toStream = Rx(null);
  var isLoading = false.obs;
  @override
  onDateClassChange() {
    super.onDateClassChange();
    // TODO: implement onDateClassChange
    dprint("Date of class changed");
    dprint("$attendance_date $stream");
    // dprint(classCont.classes);
  }

  checkIsSelected(dynamic stream) {
    return stream["id"] == toStream.value;
  }

  setStatus(student, status) {
    super.setStatus(student, status);
    dprint("Changed");
  }

  selectClassToMove() async {
    dprint("From class $stream");
    var filteredClasses =
        classCont.classes.where((st) => st["id"] != stream.value).toList();

    dprint(filteredClasses.map((e) => e["id"]));
    var classSelector = GetBuilder<MoveLearnersController>(
        builder: (_) => Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextView(
                          display_message: "Move Learners to class ",
                          style: Get.theme.textTheme.titleLarge,
                          data: {"totals": students.value.length},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  if (students.value.length < 1)
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: Center(
                          child: TextView(
                              style: Get.textTheme.titleMedium
                                  ?.copyWith(color: Colors.white54),
                              display_message:
                                  "Select at least one student to move")),
                    ),
                  if (students.value.length > 0)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          var stream = filteredClasses[index];
                          var isSelected = toStream.value == stream["id"];
                          return getStreamTile(
                              stream, toStreamSelected, isSelected,
                              close: false);
                        },
                        separatorBuilder: (context, index) {
                          return divider;
                        },
                        itemCount: filteredClasses.length,
                      ),
                    ),
                  if (students.value.length > 0)
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (toStream.value == null)
                            TextView(
                              display_message: "Select a class above",
                              style: Get.textTheme.titleSmall,
                            ),
                          if (toStream.value != null)
                            ElevatedButton(
                                onPressed: isLoading.value
                                    ? null
                                    : () {
                                        moveLearners();
                                      },
                                child: Text(isLoading.value
                                    ? "Moving learners..."
                                    : "Move Learners"))
                        ],
                      ),
                    ),
                ],
              ),
            ));
    var res = await Get.bottomSheet(classSelector);
    dprint("$res");
  }

  toStreamSelected(dynamic selectedStream) {
    var id = selectedStream["id"];
    if (id != toStream.value) {
      toStream.value = id;
      dprint("Class changed to ${toStream.value}");
    }
    update();
  }

  selectClassToMoveTo() {}

  moveLearners() async {
    dprint("Moveing  to class $stream");
    dprint(students);
    var allstudents = classCont.selectedClass.value["students"];
    var learners_to_update =
        allstudents.where((st) => students.value.contains(st["id"])).map((st) {
      st["stream"] = toStream.value;
      return st;
    }).toList();
    // dprint(learners_to_update);

    try {
      isLoading.value = true;
      update();
      var res = await authProv.formPatch(
          "api/v1/students/bulk", learners_to_update,
          shouldRemoveNullFields: false);

      if (res.statusCode == 200) {
        dprint(res.body);
        MySchoolController mySchoolController = Get.find<MySchoolController>();
        await mySchoolController.updateClassList();

        isLoading.value = false;
        update();
        Get.back();
      } else {
        Get.snackbar("Failed", "An error occured, try again later.");
      }
    } catch (e) {
      isLoading.value = false;
      update();
      Get.snackbar("Failed", "An error occured, try again later.");
    }
  }
}
