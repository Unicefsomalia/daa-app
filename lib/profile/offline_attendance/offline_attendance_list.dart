import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:moe_som_app/profile/offline_status_controller.dart';
import '../../shared/utils/utils.dart';
import '../offline_enrolment/offline_enrolment_menu.dart';
import 'package:flutter_utils/extensions/date_extensions.dart';

var iconList = [
  MyOfflineTile(
    label: "Internet Status",
    trailingLabel: "Connected",
    trailingBackgroundColor: const Color(0xFF33E45A),
    trailingColor: Colors.black,
    child: NetworkStatusWidget(),
  ),
  MyOfflineTile(
    label: "Last Upload Date",
    trailingLabel: "Monday, 27 Feb 2023 8:20 PM",
    trailingBackgroundColor: Get.theme.primaryColor,
    trailingColor: Colors.white,
    trailingBuilder: (context, tile, OfflineAttendanceController offAttCont) {
      return Obx(() {
        return Text(
          offAttCont.lastSyncEnrolment.value?.toWeekDayDate ?? "",
          style: Get.theme.textTheme.titleSmall?.copyWith(
            color: tile.trailingColor,
          ),
        );
      });
    },
  ),
  MyOfflineTile(
      label: "Records Saved Offline",
      trailingLabel: "0",
      trailingBackgroundColor: const Color(0xFF33E45A),
      trailingColor: Colors.black,
      trailingBuilder: (context, tile, offAttCont) {
        return Obx(() {
          int offlinceCount = offAttCont.ofllineAttendanceData.value.length;
          var title = offlinceCount.toString();
          return Text(
            title,
            style: Get.theme.textTheme.titleSmall?.copyWith(
              fontSize: 13,
              color: tile.trailingColor,
            ),
          );
        });
      }),
  MyOfflineTile(
    label: "Items Failed To Upload",
    trailingLabel: "0",
    trailingBackgroundColor: const Color.fromARGB(206, 255, 71, 71),
    trailingColor: Colors.white,
  ),
  // MyOfflineTile(
  //   label: "Size of Data Stored Offline",
  //   trailingLabel: "0 MB",
  //   trailingBackgroundColor: const Color(0xFF33E45A),
  //   trailingColor: Colors.black,
  // )
];

class OfflineAttendanceList extends StatelessWidget {
  const OfflineAttendanceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    OfflineAttendanceController offAttCont =
        Get.find<OfflineAttendanceController>();

    return Column(
      children: [
        OfflineMenuList(items: iconList),
        Obx(() {
          return Column(
            children: [
              if (offAttCont.ofllineAttendanceData.value.isNotEmpty)
                Text(
                  "Offline Pending Actions",
                  style: Get.textTheme.labelMedium,
                ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  OfflineHttpCall item =
                      offAttCont.ofllineAttendanceData.value[index];
                  // item.name
                  // item.formData
                  // item.tries
                  return ListTile(
                    title: Text(item.name),
                    subtitle: TextView(
                      display_message: "@urlPath#",
                      data: item.toJson(),
                    ),
                    trailing: Text(item.tries.toString()),
                  );
                },
                itemCount: offAttCont.ofllineAttendanceData.value.length,
              ),
            ],
          );
        }),
      ],
    );
  }
}
