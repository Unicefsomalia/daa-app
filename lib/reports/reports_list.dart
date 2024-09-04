import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../shared/utils/utils.dart';

class ReportsList extends StatelessWidget {
  ReportsList({super.key});

  var iconList = [
    MySchoolTile(
        label: "Attendance Report by Class",
        iconData: Iconsax.chart_square,
        routeName: "/report-class"),
    MySchoolTile(
        label: "Attendance Report by Learner",
        iconData: Iconsax.percentage_square,
        routeName: "/report-learner"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 14,
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: iconList.length,
            itemBuilder: (context, index) {
              var tile = iconList[index];
              return ListTile(
                onTap: () {
                  mixpanelTrackEvent('${tile.routeName}_pressed');
                  Get.toNamed(tile.routeName);
                },
                leading: Icon(
                  tile.iconData,
                  size: 20.0,
                ),
                title: Text(
                  tile.label.ctr,
                  style: Get.theme.textTheme.titleMedium,
                ),
                trailing: const Icon(
                  Iconsax.arrow_right,
                  size: 20.0,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return divider;
            },
          ),
          const SizedBox(
            height: 14,
          ),
        ],
      ),
    );
  }
}
