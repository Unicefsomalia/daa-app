import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

import '../../my_school/learners/add_learner/add_learner.dart';
import '../offline_status_controller.dart';

class OfflineSavedLearnersList extends StatelessWidget {
  static const routeName = "offline-enrollment-list";
  const OfflineSavedLearnersList({super.key});

  @override
  Widget build(BuildContext context) {
    OfflineAttendanceController offAttCont =
        Get.find<OfflineAttendanceController>();

    return Obx(() {
      return Column(
        children: [
          if (offAttCont.ofllineStudentsData.value.isNotEmpty)
            Text(
              "Offline Pending Actions",
              style: Get.textTheme.labelMedium,
            ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              OfflineHttpCall item =
                  offAttCont.ofllineStudentsData.value[index];

              return ListTile(
                title: Text(item.name),
                subtitle: TextView(
                  display_message: "Tries @tries# @urlPath#".tr,
                  data: item.toJson(),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Iconsax.edit,
                    size: 22.0,
                    color: Color(0xFF00AEEE),
                  ),
                  onPressed: () async {
                    // dprint(item.formData.runtimeType);
                    Get.toNamed(AddLeaner.routeName, arguments: {
                      "instance": item.instance,
                      "offline_key": item.name,
                      "offline_item": item,
                    });
                  },
                ),
              );
            },
            itemCount: offAttCont.ofllineStudentsData.value.length,
          ),
        ],
      );
    });
  }
}
