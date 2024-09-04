import 'package:flutter/material.dart';
import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/mixpanel/mixpanel_controller.dart';
import 'package:flutter_utils/phone_call_launcher.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../../profile/offline_status_controller.dart';
import '../../theme/dark_theme/dark_theme.dart';

const school_info_storage_container = "school";
const offline_student_storage = "offlineStudent";
const offline_attendance_storage = "offlineAttendance";
const last_sync_enrolment_key = "last_sync_enrolment";
const last_sync_attendance_key = "last_sync_attendance";
const foregroundSendSortName = "foreground_send_port_name";

class AuthenticatedProvider extends AuthProvider {}

class MySchoolTile {
  final String label;
  final IconData iconData;
  final String routeName;
  final bool adminOnly;

  MySchoolTile({
    required this.label,
    this.adminOnly = false,
    required this.iconData,
    required this.routeName,
  });
}

class MyOfflineTile {
  final String label;
  final String trailingLabel;
  final Color trailingBackgroundColor;
  final Color trailingColor;
  final Widget? child;
  final Widget Function(BuildContext context, MyOfflineTile tile,
      OfflineAttendanceController offlineController)? trailingBuilder;

  MyOfflineTile({
    required this.label,
    required this.trailingLabel,
    required this.trailingBackgroundColor,
    required this.trailingColor,
    this.trailingBuilder,
    this.child,
  });
}

class HelpTile {
  final String title;
  final String content;

  HelpTile({
    required this.title,
    required this.content,
  });
}

class HelpOptions {
  final String label;
  final String routeName;
  final bool isInternal;

  HelpOptions(
      {required this.label, required this.routeName, this.isInternal = true});
}

launchGuardianCall(student) async {
  dprint(student);

  var phoneAvaiableMessage =
      "Call @full_name#'s @current_guardian_relationship#, @current_guardian_name# ?"
          .ctr;

  var noPhoneMessage = "No guardian phone found for @full_name#".ctr;
  var hasGuardianDetails = student?["current_guardian_phone"] != null;
  dprint(student?["current_guardian_phone"]);
  dprint("Had info $hasGuardianDetails");
  Get.defaultDialog(
    title: "Call Guardian".ctr,
    titleStyle: Get.theme.textTheme.titleLarge,
    cancelTextColor: Colors.white,
    confirmTextColor: Colors.black,
    buttonColor: Get.theme.primaryColor,
    onCancel: () {},
    textConfirm: !hasGuardianDetails ? null : "Call".ctr,
    onConfirm: !hasGuardianDetails
        ? null
        : () async {
            await triggerPhoneCall(student["current_guardian_phone"]);
            Get.back();
          },
    content: TextView(
      style: Get.theme.textTheme.labelMedium,
      display_message:
          hasGuardianDetails ? phoneAvaiableMessage : noPhoneMessage,
      data: student,
    ),
  );
}

class LearnerMetadata {
  late String title;
  late String description;

  LearnerMetadata({required this.title, required this.description});
}

getStreamTile(dynamic stream, Function selectClass, bool isSelected,
    {close = true}) {
  return ListTile(
    onTap: () {
      selectClass(stream);
      if (close) Get.back();
    },
    title: TextView(
      display_message: "@class_name#".ctr,
      data: stream,
      style: Get.theme.textTheme.titleMedium,
    ),
    trailing:
        Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off),
  );
}

var divider = const Divider(
  color: Color.fromARGB(135, 158, 158, 158),
  indent: 60,
);

var searchBar = TextField(
  decoration: InputDecoration(
    labelText: 'Search Learner by Name'.ctr,
    suffixIcon: const Icon(Icons.search_rounded),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    fillColor: const Color.fromARGB(121, 0, 174, 238),
    // labelStyle: const TextStyle(color: Colors.white54),
    suffixIconColor: Colors.white54,
  ),
);
var learnerMetadata = [
  LearnerMetadata(
    title: "Full Name",
    description: "@full_name#",
  ),
  LearnerMetadata(
    title: "Father's Name",
    description: "@father_name#",
  ),
  LearnerMetadata(
    title: "Father's Phone Number",
    description: "@father_phone#",
  ),
  LearnerMetadata(
    title: "Father's Status",
    description: "@father_status_display#",
  ),
  LearnerMetadata(
    title: "Mother's Full Name",
    description: "@mother_name#",
  ),
  LearnerMetadata(
    title: "Mother's Phone Number",
    description: "@mother_phone#",
  ),
  LearnerMetadata(
    title: "Mother's Status",
    description: "@mother_status_display#",
  ),
  LearnerMetadata(
    title: "Do you live with your parent/s?",
    description: "@live_with_parent#",
  ),
  LearnerMetadata(
    title: "Guardian Name",
    description: "@guardian_name#",
  ),
  LearnerMetadata(
    title: "Guardian Phone",
    description: "@guardian_phone#",
  ),
  LearnerMetadata(
    title: "Guardian Relationship",
    description: "@guardian_relationship#",
  ),
  LearnerMetadata(
    title: "Admission Number",
    description: "@admission_no#",
  ),
  LearnerMetadata(
    title: "Student Status",
    description: "@status_display#",
  ),
  LearnerMetadata(
    title: "Gender",
    description: "@gender_display#",
  ),
  LearnerMetadata(
    title: "Class / Grade",
    description: "@class_name#",
  ),
  LearnerMetadata(
    title: "Date of Birth",
    description: "@date_of_birth#",
  ),
  LearnerMetadata(
    title: "Date of Admission",
    description: "@date_enrolled#",
  ),
  LearnerMetadata(
    title: "Is the learner over age?",
    description: "@is_over_age#",
  ),
  LearnerMetadata(
    title: "Special Needs",
    description: "@special_needs_details..name#",
  ),
  LearnerMetadata(
    title: "Has attended Pre-Primary?",
    description: "@pre_primary_attendend_display#",
  ),
  LearnerMetadata(
    title: "State Name",
    description: "@state_name#",
  ),
  LearnerMetadata(
    title: "Region Name",
    description: "@region_name#",
  ),
  LearnerMetadata(
    title: "District Name",
    description: "@district_name#",
  ),
  LearnerMetadata(
    title: "Vilage Name",
    description: "@village_name#",
  ),
  LearnerMetadata(
    title: "House Number",
    description: "@house_number#",
  ),
];

bool getIsSchoolAdmin() {
  AuthController authController = Get.find<AuthController>();
  var profile = authController.profile.value as Map<String, dynamic>;
  if (profile.containsKey("is_school_admin")) {
    return profile["is_school_admin"];
  }
  return false;
}

mixpanelTrackEvent(name) {
  try {
    MixPanelController? mixCont = Get.find<MixPanelController>();
    mixCont.track(
      name,
    );
  } catch (e) {
    dprint(e);
  }
}

showStudentMetaData(dynamic student) async {
  dprint("Selected");
  dprint(student);
  var bottomSheetWidget = Card(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "Learner Details".ctr,
              style: Get.theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (contex, index) {
              var metadata = learnerMetadata[index];

              return ListTile(
                leading: Text(
                  metadata.title.ctr,
                  style: Get.theme.textTheme.titleMedium,
                ),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: TextView(
                    display_message: metadata.description.ctr,
                    data: student,
                  ),
                ),
              );
            },
            separatorBuilder: (contex, index) {
              return divider;
            },
            itemCount: learnerMetadata.length,
          )
        ],
      ),
    ),
  );
  var res = await Get.bottomSheet(bottomSheetWidget);
}

class ReporsStatsCard extends StatelessWidget {
  Map<String, dynamic>? data;

  String title;
  String subtitle;
  String count;
  Color countColor;
  Color backgroundColor;

  ReporsStatsCard({
    super.key,
    this.data,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.countColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    dprint(data);
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: TextView(
            data: data,
            display_message: title.ctr,
            // 'Present Learners',
            style: Get.theme.textTheme.titleLarge,
          ),
          subtitle: TextView(
            style: Get.theme.textTheme.titleMedium,
            data: data,
            display_message: subtitle.ctr,
            //  "Present Boys @present_males# \n"
            //     "Present Girls @present_girls#",
          ),
          trailing: badges.Badge(
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.white,
              padding: EdgeInsets.all(10),
            ),
            badgeContent: TextView(
              display_message: count,
              data: data,
              style: TextStyle(
                // color: Color(0xFF00AEEE),
                color: countColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
