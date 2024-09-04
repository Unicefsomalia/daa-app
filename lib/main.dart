import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_form/handle_offline_records.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/internalization/language_controller.dart';
import 'package:flutter_utils/internalization/models.dart';
import 'package:flutter_utils/local_nofitications/local_notification_controller.dart';
import 'package:flutter_utils/mixpanel/mixpanel_controller.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/offline_http_cache/offline_http_cache.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe_som_app/profile/offline_status_controller.dart';
import 'package:moe_som_app/routes.dart';
import 'package:moe_som_app/theme/dark_theme/dark_theme.dart';
import 'package:moe_som_app/theme/light_theme/light_theme.dart';
import 'package:workmanager/workmanager.dart';

import 'internalization/translate.dart';
import 'login/login.dart';
import 'my_school/my_school_controller.dart';
import 'navigation/navigation.dart';
import 'shared/utils/utils.dart';
import 'shared/widgets/class_selector_scaffold_base/class_selector_controller.dart';
import 'theme/sisitech/theme.dart';

getApiConfig() {
  return APIConfig(
      apiEndpoint: "API_URL",
      version: "api/v1",
      clientId: "CLIENT_ID",
      tokenUrl: 'o/token/',
      grantType: "password",
      revokeTokenUrl: 'o/revoke_token/');
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  dprint("Dispatcher called ");
  Workmanager().executeTask((task, inputData) async {
    dprint("Starting work for $task");
    Get.put<APIConfig>(getApiConfig());
    if (task.startsWith(myform_work_manager_tasks_prefix)) {
      dprint("Handing over work to myform handler $task");
      var background_res = await handleOfflineRecords(task);
      var myscCont = Get.put(MySchoolController());

      SendPort? sendPort =
          IsolateNameServer.lookupPortByName(foregroundSendSortName);

      if (sendPort != null) {
        dprint("Send port found");
        sendPort.send(json.encode(background_res));
      } else {
        dprint("NO send port found");
        await myscCont.updateClassList();
      }

      await myscCont.updateLastDataSyncEnrollment();

      var notificationCont = await initializePushNotifications();
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('b0', 'Offline Sync',
              channelDescription:
                  'To send updates whenever the a sync is successful',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      var rng = Random();
      var id = rng.nextInt(30);

      var title_sub =
          task == "MYFORM.offlineStudent" ? "Students" : "Attendance";
      var title = "Offline $title_sub Sync";
      var body =
          "Offline $title_sub changes successfully synced. Class list up to date.";

      notificationCont.showBasicNotification(
          id, title, body, notificationDetails);

      return Future.value(true);
    } else {
      return Future.value(true);
    }
  });
}

registerSendPortForBackgroundStuff() {
  ReceivePort receivePort = Get.put(ReceivePort());
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, foregroundSendSortName);
}

initialieStorages() async {
  dprint("Initializing dbs");
  await GetStorage.init();
  await GetStorage.init(school_info_storage_container);
  await GetStorage.init(offline_login_storage_container);
  await GetStorage.init(offline_student_storage);
  await GetStorage.init(offline_attendance_storage);
}

initializePushNotifications() async {
  var notificationCont = Get.put(LocalNotificationController(
      notificationTapBackground: notificationTapBackground));
  notificationCont.initializeLocalNotifications();
  return notificationCont;
}

const default_local_name = "Somali";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  registerSendPortForBackgroundStuff();
  Get.put<APIConfig>(getApiConfig());
  await initialieStorages();
  //.ctr
  Get.put(const LolaleConfig(
    updateAPIDebug: false,
    updateMissOnlyDebug: false,
    printDebug: false,
  ));

  Get.put(AuthController());
  Get.put(MySchoolController(listenToBackground: true));

  Get.put(OfflineHttpCacheController());
  Get.put(NetworkStatusController());
  Get.put(ClassSelectorController());
  Get.put(OfflineAttendanceController());

  Get.put(
    MixPanelController(
      mixpanelToken: "1070b47cc7875f22304f13edc33e6dc0",
      options: const MixpanelOptions(
        // enableAnonymous: false,
        flushNow: true,
        // persistentAnonymous: false,
      ),
    ),
  );
  var localeCont = Get.put(
    LocaleController(
      defaultLocaleName: "English",
      defaultTranslationKeys: defaultLocales,
      // selectorTitle: "Language ",
    ),
  );

  // Get.put(localeCont);
  // Disable fetching of fonts
  GoogleFonts.config.allowRuntimeFetching = false;

  await initializePushNotifications();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  await localeCont.apiGetLocales();
  await localeCont.readAllStorageLocales();
  await localeCont.setCurrentLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var authc_cont = Get.find<AuthController>();
    return GetMaterialApp(
        title: 'Somalia Digital Attendance'.ctr,
        debugShowCheckedModeBanner: false,
        translations: Get.find<LocaleController>().getCustomAppTranslations(),
        themeMode: ThemeMode.dark,
        // theme: appLightTheme,
        // darkTheme: appDarkTheme,
        darkTheme: sisitechTheme.darkTheme,
        theme: sisitechTheme.theme,
        initialRoute: '/',
        getPages: [
          GetPage(
              name: '/',
              page: () {
                dprint("${authc_cont.isAuthenticated$.value} Is auth");
                return authc_cont.isAuthenticated$.value
                    ? BottomNavigationPage()
                    : const LoginPage();
              }),
          ...appRoutes
        ]);
  }
}
