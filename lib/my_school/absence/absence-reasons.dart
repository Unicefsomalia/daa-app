import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'absence_controller.dart';
import 'options.dart';

class AbsenceReasons extends StatelessWidget {
  Map<String, dynamic> arguments;
  AbsenceReasons({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    var instance = arguments["instance"];
    // dprint(instance);
    var absent_cont = Get.find<AbsenceListController>();
    var extra_fields = {
      "student": instance["id"],
      "date": absent_cont.getCurrentDate(),
      "class_name": absent_cont.classCont.selectedClass.value["class_name"]
    };
    dprint(absent_cont.stream);
    var reason_provided = instance["reason_absent"];
    dprint("Reason absent $reason_provided");
    // var reasonInstance;
    // if (reason_provided != null) {
    //   reasonInstance=reason_provided
    // }
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: TextView(
                display_message: "@full_name#",
                data: instance,
                style: Get.theme.textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: MyCustomForm(
                key: key,
                extraFields: extra_fields,
                formItems: AbsenceReasonOptions,
                onStatus: (FormStatus status) {},
                storageContainer: 'school',
                contentType: ContentType.json,
                // PreSaveData: PreSaveData,
                instance: reason_provided,
                url: "api/v1/attendances/student-absent-reasons/",
                // formHeader: Text("Welcome home"),
                onSuccess: (val) {
                  dprint(val);

                  Get.back();
                  absent_cont.refreshAll();
                },
                // submitButtonPreText: "",
                submitButtonText: "Reason for Absence",
                // extraFields: const {"active": true},
                // extraFields: {...?extra_fields, ...?extraFields},
                // isValidateOnly: isValidateOnly,
                formGroupOrder: const [
                  ['reason'],
                  ['description'],
                ],
                name: "AbsenceReasons",
                formTitle: "Reason for Absence in class @class_name# on @date#"
                    .ctr
                    .interpolate(extra_fields),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
