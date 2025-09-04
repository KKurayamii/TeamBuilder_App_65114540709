import 'package:get/get.dart';
import 'home.dart';
import 'player.dart';

part 'routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: Routes.home, page: () => const HomeView()),
    GetPage(name: Routes.team, page: () => const TeamView()),
  ];
}
