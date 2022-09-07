
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:ourdoctor/global/app_api.dart';
import 'package:ourdoctor/models/dto/user_dto.dart';
import 'package:ourdoctor/stores/my_page_store.dart';
import 'package:ourdoctor/stores/user_info_store.dart';

import 'global.dart';
import 'local_service.dart';

final getIt = GetIt.instance;

setupLocator() async {
  // Register EventBus
  getIt.registerSingleton(EventBus());

  // API
  final Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true));
  // getIt.registerLazySingleton<Api>(() => Api(dio, baseUrl: API_BASE_U RL));

  // Store
  getIt.registerSingleton(UserInfoStore());
  getIt.registerLazySingleton<MyPageStore>(() => MyPageStore());

  // Register ScopedModels
  //locator.registerFactory<SplashModel>(() => SplashModel());
  //locator.registerFactory<LoginModel>(() => LoginModel());
  //locator.registerFactory<SignupModel>(() => SignupModel());
  //locator.registerFactory<FindModel>(() => FindModel());
}
