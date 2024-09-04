import 'package:flutter/material.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/extensions/date_extensions.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/add_item_base.dart';
import '../../my_school_controller.dart';
import './options.dart';

class AddTeachers extends StatelessWidget {
  static const routeName = "/add-teachers";
  const AddTeachers({super.key});

  @override
  Widget build(BuildContext context) {
    MySchoolController mySchoolController = Get.find<MySchoolController>();

    var extraFields = {
      "school": mySchoolController.schoolOverview.value?['school'],
    };
    var instance = Get.arguments?["instance"];
    // dprint("Got from instance $instance");
    // dprint(instance);
    if (instance != null) {
      List<String> streams = [];
      dprint(instance);
      List<FormChoice> streamDetails = [];

      var streams_list = instance["streams"] as List<dynamic>;
      if (streams_list.isNotEmpty) {
        streams = streams_list.map((e) => e.toString()).toList();

        for (var stream in instance?["streams_details"]) {
          streamDetails.add(
            FormChoice(
              display_name: stream["class_name"],
              value: stream['id'],
            ),
          );
        }
      }
      instance['streams'] = streams;
      instance["multifield"] = {"streams": streamDetails};

      dprint("DOne updating instancd");
    }
    return AddItemBase(
      key: Key("add-teachers"),
      options: teachersOptions,
      extraFields: extraFields,
      enableOfflineMode: false,
      title: Text(
        "Add Teachers".ctr,
        style: Get.theme.textTheme.bodyLarge,
      ),
      instance: instance,
      formTitle: 'Add Teacher Form',
      submitButtonText: "Teacher",
      // submitButtonPreText: "",
      isValidateOnly: false,
      url: "api/v1/teachers/",
      onSuccess: (value) async {
        dprint("On Success");
        // dprint(value);
        try {
          await mySchoolController.updateClassList();
        } catch (e) {
          dprint(e);
        }
        Get.back();
      },
      PreSaveData: (formData) {
        if (formData?['dob'] != null) {
          formData["dob"] = (formData["dob"] as DateTime)?.toAPIDate;
        }
        // dprint("Pewsaeve $formData");
        return formData;
      },
      formGroupOrder: const [
        ['first_name'],
        ['middle_name'],
        ['last_name'],
        ['phone'],
        ['type'],
        ['employment_id'],
        ['employed_by'],
        ['email'],
        ['dob'],
        ['is_school_admin'],
        ['streams']
      ],
    );
  }
}
