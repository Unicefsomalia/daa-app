import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';

import '../../theme/dark_theme/dark_theme.dart';

class AddItemBase extends StatelessWidget {
  final dynamic options;
  Widget title;
  String formTitle;
  String? url;
  String? submitButtonText;
  String? submitButtonPreText;
  List<List<String>> formGroupOrder;
  Function? PreSaveData;
  Function(dynamic data)? getOfflineName;
  Map<String, dynamic>? instance;

  Function(dynamic value)? onSuccess;
  Function(dynamic value)? onOfflineSuccess;
  Map<String, dynamic>? extraFields;
  bool isValidateOnly;
  bool enableOfflineMode;

  AddItemBase({
    super.key,
    required this.options,
    required this.title,
    this.submitButtonText,
    this.url,
    this.instance,
    this.onOfflineSuccess,
    this.submitButtonPreText,
    this.PreSaveData,
    this.getOfflineName,
    this.enableOfflineMode = true,
    this.extraFields,
    this.formGroupOrder = const [],
    this.isValidateOnly = false,
    required this.formTitle,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    // var instance = Get.arguments?["instance"];
    // var extra_fields = Get.arguments?["extra_fields"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: title,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: MyCustomForm(
                key: key,

                formItems: options,
                getOfflineName: getOfflineName,
                enableOfflineSave: true,
                enableOfflineMode: enableOfflineMode,
                offlineStorageContainer: "offlineStudent",
                onStatus: (FormStatus status) {},
                instance: instance,
                onOfflineSuccess: onOfflineSuccess,
                storageContainer: 'school',
                contentType: ContentType.json,
                PreSaveData: PreSaveData,
                // formHeader: Text("Welcome home"),
                url: url, //"api/v1/students/",
                // onSuccess: (value) {
                //   dprint("On SUccess");
                //   dprint(value);
                //   Get.back(result: value);
                // },
                onSuccess: onSuccess,
                submitButtonPreText: submitButtonPreText,
                submitButtonText: submitButtonText ?? formTitle,
                // extraFields: const {"active": true},
                extraFields: {...?extraFields},
                isValidateOnly: isValidateOnly,
                formGroupOrder: formGroupOrder,
                // formTitle: "",
                name: formTitle,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
