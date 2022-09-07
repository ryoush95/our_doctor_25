import 'package:mobx/mobx.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/models/dto/user_dto.dart';

part 'user_info_store.g.dart';

class UserInfoStore = _UserInfoStore with _$UserInfoStore;

abstract class _UserInfoStore with Store {
  @observable
  UserDto info = UserDto();

  @action
  void setInfo(UserDto? newValue) {
    if (newValue != null) {
      info = newValue;
    }

    LocalService.setUser(newValue!);
  }
}
