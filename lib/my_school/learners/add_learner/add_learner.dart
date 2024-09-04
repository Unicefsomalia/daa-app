import 'package:flutter/material.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/add_item_base.dart';
import '../../../shared/widgets/class_selector_scaffold_base/class_selector_controller.dart';
import '../../my_school_controller.dart';
import './options.dart';
import 'add_learner_guardian.dart';

class AddLeaner extends StatelessWidget {
  static const routeName = "/add-leaner";
  const AddLeaner({super.key});

  @override
  Widget build(BuildContext context) {
    var instance = Get.arguments?["instance"];
    var offline_key = Get.arguments?["offline_key"];
    OfflineHttpCall? offline_item = Get.arguments?["offline_item"];
    List<String> spec = [];
    List<FormChoice> specialNeedsDetails = [];
    var classSelectorController = Get.find<ClassSelectorController>();

    dprint(instance);
    if (instance?["special_needs"] != null) {
      var specialNeeeds = instance?["special_needs"] as List<dynamic>;
      if (specialNeeeds.isEmpty) {
        instance["special_needs"] = spec;
      } else {
        spec = specialNeeeds.map((e) => e.toString()).toList();
        if (instance?["special_needs_details"] != null) {
          for (var special in instance?["special_needs_details"]) {
            specialNeedsDetails.add(
              FormChoice(
                display_name: "${special['name']}".ctr,
                value: special['id'],
              ),
            );
          }
        } else {
          instance["special_needs"] = [];
          spec = [];
          // for (var special in instance?["special_needs"]) {
          //   specialNeedsDetails.add(
          //     FormChoice(
          //       display_name:
          //           "Special need Id @id#".ctr.interpolate({"id": special}),
          //       value: special,
          //     ),
          //   );
          // }
        }

        instance["special_needs"] = spec;
        if (specialNeedsDetails.isNotEmpty) {
          instance["multifield"] = {"special_needs": specialNeedsDetails};
        }
      }
    }
    instance ??= {"stream": classSelectorController.selectedId};

    return AddItemBase(
      key: const Key("add-learner"),
      options: studentsOptions,
      title: Text(
        "Learner Details".ctr,
        style: Get.theme.textTheme.bodyLarge,
      ),
      formTitle: 'Learner Details Form',
      url: "api/v1/students/",
      PreSaveData: (formData) {
        if (formData?["date_of_birth"] != null) {
          formData["date_of_birth"] =
              DateFormat("yyyy-MM-dd").format(formData["date_of_birth"]);
        }
        if (formData?["date_enrolled"] != null) {
          formData["date_enrolled"] =
              DateFormat("yyyy-MM-dd").format(formData["date_enrolled"]);
        }
        dprint("New dTa format");
        dprint(formData["date_enrolled"]);

        if (formData?["middle_name"] != null) {
          formData['father_name'] = formData['middle_name'];
        }

        if (formData?["special_needs"] == null) {
          formData['special_needs'] = [];
        }

        return formData;
      },
      instance: instance,
      submitButtonText: "Learner",
      isValidateOnly: false,
      getOfflineName: (data) {
        if (offline_key != null) {
          dprint("Found Key $offline_key");
          return offline_key;
        }
        String name =
            "learner @first_name @middle_name @last_name#".interpolate(data);
        var action_title = instance == null ? "Add $name" : "Update $name";
        return action_title;
      },
      onOfflineSuccess: (data) async {
        Get.back();
        Get.snackbar("Saved Offline", "Record saved offline");
      },
      onSuccess: (value) async {
        // dprint("On SUccess");
        // dprint(value);
        // var instance = Get.arguments?["instance"];
        // dprint("Going to guardin");

        // Get.toNamed(AddLearnerGuardianPage.routeName, arguments: {
        //   "instance": instance,
        //   "extra_fields": value,
        // });
        dprint("On SUccess");
        if (offline_item != null) {
          // Delete it from local cache
          var box = GetStorage(offline_item.storageContainer);
          await box.remove(offline_item.id);
        }
        dprint(value);

        try {
          MySchoolController mySchoolController =
              Get.find<MySchoolController>();

          await mySchoolController.updateClassList();
        } catch (e) {
          dprint(e);
        }
        Get.back();
      },
      formGroupOrder: const [
        ['first_name'],
        ['middle_name'],
        ['last_name'],
        ['family_nick_name'],
        ['father_status'],
        ['father_phone'],
        ['mother_name'],
        ['mother_status'],
        ['mother_phone'],
        ['live_with_parent'],
        ['guardian_name'],
        ['guardian_phone'],
        ['guardian_relationship'],
        ['admission_no'],
        ['status'],
        ['gender'],
        ['stream'],
        ['date_of_birth'],
        ['date_enrolled'],
        ['is_over_age'],
        ['has_special_needs'],
        ['special_needs'],
        ['pre_primary_attendend'],
        ['state'],
        ['region'],
        ['district'],
        ['village'],
        ['street_name'],
        ['house_number']
      ],
    );
  }
}
