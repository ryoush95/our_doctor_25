import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/pages/intro/first.dart';

part 'my_page_store.g.dart';

class MyPageStore = _MyPageStore with _$MyPageStore;

abstract class _MyPageStore with Store {
  
  ObservableList<CommunityDto> posts = ObservableList<CommunityDto>();
  
  @observable
  bool isLast = false;
  
  HttpService httpService = HttpService();

  @action
  loadList({
    int page = 0,
    required BuildContext ctx,
  }) async {

    if (page == 0) {
      posts.clear();
    }

    try {
      final result = await httpService.getMyPosts(page);
    
      if(result.result == 0) {
        //FIXME: contents return an empty list. 
        posts.addAll(result.data!.contents!);
        isLast = result.data!.isLast!;
      } else {
        showToast(result.msg ?? "");
        if(result.result == 106) {
          Navigator.pushReplacement(
            ctx, 
            SlideRightTransRoute(builder: (context) => FirstPage())
          );
        }
      }

    } catch (err) {
      showToast(err.toString());
    }
  }
}