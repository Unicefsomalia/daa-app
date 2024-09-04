import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../shared/utils/utils.dart';

class HelpController extends SuperController {
  var box = GetStorage(school_info_storage_container);
  RxList<HelpTile> supportQuestions = RxList();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSupportQuestions();
  }

  getSupportQuestions() async {
    List<HelpTile> tiles = [];
    var questions = await box.read("support_questions") ?? [];
    for (var question in questions) {
      tiles.add(HelpTile(
        title: question['title'],
        content: question['description'],
      ));
    }
    supportQuestions.value = tiles;
    dprint(supportQuestions.value);
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    getSupportQuestions();
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
