import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/monitor_day_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_checkbox1.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_input.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/selector.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date1.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/provider/global_provider.dart';
import 'package:ourdoctor/provider/old_food_list_provider.dart';
import 'package:provider/provider.dart';

import 'monitoring_result2.dart';

class MonitoringMain2 extends StatefulWidget {
  const MonitoringMain2({Key? key}) : super(key: key);

  @override
  State<MonitoringMain2> createState() => _MonitoringMain2State();
}

class _MonitoringMain2State extends BaseState<MonitoringMain2> {
  HttpService httpService = new HttpService();
  bool isValid = false;

  ScrollController controller = ScrollController();
  TextEditingController bodyTempCont = TextEditingController();
  ScrollController _listController = ScrollController();
  List<TextEditingController> directInputController = [];
  List<TextEditingController> recordTimeControllerList = [];
  List<TextEditingController> surgeryControllerList = [];
  List<TextEditingController> surgeryDateControllerList = [];


  String mTemp = "0";
  Color borderColor = AppColor_Selector_Border;
  int locaTemp = 0;
  int hasDisease = 2;
  int disease_count = 1;
  List<String> imageList = [];
  final imagePicker = ImagePicker();
  String profileImage = "";
  String askImage = "";

  //질병
  int selSymtomidx = 0;
  List<String> category = [];
  String initCategory = "";
  List<List<String>> symptomList = [];
  List<List<String>> categoryList = [];
  List<String> initSymptomList = [];
  List<String> initCategoryList = [];
  List<String> symptom = [];
  String initSymptom = "";
  List<int> hasphotoList = [];
  List<int> surgeryList = [];
  int cur_symptom = 0;
  String surgery_date = "";
  String surgery_name = "";


  String sleep_night_hour = "0시간";
  String sleep_night_min = "0분";
  String sleep_launch_hour = "0시간";
  String sleep_launch_min = "0분";
  List<String> timeList1 = []; //시간
  List<String> timeList2 = []; //분
  List<String> timeList3 = []; //밤잠 시간

  List<String> nutritionalStatus = <String>[
    LanguageService.trans("morning1"),
    LanguageService.trans("lunch"),
    LanguageService.trans("snack"),
    LanguageService.trans("dinner"),
  ];

  List<String> foodString = ["편식하는 음식 없이 골고루 먹었나요?", "식사 시 김치를 제외한 다른 채소반찬을 1가지 이상 먹었나요?", "아침식사를 먹었나요?", "음식을 꼭꼭 씹어 먹었나요?",
  "미디어나 보상없이 식사에 잘 집중해서 먹었나요?", "단 음식(사탕, 과자, 초콜릿, 아이스크림 등)을 하루에 한번 이상 먹었나요?", "인스턴트/패스트푸드나 가공식품을 일주일에 3번 이상 먹었나요?"];
  List<int> foodScore = [0,0,0,0,0,0];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 8; i++) {
      if (i < 7) {
        timeList1.add("$i시간");
      } else {
        timeList1.add("$i시간 이상");
      }
    }

    for (var i = 0; i < 14; i++) {
      if (i < 13) {
        timeList3.add("$i시간");
      } else {
        timeList3.add("$i시간 이상");
      }
    }

    for (var i = 0; i < 60; i += 30) {
      timeList2.add(i.toString() + "분");
    }

    if (monitoringData == null ||
        (monitoringData!.height == "" &&
            monitoringData!.weight == "" &&
            monitoringData!.nutrition == "0,0,0,0") &&
            monitoringData!.sleep_at_night == "" &&
            monitoringData!.sleep_at_lunch == "" &&
            monitoringData!.language == "" &&
            monitoringData!.sociability == "" &&
            monitoringData!.work_out == "") {
      //새로 추가
      monitoringData = MonitoringDayDto();

      monitoringData!.sleep_at_night = "";
      monitoringData!.sleep_at_lunch = "";
      monitoringData!.language = "";
      monitoringData!.sociability = "";
      monitoringData!.work_out = "";

      if (monitoringData!.symptom_list == null) {
        monitoringData!.symptom_list = [];
      } else {
        monitoringData!.symptom_list!.clear();
      }

      for (int i = 0; i < gSymptomList!.length; i++) {
        initCategoryList.add(gSymptomList!.elementAt(i).category!);
      }
      initCategoryList.add("직접입력");
      directInputController.add(TextEditingController(text: ""));
      if (initCategoryList.isNotEmpty) {
        //category = categoryList[0];
        initCategory = initCategoryList[0];
        //getSymtomList();
        symptomList.clear();
        for (int i = 0; i < gSymptomList!.length; i++) {
          if (initCategory == gSymptomList![i].category) {
            initSymptomList = gSymptomList![i].list!;
          }
        }
        if (initSymptomList.isNotEmpty) {
          //symptom = symptomList[0];
          initSymptom = initSymptomList[0];
        }
        setState(() {});
      }
      monitoringData!.foodAddList1!.clear();
      monitoringData!.foodAddList2!.clear();
      monitoringData!.foodAddList3!.clear();
      monitoringData!.foodAddList4!.clear();
      addSymptom();
    } else {
      int sleep_at_lunch = int.parse(monitoringData!.sleep_at_lunch! == ""
          ? "0"
          : monitoringData!.sleep_at_lunch!);
      int sleep_at_night = int.parse(monitoringData!.sleep_at_night! == ""
          ? "0"
          : monitoringData!.sleep_at_night!);

      if (sleep_at_night >= (60 * 13)) {
        sleep_night_hour = (sleep_at_night ~/ 60).toString() + "시간 이상";
      } else {
        sleep_night_hour = (sleep_at_night ~/ 60).toString() + "시간";
      }

      if (sleep_at_lunch >= (60 * 7)) {
        sleep_launch_hour = (sleep_at_lunch ~/ 60).toString() + "시간 이상";
      } else {
        sleep_launch_hour = (sleep_at_lunch ~/ 60).toString() + "시간";
      }

      // sleep_night_hour = (sleep_at_night ~/ 60).toString() + "시간";
      sleep_night_min = (sleep_at_night % 60).toString() + "분";
      // sleep_launch_hour = (sleep_at_lunch ~/ 60).toString() + "시간";
      sleep_launch_min = (sleep_at_lunch % 60).toString() + "분";

      for (int i = 0; i < gSymptomList!.length; i++) {
        initCategoryList.add(gSymptomList!.elementAt(i).category!);
      }
      initCategoryList.add("직접입력");
      directInputController.add(TextEditingController(text: ""));
      if (initCategoryList.isNotEmpty) {
        //category = categoryList[0];
        initCategory = initCategoryList[0];
        //getSymtomList();
        symptomList.clear();
        for (int i = 0; i < gSymptomList!.length; i++) {
          if (initCategory == gSymptomList![i].category) {
            initSymptomList = gSymptomList![i].list!;
          }
        }
        if (initSymptomList.isNotEmpty) {
          //symptom = symptomList[0];
          initSymptom = initSymptomList[0];
        }
        setState(() {});
      }

      if (monitoringData!.symptom_list!.isNotEmpty) {
        // hasDisease = 1;
        for (int i = 0; i < monitoringData!.symptom_list!.length; i++) {
          MonitoringSymptomDto item =
          monitoringData!.symptom_list!.elementAt(i);

          MonitoringSymptomDto info = MonitoringSymptomDto();
          info.category = item.category;
          info.symptom = item.symptom;
          info.record_time = item.record_time;
          info.surgey_name = item.surgey_name;
          info.surgey_time = item.surgey_time;
          info.medication = item.medication;

          recordTimeControllerList
              .add(TextEditingController(text: info.record_time));
          surgeryControllerList
              .add(TextEditingController(text: info.surgey_name));
          surgeryDateControllerList
              .add(TextEditingController(text: info.surgey_time));
          if (info.category == "직접입력") {
            directInputController
                .add(TextEditingController(text: info.symptom));
          } else {
            directInputController.add(TextEditingController());
          }

          if (info.medication!.contains("img_photo_default")) {
            info.medication = "";
          }
          hasphotoList.add(info.medication!.isEmpty ? 2 : 1);
          imageList.add(info.medication!);

          if (item.surgey_name!.isEmpty) {
            surgeryList.add(2);
          } else {
            surgeryList.add(1);
          }

          category.add(item.category!);
          categoryList.add(initCategoryList);
          for (int i = 0; i < gSymptomList!.length; i++) {
            if (item.category == gSymptomList![i].category) {
              symptomList.add(gSymptomList![i].list!);
              //try
              if (!gSymptomList![i].list!.contains(item.symptom)) {
                symptom.add(gSymptomList![i].list![0]);
              } else {
                symptom.add(item.symptom!);
              }
            }
          }
        }
        setState(() {});
      } else {
        hasDisease = 2;
        addSymptom();
      }
    }

    checkValid();
  }

  @override
  void dispose() {
    super.dispose();
    imageList.clear();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void checkValid() {
    isValid = false;
    if(mTemp.isEmpty)mTemp="0";
    if(double.parse(mTemp) <= 32 || double.parse(mTemp) > 42 ) {
      borderColor = Colors.red;
      return;
    } else {
      borderColor = AppColor_Selector_Border;
    }
    if (hasDisease == 1) {
      for (int i = 0; i < monitoringData!.symptom_list!.length; i++) {
        //카테고리 체크
        String? category = monitoringData!.symptom_list![i].category;
        if (category == "") {
          return;
        }
        String? symptom = monitoringData!.symptom_list![i].symptom;
        if (symptom == "") {
          return;
        }
        //질병 체크
        if (category == "직접입력") {
          String? symptom = directInputController[i].text;
          if (symptom == "") {
            return;
          }
        } else {
          String? symptom = monitoringData!.symptom_list![i].symptom;
          if (symptom == "") {
            return;
          }
        }

        //질병 진단 날짜 체크
        String? record_time = monitoringData!.symptom_list![i].record_time;
        if (record_time == "") {
          return;
        }

        //수술/검사 여부
        if (surgeryList[i] == 1) {
          String? surgey_name = monitoringData!.symptom_list![i].surgey_name;
          if (surgey_name == "") {
            return;
          }

          String? surgey_time = monitoringData!.symptom_list![i].surgey_time;
          if (surgey_time == "") {
            return;
          }
        }

        //복약 여부
        if (hasphotoList[i] == 1) {
          String? img = monitoringData!.symptom_list![i].medication;
          if (img == "") {
            return;
          }
        }
      }
    }
    isValid = true;
  }

  scrollDown() {
    controller.animateTo(controller.position.maxScrollExtent + 50,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    setState(() {});
  }

  void getSymtomList() {
    for (int i = 0; i < gSymptomList!.length; i++) {
      if (category[selSymtomidx] == gSymptomList![i].category) {
        symptomList[selSymtomidx] = gSymptomList![i].list!;
      }
    }
    if (symptomList[selSymtomidx].isNotEmpty) {
      symptom[selSymtomidx] = symptomList[selSymtomidx][0];
    }
    setState(() {});
    checkValid();
  }

  void addSymptom() {
    MonitoringSymptomDto info = MonitoringSymptomDto();
    info.category = initCategory;
    info.symptom = initSymptom;
    info.record_time = "";
    info.surgey_name = "";
    info.surgey_time = "";
    info.medication = "";

    monitoringData!.symptom_list!.add(info);

    recordTimeControllerList.add(TextEditingController());
    surgeryControllerList.add(TextEditingController());
    surgeryDateControllerList.add(TextEditingController());
    directInputController.add(TextEditingController());
    imageList.add("");
    surgeryList.add(2);
    hasphotoList.add(2);
    symptom.add(initSymptom);
    category.add(initCategory);
    symptomList.add(initSymptomList);
    categoryList.add(initCategoryList);
    checkValid();
    setState(() {});
  }

  void delSymptom(int index) {
    disease_count = disease_count - 1;
    monitoringData!.symptom_list!.removeAt(index);

    recordTimeControllerList.removeAt(index);
    surgeryControllerList.removeAt(index);
    surgeryDateControllerList.removeAt(index);
    directInputController.removeAt(index);
    imageList.removeAt(index);
    surgeryList.removeAt(index);
    hasphotoList.removeAt(index);
    category.removeAt(index);
    symptom.removeAt(index);
    symptomList.removeAt(index);
    categoryList.removeAt(index);
    checkValid();
    setState(() {});
  }

  Future<void> showBirthdayDlg(index) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var _result = await showDialog(
        context: context, builder: (_) => SelectDate1Dialog(type: 1));
    if (_result != null && _result != "") {
      // birthInputController.text = birth;
      monitoringData!.symptom_list![index].record_time = _result;
      recordTimeControllerList[index].text = _result;
      checkValid();
    }
  }

  Future<void> showSurgerydateDlg(index) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var _result = await showDialog(
        context: context, builder: (_) => SelectDate1Dialog(type: 2));
    if (_result != null && _result != "") {
      surgery_date = _result;
      surgeryDateControllerList[index].text = surgery_date;
      monitoringData!.symptom_list![index].surgey_time = _result;
      checkValid();
    }
  }

  reorderPictures(int prevIdx, int currIdx) {
    if(currIdx>prevIdx) {
      currIdx-=1;
    }
    final items = imageList.removeAt(prevIdx);
    imageList.insert(currIdx, items);
  }

  void onSelectPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(
              onGallery: getGalleryImageAndCrop,
              onCamera: getCameraImageAndCrop,
              onprofileImage: getProfileImage, code: 1);
        });
  }

  void getGalleryImageAndCrop() async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image == null) return;

    var croppedImage = await cropImage(image.path);
    if (croppedImage != null) {
      uploadFile(croppedImage);
    }
  }

  void getCameraImageAndCrop() async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.camera);
    if (image == null) return;

    var croppedImage = await cropImage(image.path);
    if (croppedImage != null) {
      uploadFile(croppedImage);
    }
  }

  void getProfileImage() async {
    Navigator.pop(context);
    if (profileImage.isNotEmpty) {
      profileImage = "";
    }
  }

  Future<File?> cropImage(String imagePath) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: imagePath,
      maxWidth: 700,
      maxHeight: 700,
      compressQuality: 70,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: LanguageService.trans('image_crop'),
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    return croppedFile;
  }

  // //파일 업로드
  void uploadFile(File uploadFile) {
    setState(() {
      isLoading = true;
    });
    Future<FileUploadResModel> uploadInfo = httpService.uploadFile(uploadFile);
    uploadInfo.then((FileUploadResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        askImage = value.data!.fileUrl!;
        monitoringData!.symptom_list![cur_symptom].medication = askImage;
        imageList[cur_symptom] = askImage;
        imageList.add(value.data!.fileUrl!);
        setState(() {});
        checkValid();
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          // Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  void saveMonitor() {
    // mTemp;
    // locaTemp.toString();

    String symptom_list = ""; //질병데이터 json 리스트(예시대로 올려야 함)

    //sleep time carculatate
    final lunch_hour;
    final launch_min;
    if (sleep_launch_hour.contains("이상")) {
      lunch_hour = int.parse(sleep_launch_hour.replaceAll("시간 이상", ""));
      sleep_launch_min = "0분";
      launch_min = int.parse(sleep_launch_min.replaceAll("분", ""));
    } else {
      lunch_hour = int.parse(sleep_launch_hour.replaceAll("시간", ""));
      launch_min = int.parse(sleep_launch_min.replaceAll("분", ""));
    }

    // int launch_hour = int.parse(sleep_launch_hour.replaceAll("시간", ""));

    final night_hour;
    final night_min;
    if (sleep_night_hour.contains("이상")) {
      night_hour = int.parse(sleep_night_hour.replaceAll("시간 이상", ""));
      sleep_night_min = "0분";
      night_min = int.parse(sleep_night_min.replaceAll("분", ""));
    } else {
      night_hour = int.parse(sleep_night_hour.replaceAll("시간", ""));
      night_min = int.parse(sleep_night_min.replaceAll("분", ""));
    }
    // int night_hour = int.parse(sleep_night_hour.replaceAll("시간", ""));
    int sleep_launch = lunch_hour * 60 + launch_min;
    int sleep_night = night_hour * 60 + night_min;

    //symptom
    if (hasDisease == 1) {
      List<Map<String, String>> symptomList = [];
      for (int i = 0; i < monitoringData!.symptom_list!.length; i++) {
        //카테고리
        String category = monitoringData!.symptom_list![i].category!;

        //질병
        String symptom = "";
        if (category == "직접입력") {
          symptom = directInputController[i].text;
        } else {
          symptom = monitoringData!.symptom_list![i].symptom!;
        }

        //질병 진단 날짜 체크
        String record_time = monitoringData!.symptom_list![i].record_time!;

        //수술/검사 여부
        String surgey_name = "";
        String surgey_time = "";
        if (surgeryList[i] == 1) {
          surgey_name = monitoringData!.symptom_list![i].surgey_name!;
          surgey_time = monitoringData!.symptom_list![i].surgey_time!;
        }

        //복약 여부
        String img = "";
        if (hasphotoList[i] == 1) {
          img = monitoringData!.symptom_list![i].medication!;
          File file = File(img);
          img = file.path.split('/').last;
        }

        Map<String, String> info = {
          'category': category,
          'symptom': symptom,
          'record_time': record_time,
          'surgery_name': surgey_name,
          'surgery_time': surgey_time,
          'medication': img,
        };
        symptomList.add(info);
      }
      symptom_list = json.encode(symptomList);

    }

    int normal_score = 0;
    int control_score = foodScore[4] + foodScore[5];
    for (int i = 0; i < 4; i++) {
      normal_score += foodScore[i];
    }

    String loca = locaTemp ==0 ? "귀": "이마";
    Future<DefaultResModel> info = httpService.monitoringRecord2(mTemp,loca,sleep_night.toString(), sleep_launch.toString(), symptom_list, normal_score.toString(),control_score.toString());
    info.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast("저장되었습니다");
        await Provider.of<GlobalProvider>(context, listen: false).getNoteInfo(context);
        Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => MonitoringResult2(),));
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
    });
  }


  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;

    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleHeader(
                  title: "우아 성장 노트",
                  onBackPressed: onBackPressed,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          H24B(
                            text: "우아 성장 노트",
                            color: AppColor_BlackText,
                            align: TextAlign.left,
                            height: 1.5,
                          ),
                          const SizedBox(height: 20),
                          H16(
                            text: "오늘의 체온을 입력해주세요.",
                            weight: FW.medium,
                            color: AppColor_BlackText,
                            align: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          tempInfo(screenSize),
                          const SizedBox(height: 20),
                          H16(
                            text: "2. 오늘의 영양상태를 기록해주세요.",
                            weight: FW.medium,
                            color: AppColor_BlackText,
                            align: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          foodInfo2(),
                          // foodInfo(),
                          const SizedBox(height: 20),
                          H16(
                            text: "오늘의 수면시간을 기록해주세요.",
                            weight: FW.medium,
                            color: AppColor_BlackText,
                            align: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          sleepInfo(screenSize),
                          const SizedBox(height: 20),
                          H16(
                            text: "오늘의 질병현황을 기록해주세요.",
                            weight: FW.medium,
                            color: AppColor_BlackText,
                            align: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          symptomInfo(),

                        ],
                      ),
                    ),
                  ),
                ),

                MainTextButton(
                  text: "모니터링 결과보기",
                  backgroundColor: AppColor_Primary,
                  style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                  radius: 0,
                  height: 66,
                  disable: !isValid,
                  disableBackground:
                  !isValid ? AppColor_Primary_Disable : Colors.transparent,
                  onPressed: () {
                    if (!isValid) {
                      return;
                    }
                    if(double.parse(mTemp) <= 32 || double.parse(mTemp) > 42) {
                      showToast("체온을 정확하게 입력해주세요");
                      return;
                    }
                    //FIXME : 모니터링 저장
                    saveMonitor();
                  },
                ),
              ],
            )),
    );
  }

  //체온
  Widget tempInfo (screenSize) {
    return SizedBox(
        width: (screenSize.width - 70) / 2,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlineNumInput(
                    controller: bodyTempCont,
                    borderColor: borderColor,
                    keyboardType:
                    const TextInputType
                        .numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction:
                    TextInputAction.done,
                    placeholder: "",
                    onChanged: (text) {
                      mTemp = text;
                      checkValid();
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 10),
                H17(
                  text: LanguageService.trans("°C"),
                  weight: FW.medium,
                  color: AppColor_BlackText,
                ),
              ],
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      locaTemp = 0;
                      checkValid();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          locaTemp == 0
                              ? "assets/ic_option_on.png"
                              : "assets/ic_option_off.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        H16(
                            text: "귀",
                            weight: FW.medium,
                            color: AppColor_BlackText),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  InkWell(
                    onTap: () {
                      locaTemp = 1;
                      checkValid();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          locaTemp == 1
                              ? "assets/ic_option_on.png"
                              : "assets/ic_option_off.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        H16(
                            text: "이마",
                            weight: FW.medium,
                            color: AppColor_BlackText),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  //영양
  Widget foodInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nutritionalStatus.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 3),
            itemBuilder:
                (BuildContext context, int index) {
              return AppCheckboxFill(
                text: nutritionalStatus[index],
                checked: false,
                padding: 10.0,
                withBorder: true,
                onChecked: (checked) => {
                  // Navigator.push(context, SlideRightTransRoute(builder: (context) => CaloriCalcPage())),
                  // onSelect(0, index, checked!),
                },
              );
              // return InkWell(
              //   onTap: () async {
              //     FocusScope.of(context).requestFocus(FocusNode());
              //     // String received = await Navigator.push(context, SlideRightTransRoute(
              //     //         builder: (context) => CaloriCalcPage(type: index)));
              //   },
              //   child: Container(
              //     height: 70,
              //     padding: const EdgeInsets.symmetric(
              //         horizontal: 10.00),
              //     decoration: BoxDecoration(
              //         borderRadius:
              //         BorderRadius.circular(25.0),
              //         color: Provider.of<OldFoodListProvider>(context).kcalList[index].contains('\nkcal')
              //             ? AppColor_Primary
              //             : AppColor_BlackText
              //             .withOpacity(0.05)),
              //     child: Center(
              //       child: H18(
              //         text: Provider.of<OldFoodListProvider>(context).kcalList[index],
              //         weight: FW.medium,
              //         maxLine: 3,
              //         color: Provider.of<OldFoodListProvider>(context).kcalList[index].contains('kcal')
              //             ? AppColor_White
              //             : AppColor_BlackText
              //             .withOpacity(0.5),
              //       ),
              //     ),
              //   ),
              // );
            }),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget foodInfo2() {
    return Container(
        height: 320,
        width: 400,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: AppColor_Light_Gray),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: foodScore.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    if (foodScore[index] == 0){
                      foodScore[index] = 1;
                    } else {
                      foodScore[index] = 0;
                    }
                    setState(() {});
                  },
                  child: Row(children: [
                    Image.asset(
                      foodScore[index] == 0 ? "assets/ic_radio_off.png"
                          :"assets/ic_radio_on.png",
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 250,
                      child: H16(
                        text: foodString[index],
                        weight: FW.regular,
                        maxLine: 3,
                        align: TextAlign.start,
                      ),
                    )
                  ]),
                ),
                const SizedBox(height: 18),
              ],
            );
          },
        ));
  }

  //수면
  Widget sleepInfo(screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: H16(
              text: "낮잠 수면 시간",
              weight: FW.medium,
              color: AppColor_BlackText,
              align: TextAlign.start),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: (screenSize.width - 70) / 2,
              child: SelectorBox(
                  selectedCategory: sleep_launch_hour,
                  categoryList: timeList1,
                  onSelect: (selectedCategory) {
                    setState(() {
                      if (sleep_launch_hour ==
                          timeList1[
                          timeList1.length - 1]) {
                        sleep_launch_hour =
                        selectedCategory!
                            .split(" ")[0];
                      } else {
                        sleep_launch_hour =
                        selectedCategory!;
                      }
                      checkValid();
                      scrollDown();
                      //getDistrictList();
                    });
                  },
                  hint: "시간"),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (screenSize.width - 70) / 2,
              child: SelectorBox(
                  selectedCategory: sleep_launch_min,
                  categoryList: timeList2,
                  onSelect: (selectedCategory) {
                    setState(() {
                      sleep_launch_min =
                      selectedCategory!;
                      checkValid();
                      //getDistrictList();
                    });
                  },
                  hint: "분"),
            ),
          ],
        ),
        const SizedBox(height: 35),
        H16(
            text: "밤잠 수면 시간",
            weight: FW.medium,
            color: AppColor_BlackText,
            align: TextAlign.start),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: (screenSize.width - 70) / 2,
              child: SelectorBox(
                  selectedCategory: sleep_night_hour,
                  categoryList: timeList3,
                  onSelect: (selectedCategory) {
                    setState(() {
                      sleep_night_hour =
                      selectedCategory!;
                      checkValid();
                      scrollDown();
                      //getDistrictList();
                    });
                  },
                  hint: "시간"),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (screenSize.width - 70) / 2,
              child: SelectorBox(
                  selectedCategory: sleep_night_min,
                  categoryList: timeList2,
                  onSelect: (selectedCategory) {
                    setState(() {
                      sleep_night_min = selectedCategory!;
                      checkValid();
                      scrollDown();
                      //getDistrictList();
                    });
                  },
                  hint: "분"),
            ),
          ],
        ),
      ],
    );
  }

  Widget symptomInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  hasDisease = 1;
                  checkValid();
                  setState(() {});
                },
                child: Row(
                  children: [
                    Image.asset(
                      hasDisease == 1
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 10),
                    H16(
                        text: LanguageService.trans(
                            "exist"),
                        weight: FW.medium,
                        color: AppColor_BlackText),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              InkWell(
                onTap: () {
                  hasDisease = 2;
                  checkValid();
                  setState(() {});
                },
                child: Row(
                  children: [
                    Image.asset(
                      hasDisease == 2
                          ? "assets/ic_option_on.png"
                          : "assets/ic_option_off.png",
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 10),
                    H16(
                        text:
                        LanguageService.trans("none"),
                        weight: FW.medium,
                        color: AppColor_BlackText),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
            visible: hasDisease == 1,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: _itemBuilder,
              itemCount: disease_count,
              controller: _listController,
            )),
        const SizedBox(height: 10),
        Visibility(
          visible: hasDisease == 1,
          child: Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColor_Light_Gray),
            child: InkWell(
                onTap: () {
                  if (hasDisease == 1) {
                    addSymptom();
                    // setState(() { print(imageList.length);});
                    disease_count = disease_count + 1;
                  } else {
                    showToast("질병을 추가할 수 없습니다.");
                  }
                },
                child: Center(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/add_circle_black_24dp.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 5),
                        H16(
                            text: "질병 추가",
                            weight: FW.medium,
                            color: AppColor_Primary),
                      ],
                    ))),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
        child: Container(
            width: screenSize.width - 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      H16(
                        text: LanguageService.trans(
                            "please_select_a_disease_category"),
                        weight: FW.medium,
                        color: AppColor_BlackText,
                        align: TextAlign.left,
                      ),
                      Expanded(child: Container()),
                      InkWell(
                        onTap: () {
                          // foodAddList.removeAt(index);
                          // checkValid();
                          // setState(() {});
                          delSymptom(index);
                        },
                        child: Visibility(
                          visible: index > 0,
                          child: Image.asset(
                            'assets/ic_delete.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SelectorBox(
                      selectedCategory: category[index],
                      categoryList: categoryList[index],
                      onSelect: (selectedCategory) {
                        setState(() {
                          selSymtomidx = index;
                          category[index] = selectedCategory!;
                          monitoringData!.symptom_list![index].category = selectedCategory;
                          if (selectedCategory == "직접입력") {
                            checkValid();
                          } else {
                            getSymtomList();
                            monitoringData!.symptom_list![index].symptom = symptomList[selSymtomidx][0];
                          }
                        });
                      },
                      hint: "질병 카테고리를 선택해주세요."),
                  const SizedBox(height: 10),
                  Visibility(
                    visible:
                    monitoringData!.symptom_list![index].category != "직접입력",
                    child: SelectorBox(
                        selectedCategory: symptom[index],
                        categoryList: symptomList[index],
                        onSelect: (selectedCategory) {
                          setState(() {
                            selSymtomidx = index;
                            symptom[index] = selectedCategory!;
                            monitoringData!.symptom_list![index].symptom = selectedCategory;
                            checkValid();
                          });
                        },
                        hint: "증상을 선택해주세요."),
                  ),
                  Visibility(
                    visible:
                    monitoringData!.symptom_list![index].category == "직접입력",
                    child: Container(
                      height: 52,
                      child: OutlineInput(
                        controller: directInputController[index],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        placeholder: "증상을 입력해주세요.",
                        onChanged: (text) => {
                          // directInputController[index].text = text,
                          checkValid()
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  H16(
                    text: LanguageService.trans(
                        "please_record_the_time_of_diagnosis_of_the_disease"),
                    weight: FW.medium,
                    color: AppColor_BlackText,
                    align: TextAlign.left,
                    height: 1.3,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      style: AppTextStyle.PD(AppColor_BlackText, 16,
                          weight: FW.medium),
                      controller: recordTimeControllerList[index],
                      onEditingComplete: () => node.nextFocus(),
                      maxLines: 1,
                      maxLength: -1,
                      keyboardType: TextInputType.text,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      enableInteractiveSelection: false,
                      focusNode: AlwaysDisabledFocusNode(),
                      onTap: () {
                        showBirthdayDlg(index);
                      },
                      // onChanged: (text) => {,},
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: AppColor_Selector_Border),
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor_BlackText),
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0))),
                        hintText: "YYMMDD",
                        hintStyle: AppTextStyle.PD(AppColor_Hint, 16,
                            weight: FW.medium),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 46),
                  H16(
                      text: LanguageService.trans(
                          "please_record_whether_the_disease_was_operated_tested"),
                      weight: FW.medium,
                      color: AppColor_BlackText,
                      align: TextAlign.left,
                      maxLine: 3,
                      height: 1.3),
                  const SizedBox(height: 21),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            surgeryList[index] = 1;
                            checkValid();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                surgeryList[index] == 1
                                    ? "assets/ic_option_on.png"
                                    : "assets/ic_option_off.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 10),
                              H16(
                                  text: LanguageService.trans("있음"),
                                  weight: FW.medium,
                                  color: AppColor_BlackText),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        InkWell(
                          onTap: () {
                            surgeryList[index] = 2;
                            checkValid();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                surgeryList[index] == 2
                                    ? "assets/ic_option_on.png"
                                    : "assets/ic_option_off.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 10),
                              H16(
                                  text: LanguageService.trans("없음"),
                                  weight: FW.medium,
                                  color: AppColor_BlackText),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: surgeryList[index] == 1,
                      child: Column(children: [
                        const SizedBox(height: 10),
                        OutlineInput(
                          controller: surgeryControllerList[index],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          placeholder: "수술/검사명",
                          onChanged: (text) => {
                            monitoringData!.symptom_list![index].surgey_name =
                                text,
                            checkValid()
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 55,
                          child: TextField(
                            style: AppTextStyle.PD(AppColor_BlackText, 16,
                                weight: FW.medium),
                            controller: surgeryDateControllerList[index],
                            onEditingComplete: () => node.nextFocus(),
                            maxLines: 1,
                            maxLength: -1,
                            keyboardType: TextInputType.text,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.next,
                            enableInteractiveSelection: false,
                            focusNode: AlwaysDisabledFocusNode(),
                            onTap: () {
                              showSurgerydateDlg(index);
                            },
                            onChanged: (text) => {
                              monitoringData!.symptom_list![index].surgey_time =
                                  text
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor_Selector_Border),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: AppColor_BlackText),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                              hintText: "YYMMDD",
                              hintStyle: AppTextStyle.PD(AppColor_Hint, 16,
                                  weight: FW.medium),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ])),
                  const SizedBox(height: 46),
                  H16(
                      text: LanguageService.trans(
                          "please_record_the_medication_and_prescription_photos"),
                      weight: FW.medium,
                      color: AppColor_BlackText,
                      align: TextAlign.left,
                      maxLine: 3,
                      height: 1.3),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            hasphotoList[index] = 1;
                            checkValid();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                hasphotoList[index] == 1
                                    ? "assets/ic_option_on.png"
                                    : "assets/ic_option_off.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 10),
                              H16(
                                  text: "복약 있음",
                                  weight: FW.medium,
                                  color: AppColor_BlackText),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        InkWell(
                          onTap: () {
                            hasphotoList[index] = 2;
                            checkValid();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                hasphotoList[index] == 2
                                    ? "assets/ic_option_on.png"
                                    : "assets/ic_option_off.png",
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: 10),
                              H16(
                                  text: LanguageService.trans("no_medication"),
                                  weight: FW.medium,
                                  color: AppColor_BlackText),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: hasphotoList[index] == 1,
                      child: Column(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              cur_symptom = index;
                            });
                            onSelectPhoto();
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColor_Selector_Border,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Image.asset("assets/camera_alt_black_24dp.png",
                                    width: 15),
                                const SizedBox(width: 10),
                                H14(
                                  text: LanguageService.trans("add_prescription_photo"),
                                  weight: FW.medium,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: imageList.isNotEmpty,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            child:
                            ReorderableListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  key: ValueKey(imageList[index]),
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      ClipPath(
                                        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                        child: ExtendedImage(
                                          image: NetworkImage(imageList[index]),
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: imageList.length,
                              onReorder: reorderPictures,
                            ),
                          ),
                        ),
                      ])),
                  const SizedBox(height: 20)
                ])));
  }
}
