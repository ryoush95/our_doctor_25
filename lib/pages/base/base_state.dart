import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/stores/user_info_store.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  // final Api api = getIt<Api>();
  bool isLoading = false;
  final user = getIt<UserInfoStore>();
  final event = getIt<EventBus>();

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }
}
