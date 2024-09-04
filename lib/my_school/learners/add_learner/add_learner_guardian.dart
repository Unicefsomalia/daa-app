import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moe_som_app/my_school/learners/add_learner/options.dart';
import 'package:moe_som_app/my_school/my_school_controller.dart';

import '../../../shared/widgets/add_item_base.dart';

class AddLearnerGuardianPage extends StatelessWidget {
  static const routeName = "/add-guardian";

  const AddLearnerGuardianPage({super.key});

  @override
  Widget build(BuildContext context) {
    var instance = Get.arguments?["instance"];
    var extra_fields = Get.arguments?["extra_fields"];
    // dprint(instance);
    return AddItemBase(
      key: Key("add-learner-guardin"),
      options: studentsOptions,
      extraFields: extra_fields,
      instance: instance,
      title: Text(
        "Parent Details",
        style: Get.theme.textTheme.bodyLarge,
      ),
      formTitle: 'Parent Details Form',
      getOfflineName: (data) {
        var extra_fields = Get.arguments?["extra_fields"];
        var instance = Get.arguments?["instance"];
        dprint(extra_fields);
        dprint(instance);
        String name = "learner @first_name @middle_name @last_name#"
            .interpolate(extra_fields);
        var action = instance == null ? "Add $name" : "Update $name";
        return action;
      },
      submitButtonText: "Learner",
      onOfflineSuccess: (data) async {
        Get.back();
        Get.back();
        Get.snackbar("Saved Offline", "Record saved offline");
      },
      // submitButtonPreText: "",
      // isValidateOnly: true,
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

        return formData;
      },

      onSuccess: (value) async {
        dprint("On SUccess");
        dprint(value);

        try {
          MySchoolController mySchoolController =
              Get.find<MySchoolController>();

          await mySchoolController.updateClassList();
        } catch (e) {
          dprint(e);
        }
        Get.back();
        Get.back();
      },
      formGroupOrder: const [
        ['father_name'],
        ['father_phone'],
        ['father_status'],
        ['mother_name'],
        ['mother_status'],
        ['mother_phone'],
        ['live_with_parent'],
        ['guardian_name'],
        ['guardian_phone'],
        ['guardian_relationship']
      ],
    );
    ;
  }
}
