import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/my_school/learners/deactivate_learner/options.dart';

import '../../my_school_controller.dart';

class DeactivateLearner extends StatelessWidget {
  Map<String, dynamic> arguments;
  DeactivateLearner({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    var instance = arguments["instance"];

    var url = "api/v1/students/${instance['id']}/";
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
            formItems: delereReasonOptions,
            onStatus: (FormStatus status) {},
            storageContainer: 'school',
            // isValidateOnly: true,
            status: FormStatus.Delete,
            contentType: ContentType.json,
            // PreSaveData: PreSaveData,
            instance: instance,
            url: url,
            // formHeader: Text("Welcome home"),
            PreSaveData: (form) {
              form["reason"] = "${form['reason']}";
              return form;
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
            submitButtonText: "Deactivate",
            // extraFields: const {"active": true},
            // extraFields: {...?extra_fields, ...?extraFields},
            // isValidateOnly: isValidateOnly,
            formGroupOrder: const [
              ['reason'],
              ['description'],
            ],
            name: "deactivateLearner",
            formTitle: "Deactivate",
          ),
        ],
      ),
    );
  }
}
