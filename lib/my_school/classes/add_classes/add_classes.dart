import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/add_item_base.dart';
import '../../my_school_controller.dart';
import './options.dart';

class AddClasses extends StatelessWidget {
  static const routeName = "/add-classes";
  const AddClasses({super.key});

  @override
  Widget build(BuildContext context) {
    MySchoolController mySchoolController = Get.find<MySchoolController>();

    var extraFields = {
      "school": mySchoolController.schoolOverview.value?['school'],
    };
    var instance = Get.arguments?["instance"];
    // dprint("Got from instance $instance");
    return AddItemBase(
      key: Key("add-classes"),
      options: classesOptions,
      extraFields: extraFields,
      enableOfflineMode: false,
      title: Text(
        "Add Class".ctr,
        style: Get.theme.textTheme.bodyLarge,
      ),
      instance: instance,
      formTitle: 'Add Class Form',
      isValidateOnly: false,
      submitButtonText: "Class",
      url: "api/v1/streams/",
      PreSaveData: (formData) {
        if (formData.containsKey("name")) {
          var name = formData?["name"] as String?;
          if (name == null || name.isEmpty) {
            formData["name"] = "";
          }
        }
        return formData;
      },
      onSuccess: (value) async {
        dprint("On SUccess");
        // dprint(value);
        try {
          await mySchoolController.updateClassList();
        } catch (e) {
          dprint(e);
        }
        Get.back();
      },
      formGroupOrder: const [
        ['base_class'],
        ['name'],
      ],
    );
  }
}
