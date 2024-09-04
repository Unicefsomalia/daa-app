import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_tables/flutter_tables.dart';
import 'package:flutter_tables/tables_controller.dart';
import 'package:flutter_tables/tables_models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badges;
import 'package:moe_som_app/my_school/classes/view_class.dart';
import 'package:moe_som_app/my_school/my_school_controller.dart';
import 'package:moe_som_app/navigation/navigation.dart';
import '../../shared/utils/utils.dart';
import '../../shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import '../../shared/widgets/my_school_menu.dart';
import '../../theme/dark_theme/dark_theme.dart';
import 'add_classes/add_classes.dart';
import 'classes_controller.dart';

// ignore: must_be_immutable
class ClassesList extends StatelessWidget {
  static const routeName = "/classes-list";
  const ClassesList({super.key});

  @override
  Widget build(BuildContext context) {
    // return SchoolMenuList(items: iconList);
    AuthController authController = Get.find<AuthController>();
    ClassesListController classesCont = Get.put(ClassesListController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Text(
          "Classes".ctr,
          style: Get.theme.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                var index = 0;
                var items = classesCont.classes.value;
                // dprint("FOund ${items.length} classes");
                var date_str = DateTime.now().toIso8601String();
                TableController? controller;
                return Column(
                  children: [
                    MyTable(
                      enableDelete: true,
                      enableEdit: true,
                      showCount: false,
                      pageSize: 3,
                      deleteMessageTemplate:
                          "Are you sure you want to delete class @class_name# ?"
                              .ctr,
                      onControllerSetup: (cont) {
                        controller = cont;
                      },
                      type: MyTableType.list,
                      // transformRow: (Map<String, dynamic> value) {
                      //   if (value.containsKey("created")) {
                      //     dprint("value");
                      //     value["created"] = value["created"].split("T")[0];
                      //   }
                      //   return value;
                      // },
                      data: items,
                      options: ListViewOptions(
                        shrinkWrap: true,
                        // itemPadding: EdgeInsets.zero,

                        imageField: "image",
                        physics: const NeverScrollableScrollPhysics(),
                        separator: divider,
                      ),
                      onItemDelete: (item) async {
                        var mySchCont = Get.find<MySchoolController>();
                        await mySchCont.updateClassList();
                      },

                      itemBuilder: (context, item, options) {
                        var stream = item;
                        index = index + 1;
                        // dprint(stream["id"]);
                        return ListTile(
                          onTap: () {
                            Get.bottomSheet(
                              SingleChildScrollView(
                                child: ViewClassWidget(
                                  stream: stream,
                                ),
                              ),
                            );
                          },
                          leading: badges.Badge(
                              badgeStyle: const badges.BadgeStyle(
                                badgeColor: Color(0xFF00AEEE),
                                padding: EdgeInsets.all(8),
                              ),
                              badgeContent: Text(
                                index.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )),
                          title: Text(
                            'Class @class_name#'.ctr.interpolate(stream),
                            style: Get.theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            "Boys @males# \nGirls @females#"
                                .ctr
                                .interpolate(stream),
                            style: Get.theme.textTheme.titleSmall,
                          ),
                          trailing: Wrap(
                            spacing: 30,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Get.toNamed(AddClasses.routeName, arguments: {
                                    "instance": item,
                                    "options": options
                                  });
                                },
                                icon: const Icon(
                                  Iconsax.edit,
                                  size: 22.0,
                                  color: Color(0xFF00AEEE),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var res = await controller?.deleteItem(item);
                                  // dprint("Got $res");
                                  if (res != null) {}
                                },
                                icon: const Icon(
                                  Iconsax.profile_delete,
                                  size: 22.0,
                                  color: Color.fromARGB(255, 238, 55, 52),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      onSelect:
                          (ListViewOptions options, Map<String, dynamic> item) {
                        // dprint(item);
                      },
                      name: date_str,
                      listTypeUrl: 'api/v1/streams',
                    )
                  ],
                );
              }),
              divider,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.primaryColor,
        onPressed: () async {
          await Get.toNamed(AddClasses.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
