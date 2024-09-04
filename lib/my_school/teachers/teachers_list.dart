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
import 'package:moe_som_app/my_school/my_school_controller.dart';
import 'package:moe_som_app/my_school/teachers/add_teachers/add_teachers.dart';
import 'package:moe_som_app/my_school/teachers/teachers_controller.dart';
import 'package:moe_som_app/navigation/navigation.dart';
import '../../shared/utils/utils.dart';
import '../../shared/widgets/class_selector_scaffold_base/class_selector_scaffold_base.dart';
import '../../shared/widgets/my_school_menu.dart';
import '../../theme/dark_theme/dark_theme.dart';

// ignore: must_be_immutable
class TeachersList extends StatelessWidget {
  static const routeName = "/teachers-list";
  const TeachersList({super.key});

  @override
  Widget build(BuildContext context) {
    // return SchoolMenuList(items: iconList);
    AuthController authController = Get.find<AuthController>();
    TeachersListController teachersCont = Get.put(TeachersListController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Text(
          "Teachers".ctr,
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
                var items = teachersCont.teachers.value;
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
                          "Are you sure you want to delete teacher @full_name# ?",
                      onControllerSetup: (cont) {
                        controller = cont;
                      },
                      type: MyTableType.list,
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
                        var teacher = item;
                        dprint(teacher);
                        index = index + 1;
                        // dprint(teacher["id"]);
                        return ListTile(
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
                            '@full_name#'.ctr.interpolate(teacher),
                            style: Get.theme.textTheme.titleMedium,
                          ),
                          trailing: item?['is_non_delete']
                              ? Card(
                                  child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    "School Admin".ctr,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ))
                              : Wrap(
                                  spacing: 30,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        // Get.toNamed(AddTeachers.routeName,
                                        //     arguments: {
                                        //       "instance": item,
                                        //       "options": options
                                        //     });
                                        Get.toNamed(AddTeachers.routeName,
                                            arguments: {"instance": item});
                                      },
                                      icon: const Icon(
                                        Iconsax.edit,
                                        size: 22.0,
                                        color: Color(0xFF00AEEE),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        var res =
                                            await controller?.deleteItem(item);
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
                        // Get.toNamed(AddTeachers.routeName,
                        //     arguments: {"instance": item});
                      },
                      name: date_str,
                      listTypeUrl: 'api/v1/teachers',
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
          await Get.toNamed(AddTeachers.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
