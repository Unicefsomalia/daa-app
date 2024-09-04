import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:flutter_utils/extensions/date_extensions.dart';
import '../../shared/utils/utils.dart';
import '../offline_status_controller.dart';
import 'offline_enrolment_menu.dart';

class OfflineEnrolmentList extends StatelessWidget {
  OfflineEnrolmentList({Key? key}) : super(key: key);

  AuthController authController = Get.find<AuthController>();
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
        trailingBuilder:
            (context, tile, OfflineAttendanceController offAttCont) {
          return Obx(() {
            int offlinceCount = offAttCont.ofllineStudentsData.value.length;
            var title = offlinceCount.toString();
            return Text(
              title,
              style: Get.theme.textTheme.titleSmall?.copyWith(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OfflineMenuList(items: iconList),
      ],
    );
  }
}
