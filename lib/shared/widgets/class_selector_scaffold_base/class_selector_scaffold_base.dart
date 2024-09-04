import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moe_som_app/theme/dark_theme/dark_theme.dart';
import '../../utils/utils.dart';
import '../student_default_list_tile.dart';
import 'class_selector_controller.dart';

class ClassSelectorScaffoldBasePage extends StatelessWidget {
  final String name;
  final String title;
  final List<Widget>? actions;

  final bool disableSelect;

  final Widget? header;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  final Widget? child;

  final Widget? footer;
  Widget? floatingActionButton;
  final double? spacing;

  final Function(
          Map<String, dynamic> students, BuildContext context, int index)?
      itemBuilder;

  ClassSelectorController? classSelectorController;

  ClassSelectorScaffoldBasePage(
      {super.key,
      required this.name,
      required this.title,
      this.actions,
      this.separatorBuilder,
      this.header,
      this.child,
      this.spacing = 10,
      this.disableSelect = false,
      this.floatingActionButton,
      this.itemBuilder,
      this.footer}) {
    classSelectorController = Get.find<ClassSelectorController>();
  }

  @override
  Widget build(BuildContext context) {
    // return Text("Listst");
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        centerTitle: false,
        title: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  title.ctr,
                  style: Get.theme.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextView(
                  display_message:
                      (classSelectorController?.classes.isEmpty ?? false)
                          ? 'No classes'.ctr
                          : "Class @class_name#".ctr,
                  data: classSelectorController?.selectedClass.value,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          );
        }),
        actions: [
          ...?actions,
          GestureDetector(
            onTap: classSelectorController?.openClassesModal,
            child: Container(
              color: Colors.transparent,
              child: IconButton(
                onPressed: classSelectorController?.openClassesModal,
                icon: const Icon(
                  Iconsax.menu_1,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            header ??
                const SizedBox.square(
                  dimension: 0,
                ),
            SizedBox(height: spacing),
            if (child != null)
              child ??
                  const SizedBox.square(
                    dimension: 0,
                  ),
            if (child == null)
              Obx(() {
                return Column(
                  children: [
                    if (classSelectorController?.classes.isEmpty ?? false)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height / 2.5),
                        child: Center(
                          child: Text(
                            "This school has no classes".ctr,
                            style: Get.theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    if (classSelectorController?.students.isEmpty ?? false)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height / 2.5),
                        child: Center(
                          child: Text(
                            "This class has no learners".ctr,
                            style: Get.theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var student =
                              classSelectorController?.students?.value[index];
                          if (itemBuilder != null) {
                            return GestureDetector(
                              onTap: disableSelect
                                  ? null
                                  : () => showStudentMetaData(student),
                              child: itemBuilder!(student, context, index),
                            );
                          }
                          return GestureDetector(
                            onTap: disableSelect
                                ? null
                                : () => showStudentMetaData(student),
                            child: getStudentListTileView(student, index),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            separatorBuilder != null
                                ? separatorBuilder!(context, index)
                                : divider,
                        itemCount:
                            classSelectorController?.students.value?.length ??
                                0),
                  ],
                );
              }),
            SizedBox(height: spacing),
            footer ??
                const SizedBox.square(
                  dimension: 0,
                ),
          ],
        ),
      ),
    );
  }
}
