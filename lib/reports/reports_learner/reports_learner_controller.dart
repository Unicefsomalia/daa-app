import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:get/get.dart';

import '../base_report_controller.dart';

class LearnerReportController extends BaseReportController {
  var auth_controller = Get.find<AuthController>();
  // "is_training_school": is_training_school.toString(),

  @override
  getArgs() {
    return {
      "stream": "${stream.value}",
      "start_date": getCurrentDate(),
      "order_by": "absent_count",
      "order": "DESC",
      "is_training_school":
          auth_controller.profile.value?["is_training_school"]?.toString() ??
              "false"
    };
  }
}
