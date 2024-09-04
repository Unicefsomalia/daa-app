import 'package:flutter/material.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/utils.dart';

class SchoolMenuList extends StatelessWidget {
  final List<MySchoolTile> items;

  const SchoolMenuList({super.key, required this.items});

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
            itemCount: items.length,
            itemBuilder: (context, index) {
              var tile = items[index];
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
