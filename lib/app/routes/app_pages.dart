import 'package:get/get.dart';

import 'package:e_wallet/app/modules/add/bindings/add_binding.dart';
import 'package:e_wallet/app/modules/add/views/add_view.dart';
import 'package:e_wallet/app/modules/home/bindings/home_binding.dart';
import 'package:e_wallet/app/modules/home/views/home_view.dart';
import 'package:e_wallet/app/modules/more/bindings/more_binding.dart';
import 'package:e_wallet/app/modules/more/views/more_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD,
      page: () => AddView(),
      binding: AddBinding(),
    ),
    GetPage(
      name: _Paths.MORE,
      page: () => MoreView(),
      binding: MoreBinding(),
    ),
  ];
}
