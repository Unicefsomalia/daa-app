import 'package:flutter/material.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../shared/utils/utils.dart';
import '../offline_status_controller.dart';

class OfflineMenuList extends StatelessWidget {
  final List<MyOfflineTile> items;

  const OfflineMenuList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    OfflineAttendanceController offlineController =
        Get.find<OfflineAttendanceController>();

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
              if (tile.trailingBuilder != null && tile.child != null) {
                throw "Only include one, `childBuilder` or `child` not both";
              }

              if (tile.child != null) {
                return tile.child as Widget;
              }
              return ListTile(
                title: Text(
                  tile.label.ctr,
                  style: Get.theme.textTheme.titleSmall,
                ),
                trailing: Card(
                  color: tile.trailingBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: tile.trailingBuilder != null
                        ? tile.trailingBuilder!(
                            context, tile, offlineController)
                        : Text(
                            tile.trailingLabel,
                            style: Get.theme.textTheme.titleSmall?.copyWith(
                              color: tile.trailingColor,
                            ),
                          ),
                  ),
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
