import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';

import '../../my_school_controller.dart';
import 'options.dart';

class ReactivateLearner extends StatelessWidget {
  Map<String, dynamic> arguments;
  ReactivateLearner({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    var instance = arguments["instance"];

    var url = "api/v1/students/${instance['id']}/reactivate";
    dprint(url);

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
            ),
            child: TextView(
              display_message: "@full_name#",
              data: instance,
              style: Get.theme.textTheme.titleLarge,
            ),
          ),
          MyCustomForm(
            key: key,
            formItems: reactivateLearnerOptions,
            onStatus: (FormStatus status) {},
            storageContainer: 'school',
            // isValidateOnly: true,
            status: FormStatus.Update,
            contentType: ContentType.json,
            // PreSaveData: PreSaveData,
            // instance: instance,
            url: url,
            // formHeader: Text("Welcome home"),
            PreSaveData: (formData) {
              formData["stream"] = "${formData['stream']}";
              return formData;
            },
            onSuccess: (val) async {
              dprint(val);

              try {
                MySchoolController mySchoolController =
                    Get.find<MySchoolController>();

                await mySchoolController.updateClassList();

                Get.back();
              } catch (e) {
                dprint(e);
              }
            },
            submitButtonPreText: "",
            submitButtonText: "Reactivate",
            // extraFields: const {"active": true},
            // extraFields: {...?extra_fields, ...?extraFields},
            // isValidateOnly: isValidateOnly,
            formGroupOrder: const [
              ['stream'],
              ['reason'],
            ],
            name: "reactivateLearner",
            formTitle:
                "Previously in Class @class_name#".ctr.interpolate(instance),
          ),
        ],
      ),
    );
  }
}
