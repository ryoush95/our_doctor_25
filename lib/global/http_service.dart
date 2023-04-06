import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/active_list_res_model.dart';
import 'package:ourdoctor/models/add_children_res_model.dart';
import 'package:ourdoctor/models/alarm_res_model.dart';
import 'package:ourdoctor/models/app_res_model.dart';
import 'package:ourdoctor/models/ask_list_res_model.dart';
import 'package:ourdoctor/models/basket_add_res_model.dart';
import 'package:ourdoctor/models/basket_list_res_model.dart';
import 'package:ourdoctor/models/brain_quiz_list_res_model.dart';
import 'package:ourdoctor/models/category_list_res_model.dart';
import 'package:ourdoctor/models/chat_quiz_list_res_model.dart';
import 'package:ourdoctor/models/check_chat_res_model.dart';
import 'package:ourdoctor/models/check_child_model.dart';
import 'package:ourdoctor/models/child_quiz_list_res_model.dart';
import 'package:ourdoctor/models/childinfo_res_model.dart';
import 'package:ourdoctor/models/comment_list_res_model.dart';
import 'package:ourdoctor/models/community_add_res_model.dart';
import 'package:ourdoctor/models/community_detail_res_model.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/monitor_development_list_model.dart';
import 'package:ourdoctor/models/duplicate_res_model.dart';
import 'package:ourdoctor/models/faq_res_model.dart';
import 'package:ourdoctor/models/final_result_res_model.dart';
import 'package:ourdoctor/models/find_id_res_model.dart';
import 'package:ourdoctor/models/food_list_monitoring_model.dart';
import 'package:ourdoctor/models/food_list_res_model.dart';
import 'package:ourdoctor/models/free_test_res_model.dart';
import 'package:ourdoctor/models/home_brain_res_model.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/models/home_disease_res_model.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/models/home_story_res_model.dart';
import 'package:ourdoctor/models/home_vaccine_res_model.dart';
import 'package:ourdoctor/models/home_weather_model.dart';
import 'package:ourdoctor/models/homecare_banner_res_model.dart';
import 'package:ourdoctor/models/homecare_data_res_model.dart';
import 'package:ourdoctor/models/homecare_list_res_model.dart';
import 'package:ourdoctor/models/hosiptal_list_res_model.dart';
import 'package:ourdoctor/models/live_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/mbti_quiz_list_res_model.dart';
import 'package:ourdoctor/models/monitor_list_res_model.dart';
import 'package:ourdoctor/models/monitor_result_res_model.dart';
import 'package:ourdoctor/models/monitor_week_res_model.dart';
import 'package:ourdoctor/models/monitor_write_res_model.dart';
import 'package:ourdoctor/models/monitoring/food_check_list1_model.dart';
import 'package:ourdoctor/models/monitoring/food_check_list2_model.dart';
import 'package:ourdoctor/models/monitoring/food_habits_result_model.dart';
import 'package:ourdoctor/models/monitoring/food_item_list_model.dart';
import 'package:ourdoctor/models/monitoring/food_list_model.dart';
import 'package:ourdoctor/models/monitoring/heath_result_model.dart';
import 'package:ourdoctor/models/monitoring/life_result_model.dart';
import 'package:ourdoctor/models/monitoring/note_profile_model.dart';
import 'package:ourdoctor/models/monitoring/sleep_graph_model.dart';
import 'package:ourdoctor/models/monitoring/solution_area_model.dart';
import 'package:ourdoctor/models/monitoring/temp_graph_model.dart';
import 'package:ourdoctor/models/monitoring/top_area_model.dart';
import 'package:ourdoctor/models/monitoring_all_res_model.dart';
import 'package:ourdoctor/models/monitoring_list_res_model.dart';
import 'package:ourdoctor/models/monitoring_record_res_model.dart';
import 'package:ourdoctor/models/monitoring_result_res_model.dart';
import 'package:ourdoctor/models/my_review_list_res_model.dart';
import 'package:ourdoctor/models/order_detail_res_model.dart';
import 'package:ourdoctor/models/order_list_res_model.dart';
import 'package:ourdoctor/models/order_start_res_model.dart';
import 'package:ourdoctor/models/pass_set_res_model.dart';
import 'package:ourdoctor/models/point_his_list_res_model.dart';
import 'package:ourdoctor/models/product/test4_quiz_model.dart';
import 'package:ourdoctor/models/product/test_quiz_result_model.dart';
import 'package:ourdoctor/models/product_detail_res_model.dart';
import 'package:ourdoctor/models/product_like_res_model.dart';
import 'package:ourdoctor/models/product_list_res_model.dart';
import 'package:ourdoctor/models/product_review_list_res_model.dart';
import 'package:ourdoctor/models/product_review_write_res_model.dart';
import 'package:ourdoctor/models/res/mbti_quiz_send_res_model.dart';
import 'package:ourdoctor/models/review_detail_res_model.dart';
import 'package:ourdoctor/models/review_list_res_model.dart';
import 'package:ourdoctor/models/signup_parent_model.dart';
import 'package:ourdoctor/models/story_res_model.dart';
import 'package:ourdoctor/models/product/test2_quiz_list_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/models/userinfo_res_model.dart';
import 'package:path/path.dart';

class HttpService {
  //앱 정보얻기
  Future<AppInfoResModel> getAppInfo() async {
    String _url = API_BASE_URL + "api/common/app_info";

    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }
    Map<String, String> body = {
      'dev_type': devtype,
      'app_ver': gAppVer,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return AppInfoResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //로그인
  Future<LoginResModel> login(String name, String pwd, String token, String area, String hospital) async {
    String _url = API_BASE_URL + "api/user/login";
    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }

    Map<String, String> body = {
      'name': name,
      'pwd': pwd,
      'dev_type': devtype,
      'push_token': token,
      'area': area,
      'hospital': hospital,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return LoginResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //로그인
  Future<LoginResModel> login2(String id, String pwd, String type, String token) async {
    String _url = API_BASE_URL + "api/user/login2";
    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }

    Map<String, String> body = {
      'login_id': id,
      'pwd': pwd,
      'signup_type': type,
      'dev_type': devtype,
      'push_token': token,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return LoginResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<LoginResModel> login3(String id, String pwd, String type, String token) async {
    String _url = API_BASE_URL + "api/user/login3";
    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }

    Map<String, String> body = {
      'login_id': id,
      'pwd': pwd,
      'signup_type': type,
      'dev_type': devtype,
      'push_token': token,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return LoginResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //로그아웃
  Future<DefaultResModel> logout() async {
    String _url = API_BASE_URL + "api/user/logout";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //버전 가져오기
  Future<String> getVersion() async {
    String _url = API_BASE_URL + "api/user/get_ver";
    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }

    Map<String, String> body = {
      'platform' : devtype,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //날씨정보 얻기
  Future<HomeWeatherModel> getWeather() async {
    String _url = API_BASE_URL + "api/user/get_weather?access_token=token";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeWeatherModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //회원정보 얻기
  Future<UserInfoResModel> userInfo() async {
    String _url = API_BASE_URL + "api/user/get_profile";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return UserInfoResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<UserInfoResModel> userInfo2() async {
    String _url = API_BASE_URL + "api/User/get_profile2";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return UserInfoResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //order detail
  Future<OrderDetailResModel> getUserOrderById(String orderId) async {
    String _url = API_BASE_URL + "api/order/detail";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'order_id': orderId,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return OrderDetailResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //order추가
  Future<DefaultResModel> addOrder(String address, String uaPoint, String payMethod, String pList, String fee) async {
    String _url = API_BASE_URL + "api/order/new";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'address': address,
      'ua_point': uaPoint,
      'pay_method': payMethod,
      'plist': pList,
      'shipping_fee': fee,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //favorite product얻기
  Future<ProductListResModel> getFavoriteList(String start, String length) async {
    String _url = API_BASE_URL + "api/product/list";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'only_like': "1", 'start': start, 'length': length};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //review 목록얻기
  Future<ReviewListResModel> getReviews(String status, String start, String length) async {
    String _url = API_BASE_URL + "api/review/review_products";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'status': status, 'start': start, 'length': length};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ReviewListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //review 상세얻기
  Future<ReviewDetailResModel> getReviewDetail(String pid) async {
    String _url = API_BASE_URL + "api/ProductReview/detail";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pid': pid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ReviewDetailResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //review 쓰기
  Future<ProductReviewWriteResModel> writeReview(String pid, String rating, String text, String photos) async {
    String _url = API_BASE_URL + "api/ProductReview/write_review";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'order_product_id': pid,
      'rating': rating,
      'text': text,
      'photos': photos,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductReviewWriteResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //review 삭제
  Future<DefaultResModel> deleteReview(String reviewId) async {
    String _url = API_BASE_URL + "api/ProductReview/delete";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'review_id': reviewId,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //review 수정
  Future<DefaultResModel> editReview(String reviewId, String rating, String text, String photos) async {
    String _url = API_BASE_URL + "api/ProductReview/edit";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'review_id': reviewId,
      'rating': rating,
      'text': text,
      'photos': photos,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //live data 얻기
  Future<LiveResModel> liveInfo() async {
    String _url = API_BASE_URL + "api/user/live_data";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return LiveResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 story 얻기
  Future<HomeStoryResModel> homeStoryList() async {
    String _url = API_BASE_URL + "api/story/home_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeStoryResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //알림list 얻기
  Future<AlarmResModel> alarmList(int nPage) async {
    String _url = API_BASE_URL + "api/user/notification_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': nPage.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return AlarmResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //파일 upload
  Future<FileUploadResModel> uploadFile(File uploadFile) async {
    late MultipartFile multipartFile;
    if (uploadFile != null) {
      final mimeTypeData = lookupMimeType(uploadFile.path, headerBytes: [0xFF, 0xD8])!.split('/');
      multipartFile = await MultipartFile.fromFile(uploadFile.path, filename: basename(uploadFile.path), contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    }
    var dio = Dio();
    FormData formData = FormData.fromMap({'uploadfile': multipartFile});
    dio.options.baseUrl = API_BASE_URL + "api/common/upload_file";
    final response = await dio.post(API_BASE_URL + "api/common/upload_file", data: formData);
    if (response.statusCode == 200) {
      return FileUploadResModel.fromJson(response.data);
    } else {
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //story 조회
  Future<DefaultResModel> storyDetail(String _uid) async {
    String _url = API_BASE_URL + "api/story/story_detail";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'id': _uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //story list
  Future<StoryResModel> storyList(int page, int order, String category, String keyword) async {
    String _url = API_BASE_URL + "api/story/story_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
      'order': order.toString(),
      'category': category,
      'keyword': keyword,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return StoryResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //Faq 조회
  Future<DefaultResModel> faqDetail(String _uid) async {
    String _url = API_BASE_URL + "api/story/faq_detail";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'id': _uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //faq list
  Future<FaqResModel> faqList(int page, int order, String category, String keyword) async {
    String _url = API_BASE_URL + "api/Story/faq_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
      'order': order.toString(),
      'category': category,
      'keyword': keyword,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FaqResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //결과message 남기기
  Future<DefaultResModel> sendMsg(String message) async {
    String _url = API_BASE_URL + "api/user/add_message";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'message': message,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //정보수정
  Future<DefaultResModel> userEdit(String phone_relation, String address, String disease, String prescription, String profile_img_url) async {
    String _url = API_BASE_URL + "api/user/change_profile";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'phone_relation': phone_relation,
      'address': address,
      'disease': disease,
      'prescription': prescription,
      'profile_img_url': profile_img_url,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //monitor 최종결과얻기
  Future<FinalResultResModel> finalResult() async {
    String _url = API_BASE_URL + "api/monitor/get_last_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FinalResultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //monitor list 얻기
  Future<MonitorListResModel> monitorList(int page) async {
    String _url = API_BASE_URL + "api/monitor/monitor_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitorListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //monitor 쓰기
  Future<MonitorWriteResModel> monitorWrite(String datetime, String uid, String temperature, String oxygen, String heart_cnt, String symptom, String pill_url, String speciality) async {
    String _url = API_BASE_URL + "api/monitor/write";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'datetime': datetime,
      'uid': uid,
      'temperature': temperature,
      'oxygen': oxygen,
      'heart_cnt': heart_cnt,
      'symptom': symptom,
      'pill_url': pill_url,
      'speciality': speciality,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitorWriteResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //monitor 결과 얻기
  Future<MonitorResultResModel> monitorResult(String date) async {
    String _url = API_BASE_URL + "api/monitor/get_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'date': date,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitorResultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //monitor 주 결과 얻기
  Future<MonitorWeekResultResModel> monitorWeekResult(String date) async {
    String _url = API_BASE_URL + "api/monitor/get_week_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'start_date': date,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitorWeekResultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //회원가입 사용안함
  Future<SignupParentResModel> signup2(String id, String pwd, String type, String token, String name, String birth, String phone, String code, String addr1, String addr2, String dad_height, String mom_height, String family_history, String child_list, String realtion, String alarm) async {
    String _url = API_BASE_URL + "api/user/signup2";
    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }
    Map<String, String> body = {
      'login_id': id,
      'pwd': pwd,
      'signup_type': type,
      'dev_type': devtype,
      'push_token': token,
      'name': name,
      'birth': birth,
      'phone': phone,
      'postcode': code == "" ? "code" : code,
      'address': addr1 == "" ? "addr1" : addr1,
      'address_detail': addr2 == "" ? "addr2" : addr2,
      'dad_height': dad_height,
      // 'dad_weight': dad_weight,
      'mom_kidney': mom_height,
      // 'mom_weight': mom_weight,
      'family_history': family_history,
      'child_list': child_list,
      'relation': realtion,
      'alarm_yn': alarm,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return SignupParentResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //회원가입 부모회원가입 적용
  Future<SignupParentResModel> signup3(String id, String pwd, String type, String token, String name, String birth, String phone, String code, String addr1, String addr2, String dad_height, String mom_height, String family_history, String child_list, String realtion, String nickname, String alarm) async {
    String _url = API_BASE_URL + "api/user/signup2";
    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }
    Map<String, String> body = {
      'login_id': id,
      'pwd': pwd,
      'signup_type': type,
      'dev_type': devtype,
      'push_token': token,
      'name': name,
      'birth': birth,
      'phone': phone,
      'postcode': code,
      'address': addr1,
      'address_detail': addr2,
      'child_relation': realtion,
      'dad_height': dad_height,
      // 'dad_weight': dad_weight,
      'mom_height': mom_height,
      // 'mom_weight': mom_weight,
      'family_history': family_history,
      'child_list': child_list,
      'nickname': nickname,
      'alarm_yn' : alarm,
      'system_alarm_yn' : 'y',
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return SignupParentResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<DefaultResModel> addChildren2(
      String access_token, String uid, String name, int gender, String height, String weight, String birthday, String medical_history, String testdate, String address1, String address2, String address3, String hospitalId, String relationship, String profileImage) async {
    String _url = API_BASE_URL + "api/user/add_child2";
    Map<String, String> body = {
      'access_token': access_token,
      'uid': uid,
      'name': name,
      'gender': gender.toString(),
      'height': height,
      'weight': weight,
      'birth': birthday,
      'medical_history': medical_history,
      'confirmed_date': testdate,
      'postcode': address1 == "" ? "address1" : address1,
      'address': address2 == "" ? "address2" : address2,
      'address_detail': address3 == "" ? "address3" : address3,
      'hospital_id': hospitalId,
      'relation': relationship == "" ? "father" : relationship,
      'profile_img_url': profileImage == "" ? "profileImage" : profileImage
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<AddChildResModel> addChildren3(String access_token, String uid, String name, int gender, String height, String weight, String birthday, String medical_history, String profileImage) async {
    String _url = API_BASE_URL + "api/user/add_child2";
    Map<String, String> body = {
      'access_token': access_token,
      'uid': uid,
      'name': name,
      'gender': gender.toString(),
      'height': height,
      'weight': weight,
      'birth': birthday,
      'family_history': medical_history,
      'profile_img': profileImage == "" ? "profileImage" : profileImage,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return AddChildResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<DefaultResModel> editChildren3(String access_token, String uid, String name, int gender, String height, String weight, String birthday, String medical_history, String profileImage) async {
    String _url = API_BASE_URL + "api/user/add_child2";
    Map<String, String> body = {
      'access_token': access_token,
      'uid': uid,
      'name': name,
      'gender': gender.toString(),
      'height': height,
      'weight': weight,
      'birth': birthday,
      'family_history': medical_history,
      'profile_img': profileImage == "" ? "profileImage" : profileImage,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //회원가입
  Future<DefaultResModel> signup(String id, String pwd, String type, String token, String name, String birth, int gender, String phone, String date, String postcode, String address1, String address2, String isChild, String alarm, String childList, String hosiptalId) async {
    String _url = API_BASE_URL + "api/user/signup";
    String devtype = "";
    if (Platform.isAndroid) {
      devtype = "android";
    } else {
      devtype = "ios";
    }

    Map<String, String> body = {
      'login_id': id,
      'pwd': pwd,
      'signup_type': type,
      'dev_type': devtype,
      'push_token': token,
      'name': name,
      'birth': birth,
      'phone': phone,
      'monitor_date': date,
      'postcode': postcode,
      'address': address1,
      'address_detail': address2,
      'add_child': isChild,
      'alarm_yn': alarm,
      'system_alarm_yn' : 'y',
      'child_list': childList,
      'gender': gender.toString(),
      'hospital_id': hosiptalId,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //인증번호 요청
  Future<DefaultResModel> authKey(String name,String phone,String type,String loginId) async {
    String _url = API_BASE_URL + "api/user/request_auth_key";

    Map<String, String> body = {
      'name' : name,
      'phone': phone,
      'type' : type,
      'login_id' : loginId,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //아이디 찾기
  Future<FindIdResModel> findId(String phone, String name, String certKey) async {
    String _url = API_BASE_URL + "api/user/find_id";

    Map<String, String> body = {
      'phone': phone,
      'name': name,
      'cert_key': certKey,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FindIdResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //비밀번호 재설정
  Future<DefaultResModel> passReset(String token, String pwd) async {
    String _url = API_BASE_URL + "api/user/reset_pwd";

    Map<String, String> body = {
      'access_token': token,
      'pwd': pwd,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //비밀번호 찾기
  Future<PassSetResModel> findPwd(String phone, String name, String id, String cetKey) async {
    String _url = API_BASE_URL + "api/user/find_pwd";

    Map<String, String> body = {
      'phone': phone,
      'name': name,
      'login_id': id,
      'cert_key': cetKey,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return PassSetResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈데이터 얻기
  Future<HomeDataResModel> homeData(String tab) async {
    String _url = API_BASE_URL + "api/user/home_data";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'tab': tab,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeDataResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //community 추가
  Future<CommunityAddResModel> communityAdd(
    String topic, 
    String title, 
    String content, 
    String imgUrl,
    String uid, 
    String secret, 
    String imgs,
    String ages,
  ) async {
    String _url = API_BASE_URL + "api/community/write";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'topic': topic,
      'title': title,
      'content': content,
      'img_url': imgUrl,
      'uid': uid,
      'secret': secret,
      'images': imgs,
      'ages': ages,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return CommunityAddResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //community 상세
  Future<CommunityDetailResModel> communityDetail(String uid) async {
    String _url = API_BASE_URL + "api/community/community_detail";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'uid': uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return CommunityDetailResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //community 좋아요
  Future<DefaultResModel> communityLike(String uid) async {
    String _url = API_BASE_URL + "api/community/like_community";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'uid': uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //community 삭제
  Future<DefaultResModel> communityDel(String uid) async {
    String _url = API_BASE_URL + "api/community/delete_community";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'uid': uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //댓글 추가
  Future<DefaultResModel> commentAdd(String uid, String parentUid, String content) async {
    String _url = API_BASE_URL + "api/community/comment_add";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'target_uid': uid,
      'parent_uid': parentUid,
      'content': content,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //댓글 삭제
  Future<DefaultResModel> commentDel(String uid) async {
    String _url = API_BASE_URL + "api/community/comment_remove";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'uid': uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }
  
  //댓글 수정
  Future<DefaultResModel> commentEdit(String uid, String content) async {
    String _url = API_BASE_URL + "api/community/comment_edit";
    
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'content': content, 
      'uid': uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  } 

  //댓글 list
  Future<CommentListResModel> commentList(String uid, int page) async {
    String _url = API_BASE_URL + "api/community/comment_list";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'community_uid': uid,
      'page': page.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return CommentListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //신고하기
  Future<DefaultResModel> report(String type, String uid, String content, String reportType) async {
    String _url = API_BASE_URL + "api/community/report";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'target_type': type,
      'target_uid': uid,
      'content': content,
      'report_type': reportType,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //병원 list
  Future<HospitalListResModel> hospitalList(String city, String district) async {
    String _url = API_BASE_URL + "api/common/hospital_list";

    Map<String, String> body = {
      'city': city,
      'district': district,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HospitalListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //활동 list
  Future<ActiveListResModel> activeList(int page, int type) async {
    String _url = API_BASE_URL + "api/user/notification_list";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
      'type': type.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ActiveListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //자녀추가하기
  Future<DefaultResModel> addChildren(String uid, String name, String birth, int gender, String phone, String date, String postcode, String address1, String address2, String hosiptalId, String profile, String weight) async {
    String _url = API_BASE_URL + "api/user/add_child";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'uid': uid, //변경이면 uid, 아니면 빈문자열
      'name': name,
      'birth': birth,
      'phone': phone,
      'monitoring_date': date,
      'postcode': postcode,
      'address': address1,
      'address_detail': address2,
      'gender': gender.toString(),
      'hospital_id': hosiptalId,
      'profile_img_url': profile,
      'weight': weight,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //설정
  Future<DefaultResModel> setting(String alarm_yn, String system_alarm_yn) async {
    String _url = API_BASE_URL + "api/user/change_setting";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'alarm_yn': alarm_yn,
      'system_alarm_yn' : system_alarm_yn,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //문의하기
  Future<DefaultResModel> addAsk(String title, String content, String imgUrl) async {
    String _url = API_BASE_URL + "api/user/ask_add";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'title': title,
      'content': content,
      'img_url': imgUrl,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //문의하기 list
  Future<AskListResModel> askList(int page) async {
    String _url = API_BASE_URL + "api/user/ask_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return AskListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //유저 자식정보 얻기
  Future<ChildInfoResModel> childInfo(String child_uid) async {
    String _url = API_BASE_URL + "api/user/get_child_profile";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'child_uid': child_uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ChildInfoResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<ChildInfoResModel> childInfo2(String child_uid) async {
    String _url = API_BASE_URL + "api/user/get_child_profile2";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'child_uid': child_uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ChildInfoResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //유저 자식 선택
  Future<DefaultResModel> selchild(String child_uid) async {
    String _url = API_BASE_URL + "api/user/select_child";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'child_uid': child_uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //회원정보 수정
  Future<DefaultResModel> changeProfile(String pwd, String name, String birth, String profile, int gender, String phone, String date, String postcode, String address1, String address2, String hosiptalId) async {
    String _url = API_BASE_URL + "api/user/change_profile2";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pwd': pwd,
      'name': name,
      'birth': birth,
      'profile_img_url': profile,
      'hospital_id': hosiptalId,
      'address': address1,
      'address_detail': address2,
      'monitoring_date': date,
      'postcode': postcode,
      'gender': gender.toString(),
      'phone': phone,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //회원정보수정-부모정보수정
  Future<DefaultResModel> changeParentProfile(String pwd, String name, String birth, String phone, String postcode, String address, String address_detail, String dad_height, String dad_weight, String mom_kidney, String mom_weight, String relation, String nickname, String alarm, String systemAlarm) async {
    String _url = API_BASE_URL + "api/user/change_profile3";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pwd': pwd,
      'name': name,
      'birth': birth,
      'phone': phone,
      'postcode': postcode,
      'address': address,
      'address_detail': address_detail,
      'dad_height': dad_height,
      'dad_weight': dad_weight,
      'mom_height': mom_kidney,
      'mom_weight': mom_weight,
      'relation': relation,
      'nickname': nickname,
      'alarm' : alarm,
      'system_alarm' : systemAlarm,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //유저 자식 삭제
  Future<DefaultResModel> delchild(String child_uid) async {
    String _url = API_BASE_URL + "api/user/delete_child";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'child_uid': child_uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //댓글 좋아요
  Future<DefaultResModel> replyLike(String uid) async {
    String _url = API_BASE_URL + "api/community/like_comment";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'uid': uid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //producctList
  Future<ProductListResModel> getProductList(String category1, String category2, String category3, String start, String length, String keyword) async {
    String _url = API_BASE_URL + "api/product/list";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'category_1': category1, 'category_2': category2, 'category_3': category3, 'start': start, 'length': length, 'keyword': keyword};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //상품 리뷰리스트
  Future<ProductReviewListResModel> getProductReview(String pid, int start, String order_by) async {
    String _url = API_BASE_URL + "api/ProductReview/review_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pid': pid,
      'start': start.toString(),
      'length': "20",
      'order_by': order_by,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductReviewListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //producctList
  Future<ProductListResModel> getProductOptionList(String name) async {
    String _url = API_BASE_URL + "api/product/list";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'name': name};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //producctDetail
  Future<ProductDetailResModel> getProductDetail(String pid) async {
    String _url = API_BASE_URL + "api/product/detail";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pid': pid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductDetailResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //community list
  Future<CommunityListResModel> communityList(
    String keyword, 
    int page, 
    String topic, 
    String sort, 
    String age
  ) async {
    String _url = API_BASE_URL + "api/community/community_list";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'keyword': keyword,
      'page': page.toString(),
      'topic': topic,
      'sort': sort,
      'age': age,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return CommunityListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //monitor list 얻기
  Future<MonitoringListResModel> monitoringList(int page) async {
    String _url = API_BASE_URL + "api/monitor/monitor_list2";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitoringListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //상품 좋아요
  Future<DefaultResModel> productLike(String pid) async {
    String _url = API_BASE_URL + "api/product/like";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pid': pid,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모나터링보관
  Future<DefaultResModel> monitoringSave() async {
    String _url = API_BASE_URL + "api/monitor/save";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'height': monitoringData!.height!,
      'weight': monitoringData!.weight!,
      'nutrition': monitoringData!.nutrition!,
      'sleep_at_night': monitoringData!.sleep_at_night!,
      'sleep_at_lunch': monitoringData!.sleep_at_lunch!,
      'language': monitoringData!.language!,
      'sociability': monitoringData!.sociability!,
      'work_out': monitoringData!.work_out!,
      'symptom_list': json.encode(monitoringData!.symptom_list!),
      // 'breakfast': json.encode(monitoringData!.foodAddList1),
      // 'lunch': json.encode(monitoringData!.foodAddList2),
      // 'snack': json.encode(monitoringData!.foodAddList3),
      // 'dinner': json.encode(monitoringData!.foodAddList4),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모나터링보관2
  Future<DefaultResModel> monitoringSaveV2(String tempLoca) async {
    String _url = API_BASE_URL + "api/monitor/save";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'body_temp' : monitoringData!.bodyTemp!,
      'body_loca' : tempLoca,
      'sleep_at_night': monitoringData!.sleep_at_night!,
      'sleep_at_lunch': monitoringData!.sleep_at_lunch!,
      'symptom_list': json.encode(monitoringData!.symptom_list!),
      // 'breakfast': json.encode(monitoringData!.foodAddList1),
      // 'lunch': json.encode(monitoringData!.foodAddList2),
      // 'snack': json.encode(monitoringData!.foodAddList3),
      // 'dinner': json.encode(monitoringData!.foodAddList4),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //1분 무료진단 결과 얻기
  Future<FreeTestResModel> freeTest(String dad_height, String mom_height, String gender, String height, String weight, String birth, String sleep_time_launch, String sleep_time_night) async {
    String _url = API_BASE_URL + "api/Common/free_test";
    Map<String, String> body = {
      'dad_height': dad_height,
      'mom_height': mom_height,
      'gender': gender,
      'height': height,
      'weight': weight,
      'birth': birth,
      'sleep_time_launch': sleep_time_launch,
      'sleep_time_night': sleep_time_night,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FreeTestResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈케어 배너리스트 얻기
  Future<HomeCareBannerResModel> homecareBannerList(String category) async {
    String _url = API_BASE_URL + "api/Product/homecare_banner_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'category': category,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeCareBannerResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈케어 홈 데이터
  Future<HomeCareDataResModel> homecareDataInfo(String category) async {
    String _url = API_BASE_URL + "api/Product/homecare_home_data";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'category': category,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeCareDataResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈케어 스토어 데이터
  Future<HomeCareListResModel> homecareStoreData(String category_1, String category_2) async {
    String _url = API_BASE_URL + "api/Product/store_home_data";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'category_1': category_1,
      'category_2': category_2,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeCareListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모니터링 음식 카테고리 리스트
  Future<CategoryListResModel> foodCategoryList() async {
    String _url = API_BASE_URL + "api/Monitor2/food_category_list";
    Map<String, String> body = {};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return CategoryListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모니터링 음식 리스트
  Future<FoodListResModel> foodList(String category, String sub_category) async {
    String _url = API_BASE_URL + "api/Monitor2/food_list";
    Map<String, String> body = {
      'category': category,
      'sub_category': sub_category,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FoodListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<FoodListResModel> getFoodAll() async {
    String _url = API_BASE_URL + "api/Monitor2/food_all_list";
    Map<String, String> body = {
      'category': "",
      'sub_category': "",
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FoodListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  Future<FoodListMonitorModel> foodSelectList(String date) async {
    String _url = API_BASE_URL + "api/Monitor2/past_food_list";
    Map<String, String> body = {
      'patients_id': gSelChildInfo!.id!,
      'date': date,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FoodListMonitorModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      print(response.statusCode);
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모니터링 음식 리스트
  Future<FoodItemListModel> foodWriteList() async {
    String _url = API_BASE_URL + "api/monitoring/get_food_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FoodItemListModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //장바구니 추가
  Future<BasketAddResModel> addBakset(String pid, String opt_list) async {
    String _url = API_BASE_URL + "api/Product/basket_put_in";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pid': pid,
      'opt_list': opt_list,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return BasketAddResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //장바구니 갯수 변경
  Future<DefaultResModel> changeBakset(String basket_id, int count) async {
    String _url = API_BASE_URL + "api/Product/basket_change";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'basket_id': basket_id,
      'count': count.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모니터링 기록
  Future<MonitoringRecordResModel> monitoringRecord(String monitoring_time,String height, String weight, String nutrition, String sleep_at_night, String sleep_at_lunch, String symptom_list, String language, String sociability, String work_out, String breakfast, String lunch, String snack, String dinner, String uid) async {
    String _url = API_BASE_URL + "api/Monitor2/save";
    if (uid == "") {
      Map<String, String> body = {
        'access_token': gUserInfo!.accessToken!,
        'monitoring_time': monitoring_time,
        'height': height,
        'weight': weight,
        'nutrition': nutrition,
        'sleep_at_night': sleep_at_night,
        'sleep_at_lunch': sleep_at_lunch,
        'symptom_list': symptom_list,
        'language': language,
        'sociability': sociability,
        'work_out': work_out,
        'breakfast' : breakfast,
        'lunch' : lunch,
        'snack' : snack,
        'dinner' : dinner,
      };
      Uri myUri = Uri.parse(_url);
      final response = await http.post(myUri, body: body);
      if (response.statusCode == 200) {
        return MonitoringRecordResModel.fromJson(json.decode(response.body));
      } else {
        // If that call was not successful, throw an error.
        showToast(LanguageService.trans("server_fail"));
        throw Exception(LanguageService.trans("server_fail"));
      }
    } else {
      Map<String, String> body = {
        'access_token': gUserInfo!.accessToken!,
        'monitoring_time': monitoring_time,
        'height': height,
        'weight': weight,
        'nutrition': nutrition,
        'sleep_at_night': sleep_at_night,
        'sleep_at_lunch': sleep_at_lunch,
        'symptom_list': symptom_list,
        'language': language,
        'sociability': sociability,
        'work_out': work_out,
        'breakfast' : breakfast,
        'lunch' : lunch,
        'snack' : snack,
        'dinner' : dinner,
        'uid': uid,
      };
      Uri myUri = Uri.parse(_url);
      final response = await http.post(myUri, body: body);
      if (response.statusCode == 200) {
        return MonitoringRecordResModel.fromJson(json.decode(response.body));
      } else {
        // If that call was not successful, throw an error.
        showToast(LanguageService.trans("server_fail"));
        throw Exception(LanguageService.trans("server_fail"));
      }
    }
  }

  Future<MonitoringRecordResModel> monitoringBodyRecord(String monitoring_time,String height, String weight, String point) async {
    String _url = API_BASE_URL + "api/Monitor2/save";
      Map<String, String> body = {
        'access_token': gUserInfo!.accessToken!,
        'monitoring_time': monitoring_time,
        'height': height,
        'weight': weight,
        'quiz_score': point,
      };
      Uri myUri = Uri.parse(_url);
      final response = await http.post(myUri, body: body);
      if (response.statusCode == 200) {
        return MonitoringRecordResModel.fromJson(json.decode(response.body));
      } else {
        // If that call was not successful, throw an error.
        showToast(LanguageService.trans("server_fail"));
        throw Exception(LanguageService.trans("server_fail"));
      }
  }

  //성장노트 저장하기
  Future<DefaultResModel> monitoringRecord2(String temperature, String temp_location, String sleep_at_night, String sleep_at_lunch, String symptom_list, String normal_score, String control_score) async {
    String _url = API_BASE_URL + "api/monitoring/save_growth_note";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'temperature' : temperature,
      'location' : temp_location,
      'sleep_at_night': sleep_at_night,
      'sleep_at_lunch': sleep_at_lunch,
      'symptom_list': symptom_list,
      'normal_score' : normal_score,
      'control_score' : control_score,
    };
    print(body);
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      print("success");
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //toparea 가져오기
  Future<TopAreaModel> getToparea() async {
    String _url = API_BASE_URL + "api/monitoring/get_home_status";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return TopAreaModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  // 성장노트 가져오기
  Future<NoteProfileModel> getMonitoringStatus() async {
    String _url = API_BASE_URL + "api/monitoring/get_monitoring_status";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return NoteProfileModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //솔루션 가져오기
  Future<SolutionAreaModel> getSolutionArea() async {
    String _url = API_BASE_URL + "api/monitoring/get_solution";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return SolutionAreaModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //체온 그래프 가져오기
  Future<TempGraphModel> getTempGraph(String date) async {
    String _url = API_BASE_URL + "api/monitoring/get_temperature_graph";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'start_date': date,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return TempGraphModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //수면 그래프 가져오기
  Future<SleepGraphModel> getSleepGraph(String date) async {
    String _url = API_BASE_URL + "api/monitoring/get_sleep_graph";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'start_date': date,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return SleepGraphModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //영양 리스트 가져오기
  Future<FoodListModel> getFoodList() async {
    String _url = API_BASE_URL + "api/monitoring/get_meal_image";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FoodListModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //그래프 신장 v2
  Future<HomeGraphTallResModel> monitorTallv2() async {
    String _url = API_BASE_URL + "api/monitoring/get_tall_graph";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeGraphTallResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //그래프 신장 v2
  Future<HomeGraphWeightResModel> monitorWeightv2() async {
    String _url = API_BASE_URL + "api/monitoring/get_weight_graph";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeGraphWeightResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모니터링 두뇌 질문 리스트
  Future<BrainQuizListResModel> monitoringBrainList() async {
    String _url = API_BASE_URL + "api/Monitor2/brain_quiz_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return BrainQuizListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모니터링 결과
  Future<MonitoringResultResModel> monitoringResult(String date) async {
    String _url = API_BASE_URL + "api/Monitor2/get_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'date': date,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitoringResultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //내 리뷰리스트
  Future<MyReviewListResModel> myReviewList(int status, int start) async {
    String _url = API_BASE_URL + "api/ProductReview/review_products";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'status': status.toString(),
      'start': start.toString(),
      'length': "20",
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MyReviewListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //찜한 상품 목록 얻기
  Future<ProductLikeListResModel> productLikeList(String keyword, String name, String only_like, String order_by, int page, String tags) async {
    String _url = API_BASE_URL + "api/Product/get_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'keyword': keyword,
      'name': name,
      'only_like': only_like,
      'order_by': order_by,
      'page': page.toString(),
      'tags': tags,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductLikeListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //상품 목록 얻기
  Future<ProductLikeListResModel> productLikeList1(String category_1, String category_2, String category_3, String keyword, String name, String only_like, String order_by, int page, String tags) async {
    String _url = API_BASE_URL + "api/Product/get_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'category_1': category_1,
      'category_2': category_2,
      'category_3': category_3,
      'keyword': keyword,
      'name': name,
      'only_like': only_like,
      'order_by': order_by,
      'page': page.toString(),
      'tags': tags,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ProductLikeListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 발달 리포트
  Future<HomeMonitorResModel> homeMonitorInfo() async {
    String _url = API_BASE_URL + "api/Monitor2/home_data";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeMonitorResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //장바구니 목록얻기
  Future<BasketListResModel> getBasketList() async {
    String _url = API_BASE_URL + "api/Product/basket_list";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return BasketListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //장바구니 삭제
  Future<DefaultResModel> basketDelete(String basket_ids) async {
    String _url = API_BASE_URL + "api/Product/basket_delete";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'basket_ids': basket_ids};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //배송지 주소 변경
  Future<DefaultResModel> changeDeliverAddress(String postcode, String address, String address_detail, String main_yn) async {
    String _url = API_BASE_URL + "api/Product/change_deliver_address";

    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'postcode': postcode, 'address': address, 'address_detail': address_detail, 'main_yn': main_yn};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //포인트 추가 삭제
  Future<OrderStartResModel> pointChange(String type, String point) async {
    String _url = API_BASE_URL + "api/User/add_point";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'type' : type,
      'point' : point,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return OrderStartResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //order추가 - 주문하기
  Future<OrderStartResModel> orderStart(String pdt_info, String point, String pay_method, String deliver_address) async {
    String _url = API_BASE_URL + "api/Order/start";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'pdt_info': pdt_info,
      'point': point,
      'pay_method': pay_method,
      'deliver_address': deliver_address,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return OrderStartResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //주문내역 목록얻기
  Future<OrderListResModel> getUserOrders(String start, String length) async {
    String _url = API_BASE_URL + "api/Order/get_list";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'start': start, 'length': length};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return OrderListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //주문 상세
  Future<OrderDetailResModel> getOrderDetail(String orderId) async {
    String _url = API_BASE_URL + "api/Order/detail";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'order_id': orderId,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return OrderDetailResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //주문 취소
  Future<DefaultResModel> cancelOrder(String orderId) async {
    String _url = API_BASE_URL + "api/Order/cancel_order";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'order_id': orderId,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //구매 확정
  Future<DefaultResModel> changeOrderStatus(String orderId, String status) async {
    String _url = API_BASE_URL + "api/Order/change_status";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'order_id': orderId,
      'status': status,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //교환반품 신청
  Future<DefaultResModel> requestExchangeReturn(String orderId, String action, String problem, String problem_detail, String plist, String product_addr, String deliver_addr) async {
    String _url = API_BASE_URL + "api/Order/exchange_o_return";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'order_id': orderId,
      'action': action,
      'problem': problem,
      'problem_detail': problem_detail,
      'plist': plist,
      'product_addr': product_addr,
      'deliver_addr': deliver_addr,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //맞춤검사 질문 리스트 신청
  Future<ChatQuizListResModel> getChatQuizList() async {
    String _url = API_BASE_URL + "api/Monitor2/m_chat_quiz_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ChatQuizListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }
  //맞춤검사 결과
  Future<CheckChatResModel> checkChat(String chat_info) async {
    String _url = API_BASE_URL + "api/Monitor2/check_m_chat";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'chat_info': chat_info,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return CheckChatResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //영유아 검사
  Future<ChildQuizListResModel> getChildQuizList() async {
    String _url = API_BASE_URL + "api/Monitor2/m_child_quiz_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return ChildQuizListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //영유아 검사 결과 전송
  Future<CheckChildQuizModel> checkChildQuiz( String quiz_id, String quiz_result,String birth_code) async {
    String _url = API_BASE_URL + "api/Monitor2/m_child_quiz_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'patient_id': gSelChildInfo!.id!,
      'quiz_id': quiz_id,
      'quiz_result': quiz_result,
      'quiz_code' : birth_code,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return CheckChildQuizModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //mbti 검사
  Future<MbtiQuizListResModel> getMbtiQuizList() async {
    String _url = API_BASE_URL + "api/Monitor2/mbti_quiz_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MbtiQuizListResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //mbti 검사 결과 저장
  Future<MbtiQuizSendResModel> getMbtiSendResult(String result_list, String mbti) async {
    String _url = API_BASE_URL + "api/Monitor2/mtbi_quiz_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'patient_id': gSelChildInfo!.id!,
      'mbti_result_list' : result_list,
      'mbti_result': mbti,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MbtiQuizSendResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //test2 퀴즈 불러오기
  Future<Test2QuizListModel> getTest2QuizList(String quizName) async {
    String _url = API_BASE_URL + "api/Monitor2/test2_quiz_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'quiz_id' : quizName,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return Test2QuizListModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //test4 퀴즈 불러오기
  Future<Test4QuizModel> getTest4QuizList(String quizName) async {
    String _url = API_BASE_URL + "api/Monitor2/test4_quiz_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'quiz_id' : quizName,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return Test4QuizModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //test 결과 가져오기
  Future<TestQuizResultModel> getTestQuizResult(String quizName, String quizResult) async {
    String _url = API_BASE_URL + "api/Monitor2/test_quiz_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'quiz_id' : quizName,
      'quiz_result' : quizResult,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return TestQuizResultModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //부모양육태도 결과 가져오기
  // Future<TestQuizResultModel> getTestQuizResult43(String quizName, String quizResult) async {
  //   String _url = API_BASE_URL + "api/monitoring/save_parenting_style_test";
  //   Map<String, String> body = {
  //     'access_token': gUserInfo!.accessToken!,
  //     'answer' : quizResult,
  //   };
  //   Uri myUri = Uri.parse(_url);
  //   final response = await http.post(myUri, body: body);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return TestQuizResultModel.fromJson(json.decode(response.body));
  //   } else {
  //     // If that call was not successful, throw an error.
  //     showToast(LanguageService.trans("server_fail"));
  //     throw Exception(LanguageService.trans("server_fail"));
  //   }
  // }

  //발달영역 모니터링 문제
  Future<MonitoringHealthListModel> getMonitoringHealthList() async {
    String _url = API_BASE_URL + "api/monitoring/get_development_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitoringHealthListModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //생활습관 모니터링 문제
  Future<MonitoringHealthListModel> getMonitoringLifeList2() async {
    String _url = API_BASE_URL + "api/monitoring/get_lifestyle_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitoringHealthListModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //발달영역 모니터링 결과 가져오기
  Future<MonitorHealthResultModel> getMonitoringHealthResult() async {
    String _url = API_BASE_URL + "api/monitoring/get_development_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitorHealthResultModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //생활습관 모니터링 결과 가져오기
  Future<LifeResultModel> getMonitoringLifeResult() async {
    String _url = API_BASE_URL + "api/monitoring/get_lifestyle_result";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return LifeResultModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //발달습관 결과 저장
  Future<DefaultResModel> inputHealthSendResult(String quizNum, String answer) async {
    String _url = API_BASE_URL + "api/monitoring/save_development_monitoring";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'question' : quizNum,
      'answer': answer,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //생활습관 결과 저장
  Future<DefaultResModel> inputLifeSendResult(String quizNum, String answer) async {
    String _url = API_BASE_URL + "api/monitoring/save_lifestyle_monitoring";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'question' : quizNum,
      'answer': answer,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //발달습관 결과 저장
  Future<DefaultResModel> inputBodySendResult(String tall, String weight, String score) async {
    String _url = API_BASE_URL + "api/monitoring/save_health_monitoring";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'tall' : tall,
      'weight': weight,
      'score': score,
    };
    Uri myUri = Uri.parse(_url);
    print(body);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //회원탈퇴
  Future<DefaultResModel> userExit() async {
    String _url = API_BASE_URL + "api/user/withdrawal";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //포인트 이력
  Future<PointHisResModel> pointHistory(int page) async {
    String _url = API_BASE_URL + "api/User/point_history";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return PointHisResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw  an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 그래프 신장
  Future<HomeGraphTallResModel> homeGraphTall() async {
    String _url = API_BASE_URL + "api/Monitor2/home_graph_tall";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeGraphTallResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 그래프 체중
  Future<HomeGraphWeightResModel> homeGraphWeight() async {
    String _url = API_BASE_URL + "api/Monitor2/home_graph_weight";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeGraphWeightResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 그래프 생활습관
  Future<HomeGraphLifeStyleResModel> homeGraphLifeStyle(String startDate) async {
    String _url = API_BASE_URL + "api/Monitor2/home_graph_lifestyle";
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'start_date': startDate};
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeGraphLifeStyleResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 그래프 생활습관
  Future<HomeGraphLifeStyleResModel> homeGraphLifeStyle1(String month) async {
    String _url = API_BASE_URL + "api/Monitor2/home_graph_lifestyle2";
    print(gUserInfo!.accessToken!);
    Map<String, String> body = {'access_token': gUserInfo!.accessToken!, 'month': month};
    log(gUserInfo!.accessToken!);
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeGraphLifeStyleResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //모니터링 리스트
  Future<MonitoringAllResModel> monitoringAllList(int page) async {
    String _url = API_BASE_URL + "api/Monitor2/get_list";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
    };
    log(gUserInfo!.accessToken!);
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return MonitoringAllResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 그래프 질병
  Future<HOmeSymptomGraphResModel> homeDiseaseGraph(String date) async {
    String _url = API_BASE_URL + "api/Monitor2/home_graph_symptom";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'start_date': date,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HOmeSymptomGraphResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 그래프 질병
  Future<HomeVaccineResModel> homehealthVaccine() async {
    String _url = API_BASE_URL + "api/Monitor2/home_health_vaccine";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeVaccineResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //질병 완쾌
  Future<DefaultResModel> symptomComplete(String symptom_id) async {
    String _url = API_BASE_URL + "api/Monitor2/symptom_complete";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'symptom_id': symptom_id,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //홈 두뇌데이터 정보 얻기
  Future<HomeBrainResModel> homeBraninInfo(String category) async {
    String _url = API_BASE_URL + "api/Monitor2/home_brain";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'category': category,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return HomeBrainResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //닉네임 중복 체크
  Future<DuplicateResModel> checkNickname(String nickname) async {
    String _url = API_BASE_URL + "api/user/check_nickname";
    Map<String, String> body = {
      'nickname': nickname,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DuplicateResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //아이디 중복 체크
  Future<DuplicateResModel> checkLoginId(String _id) async {
    String _url = API_BASE_URL + "api/user/check_login_id";
    Map<String, String> body = {
      'login_id': _id,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DuplicateResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //가족력 수정하기
  Future<DefaultResModel> changeFamilyHistory(String familyHistory) async {
    String _url = API_BASE_URL + "api/user/change_family_history";
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'family_history': familyHistory,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return DefaultResModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //내 게시글 보기
  Future<CommunityListResModel> getMyPosts(int page) async {
    String _url = API_BASE_URL + "api/user/community_list";
    
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if(response.statusCode == 200) {
      return CommunityListResModel.fromJson(json.decode(response.body));
    } else {
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //내 좋아요 게시글 보기
  Future<CommunityListResModel> getMyLikePosts(int page) async {
    String _url = API_BASE_URL + "api/user/community_like_list";

    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
      'page': page.toString(),
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if(response.statusCode == 200) {
      return CommunityListResModel.fromJson(json.decode(response.body));
    } else {
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }

  //식습관 결과 가져오기
  Future<FoodHabitModel> getFoodHabitResults() async {
    String _url = API_BASE_URL + "api/EXAMPLE/api"; //TODO API_URL수정하기
    Map<String, String> body = {
      'access_token': gUserInfo!.accessToken!,
    };
    Uri myUri = Uri.parse(_url);
    final response = await http.post(myUri, body: body);
    if (response.statusCode == 200) {
      return FoodHabitModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      showToast(LanguageService.trans("server_fail"));
      throw Exception(LanguageService.trans("server_fail"));
    }
  }
}
