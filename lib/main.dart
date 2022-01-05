import 'package:e_wallet/app/data/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'app/data/utils/usable_strings.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ? app open ad
  // await MobileAds.initialize();
  // final AppOpenAd appOpenAd = AppOpenAd();
  // if (!appOpenAd.isAvailable) {
  //   await appOpenAd.load(
  //       unitId: AdUnitID.appOpen, orientation: AppOpenAd.ORIENTATION_PORTRAIT);
  // }
  // if (appOpenAd.isAvailable) {
  //   await appOpenAd.show();
  //   appOpenAd.load(
  //       unitId: AdUnitID.appOpen, orientation: AppOpenAd.ORIENTATION_PORTRAIT);
  // }

  // appOpenAd.onEvent.listen((e) {
  //   final event = e.keys.first;
  //   // final info = e.values.first;
  //   switch (event) {
  //     case FullScreenAdEvent.loading:
  //       print('app ad loading');
  //       break;
  //     case FullScreenAdEvent.loadFailed:
  //       print('app ad load failed');
  //       break;
  //     case FullScreenAdEvent.loaded:
  //       print('app ad loaded');
  //       break;
  //     case FullScreenAdEvent.showed:
  //       print('app ad ad showed');
  //       break;
  //     case FullScreenAdEvent.showFailed:
  //       print('app ad show failed');
  //       break;
  //     case FullScreenAdEvent.closed:
  //       // You may want to dismiss your loading screen here
  //       print('app ad ad dismissed');
  //       break;
  //     default:
  //       break;
  //   }
  // });

  // ?

  await GetStorage.init();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: Themes.light,
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
    ),
  );
}
