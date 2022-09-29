import 'dart:convert';
import 'dart:developer' as developer;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/models/monitor_day_res_model.dart';
import 'package:ourdoctor/models/monitoring_record_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
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
import 'package:ourdoctor/pages/monitoring/calori_calc.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_result1.dart';
import 'package:ourdoctor/pages/monitoring/second_step.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class FirstStepPage extends StatefulWidget {
  FirstStepPage(
      {Key? key,
      required this.selPhysical,
      required this.selBrain,
      this.uid = ""})
      : super(key: key);

  List<int>? selPhysical;
  List<int>? selBrain;
  String? uid;

  @override
  FirstStepPageState createState() => FirstStepPageState();
}

class FirstStepPageState extends BaseState<FirstStepPage> {
  final HttpService httpService = HttpService();
  String askImage = "";

  bool isValid = true;

  var heightInputController = TextEditingController();
  var weightInputController = TextEditingController();
  var birthInputController = TextEditingController();

  // var surgeryInputController = TextEditingController();
  // var surgeryDateInputController = TextEditingController();

  List<TextEditingController> recordTimeControllerList = [];
  List<int> surgeryList = [];
  List<TextEditingController> surgeryControllerList = [];
  List<TextEditingController> surgeryDateControllerList = [];
  List<TextEditingController> directInputController = [];
  List<int> hasphotoList = [];
  List<String> imageList = [];

  List<String> nutritionalStatus = <String>[
    LanguageService.trans("morning1"),
    LanguageService.trans("lunch"),
    LanguageService.trans("snack"),
    LanguageService.trans("dinner"),
  ];
  List<String> nutritionalStatus1 = <String>["", "", "", ""];
  List<int> selNutrition = [];

  // String height = "";
  // String weight = "";
  // String birth = "";
  int hasDisease = 2;
  int surgery = 0;
  int disease_count = 1;
  String surgery_name = "";
  String surgery_date = "";
  int hasPhoto = 0;
  int cur_symptom = 0;

  String sleep_night_hour = "0시간";
  String sleep_night_min = "0분";
  String sleep_launch_hour = "0시간";
  String sleep_launch_min = "0분";
  List<String> timeList1 = []; //시간
  List<String> timeList2 = []; //분
  List<String> timeList3 = []; //밤잠 시간

  late ScrollController _listController;

  // String symptom = "";
  List<String> symptom = [];
  String initSymptom = "";

  //String category = "";
  List<String> category = [];
  String initCategory = "";
  List<List<String>> symptomList = [];
  List<List<String>> categoryList = [];
  List<String> initSymptomList = [];
  List<String> initCategoryList = [];

  final imagePicker = ImagePicker();
  int selSymtomidx = 0;
  String uid = "";

  @override
  void initState() {
    super.initState();
    uid = widget.uid!;
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

    _listController = ScrollController();
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

      getHeightAndWeight();

      monitoringData!.height = heightInputController.text;
      monitoringData!.weight = weightInputController.text;
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
      monitoringData!.nutrition = "0,0,0,0";

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
      //재입력
      heightInputController.text = monitoringData!.height!;
      weightInputController.text = monitoringData!.weight!;

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

      //재입력시 칼로리 비우기
      if (monitoringData!.nutrition!.isNotEmpty) {
        for (int i = 0; i < 4; i++) {
          selNutrition.add(i);
          nutritionalStatus1[i] =
              '${monitoringData!.nutrition!.split(",")[i]}\nkcal';
        }
        setState(() {});
      }

      // if (monitoringData!.foodAddList1!.isNotEmpty) {
      //   selNutrition.add(0);
      //   nutritionalStatus1[0] = monitoringData!.nutrition!.split(",")[0];
      // }

      // if (monitoringData!.foodAddList2!.isNotEmpty) {
      //   selNutrition.add(1);
      //   nutritionalStatus1[1] = monitoringData!.nutrition!.split(",")[1];
      // }

      // if (monitoringData!.foodAddList3!.isNotEmpty) {
      //   selNutrition.add(2);
      //   nutritionalStatus1[2] = monitoringData!.nutrition!.split(",")[2];
      // }

      // if (monitoringData!.foodAddList4!.isNotEmpty) {
      //   selNutrition.add(3);
      //   nutritionalStatus1[3] = monitoringData!.nutrition!.split(",")[3];
      // }

      if (monitoringData!.symptom_list!.isNotEmpty) {
        hasDisease = 1;
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
    // Clean up the focus node when the Form is disposed.
    _listController.dispose();
    super.dispose();
  }

  getHeightAndWeight() async {
    Future<HomeMonitorResModel> info = httpService.homeMonitorInfo();
    info.then((HomeMonitorResModel value) async {
      if (value.result == 0) {
        heightInputController.text = value.data!.height.toString();
        monitoringData!.height = value.data!.height.toString();
        weightInputController.text = value.data!.weight.toString();
        monitoringData!.weight = value.data!.weight.toString();
      }
      setState(() {});
    });
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

  void onSelect(int type, int index, bool selected) {
    String tmp = "";
    switch (type) {
      case 0:
        if (selected) {
          selNutrition.add(index);
        } else {
          selNutrition.remove(index);
        }
        break;
    }
    for (var i = 0; i < 4; i++) {
      if (selNutrition.contains(i)) {
        tmp += "1";
      } else {
        tmp += "0";
      }
    }
    monitoringData!.nutrition = tmp;
    setState(() {});
  }

  void checkValid() {
    isValid = false;
    if (widget.selPhysical!.contains(0) && monitoringData!.height! == "") {
      developer.log(monitoringData!.height.toString());
      return;
    }

    if (widget.selPhysical!.contains(1) && monitoringData!.weight! == "") {
      developer.log(monitoringData!.weight.toString());
      return;
    }

    if (widget.selPhysical!.contains(4) && hasDisease == 1) {
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
    setState(() {});
  }

  Future<void> goNext() async {
    // if(monitoringData!.symptom_list != null)
    //   print(monitoringData!.symptom_list![0].medication);
    FocusScope.of(context).requestFocus(FocusNode());

    if (!isValid) {
      return;
    }
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
    monitoringData!.sleep_at_lunch = sleep_launch.toString();
    monitoringData!.sleep_at_night = sleep_night.toString();

    if (!widget.selPhysical!.contains(0)) {
      monitoringData!.height = "";
    }
    if (widget.selBrain!.isEmpty) {
      //언어, 운동, 사회성 체크하지 않은 경우
      saveMonitoring();
    } else {
      for (int i = 0; i < monitoringData!.symptom_list!.length; i++) {
        //카테고리
        String category = monitoringData!.symptom_list![i].category!;
        //질병
        if (category == "직접입력") {
          monitoringData!.symptom_list![i].symptom =
              directInputController[i].text;
        }
      }
      String _recv = await Navigator.push(
          context,
          SlideRightTransRoute(
              builder: (context) => SecondStepPage(
                  selBrain: widget.selBrain,
                  hasDisease: hasDisease,
                  surgeryList: surgeryList,
                  hasphotoList: hasphotoList,
                  uid: uid)));
      if (_recv != null && _recv != "") {
        // uid = _recv;
        Navigator.pop(context, _recv);
      }
    }
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

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
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

  void onSelectPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(
              onGallery: getGalleryImageAndCrop,
              onCamera: getCameraImageAndCrop);
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

  // Network functions
  //////////////////////////////////
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

  //모니터링 기록
  Future<void> saveMonitoring() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String monitoring_time =
        dateFormat.format(DateTime.now()); //앱내 모니터링 날짜(yyyy-MM-dd HH:mm:ss)
    String height = monitoringData!.height!; //신장
    String weight = monitoringData!.weight!; //몸무게
    String nutrition =
        monitoringData!.nutrition!; //카로리(아침,점심,간식,저녁), 반점으로 구분, 없으면 0
    String sleep_at_night = monitoringData!.sleep_at_night!; //밤잠
    String sleep_at_lunch = monitoringData!.sleep_at_lunch!; //낮잠
    String symptom_list = ""; //질병데이터 json 리스트(예시대로 올려야 함)
    String language = ""; //언어성평가 json데이터
    String sociability = ""; //사회성평가 json데이터
    String work_out = ""; //운동성평가 json데이터

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
    setState(() {
      isLoading = true;
    });

    Future<MonitoringRecordResModel> info = httpService.monitoringRecord(
        monitoring_time,
        height,
        weight,
        nutrition,
        sleep_at_night,
        sleep_at_lunch,
        symptom_list,
        language,
        sociability,
        work_out,
        uid);
    info.then((MonitoringRecordResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        LocalService.setMonitoringStatus("1");
        String _recv = await Navigator.push(
            context,
            SlideRightTransRoute(
                builder: (context) =>
                    MonitoringResult1Page(uid: value.data!.id)));
        if (_recv != null && _recv != "") {
          Navigator.pop(context, _recv);
        }
      } else {
        if (value.result == 106) {
          //token expired
          showToast(value.msg ?? "");
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        } else if (value.result == 203) {
          showToast("오늘 이미 모니터링을 하셨습니다.");
        } else {
          showToast(value.msg ?? "");
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //키와 체중
  String getFirstName() {
    if (widget.selPhysical!.contains(0) && !widget.selPhysical!.contains(1)) {
      return "1. 오늘의 키를 기록해주세요.";
    }

    if (!widget.selPhysical!.contains(0) && widget.selPhysical!.contains(1)) {
      return "1. 오늘의 체중을 기록해주세요.";
    }

    return "1. 오늘의 키와 체중을 기록해주세요.";
  }

  //영양
  String getSecondName() {
    if (!widget.selPhysical!.contains(0) && !widget.selPhysical!.contains(1)) {
      return "1. 오늘의 영양상태를 기록해주세요.";
    }

    return "2. 오늘의 영양상태를 기록해주세요.";
  }

  //수면
  String getThirdName() {
    if (!widget.selPhysical!.contains(0) &&
        !widget.selPhysical!.contains(1) &&
        !widget.selPhysical!.contains(3)) {
      return "1. 어제의 수면 시간을 기록해주세요.";
    }

    if (!widget.selPhysical!.contains(0) &&
        widget.selPhysical!.contains(1) &&
        widget.selPhysical!.contains(3)) {
      return "3. 어제의 수면 시간을 기록해주세요.";
    }

    if (widget.selPhysical!.contains(0) &&
        !widget.selPhysical!.contains(1) &&
        widget.selPhysical!.contains(3)) {
      return "3. 어제의 수면 시간을 기록해주세요.";
    }

    if (widget.selPhysical!.contains(0) &&
        widget.selPhysical!.contains(1) &&
        widget.selPhysical!.contains(3)) {
      return "3. 어제의 수면 시간을 기록해주세요.";
    }

    return "2. 어제의 수면 시간을 기록해주세요.";
  }

  //질병
  String getFourName() {
    if (!widget.selPhysical!.contains(0) &&
        !widget.selPhysical!.contains(1) &&
        !widget.selPhysical!.contains(2) &&
        !widget.selPhysical!.contains(3)) {
      return "1. 오늘의 질병 현황을 기록해주세요.";
    }

    if (widget.selPhysical!.contains(0) &&
        widget.selPhysical!.contains(1) &&
        widget.selPhysical!.contains(2) &&
        widget.selPhysical!.contains(3)) {
      return "4. 오늘의 질병 현황을 기록해주세요.";
    }

    if (!widget.selPhysical!.contains(0) &&
        widget.selPhysical!.contains(1) &&
        !widget.selPhysical!.contains(2) &&
        !widget.selPhysical!.contains(3)) {
      return "2. 오늘의 질병 현황을 기록해주세요.";
    }

    if (widget.selPhysical!.contains(0) &&
        !widget.selPhysical!.contains(1) &&
        !widget.selPhysical!.contains(2) &&
        !widget.selPhysical!.contains(3)) {
      return "2. 오늘의 질병 현황을 기록해주세요.";
    }

    if (!widget.selPhysical!.contains(0) &&
        !widget.selPhysical!.contains(1) &&
        widget.selPhysical!.contains(2) &&
        !widget.selPhysical!.contains(3)) {
      return "2. 오늘의 질병 현황을 기록해주세요.";
    }

    if (!widget.selPhysical!.contains(0) &&
        !widget.selPhysical!.contains(1) &&
        !widget.selPhysical!.contains(2) &&
        widget.selPhysical!.contains(3)) {
      return "2. 오늘의 질병 현황을 기록해주세요.";
    }

    return "3. 오늘의 질병 현황을 기록해주세요.";
  }

  final tooltip = GlobalKey();

  void showMoreText() {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: "오늘의 질병 현황을 기록해주세요.",
        textStyle: AppTextStyle.PD(AppColor_BlackText, 14, height: 1.2),
        height: 55,
        width: 205,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        onDismiss: () {});
    popup.show(
      widgetKey: tooltip,
    );
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
                  title: LanguageService.trans('diagnosis_of_the_day'),
                  onBackPressed: onBackPressed,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 21),
                        H24B(
                          text: LanguageService.trans("1_physical_development"),
                          color: AppColor_BlackText,
                          align: TextAlign.left,
                          height: 1.5,
                        ),
                        const SizedBox(height: 20),
                        //키와 체중
                        Visibility(
                          visible: widget.selPhysical!.contains(0) ||
                              widget.selPhysical!.contains(1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  H16(
                                    text: getFirstName(),
                                    weight: FW.medium,
                                    color: AppColor_BlackText,
                                    align: TextAlign.start,
                                  ),
                                  // const SizedBox(width: 10),
                                  // InkWell(
                                  //   key: const Key('show_more_ink_well'),
                                  //   child: Container(
                                  //     key: tooltip,
                                  //     child: Image.asset('assets/question_mark_black_24dp.png', width: 22),
                                  //   ),
                                  //   onTap: showMoreText,
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: widget.selPhysical!.contains(0),
                                    child: SizedBox(
                                        width: (screenSize.width - 70) / 2,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: OutlineNumInput(
                                                controller:
                                                    heightInputController,
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
                                                  monitoringData!.height = text;
                                                  setState(() {});
                                                  checkValid();
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            H17(
                                              text: LanguageService.trans("cm"),
                                              weight: FW.medium,
                                              color: AppColor_BlackText,
                                            ),
                                          ],
                                        )),
                                  ),
                                  Visibility(
                                      visible: widget.selPhysical!.contains(0),
                                      child: const SizedBox(
                                        width: 10,
                                      )),
                                  Visibility(
                                    visible: widget.selPhysical!.contains(1),
                                    child: SizedBox(
                                        width: (screenSize.width - 70) / 2,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: OutlineNumInput(
                                                controller:
                                                    weightInputController,
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
                                                  monitoringData!.weight = text;
                                                  setState(() {});
                                                  checkValid();
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            H17(
                                              text: LanguageService.trans("kg"),
                                              weight: FW.medium,
                                              color: AppColor_BlackText,
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                        //영양
                        Visibility(
                          visible: widget.selPhysical!.contains(3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              H16(
                                  text: getSecondName(),
                                  weight: FW.medium,
                                  color: AppColor_BlackText,
                                  align: TextAlign.start),
                              const SizedBox(height: 12),
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
                                    // return AppCheckboxFill(
                                    //   text: nutritionalStatus[index],
                                    //   checked: false,
                                    //   padding: 10.0,
                                    //   withBorder: true,
                                    //   onChecked: (checked) => {
                                    //     Navigator.push(context, SlideRightTransRoute(builder: (context) => CaloriCalcPage())),
                                    //     onSelect(0, index, checked!),
                                    //   },
                                    // );
                                    return InkWell(
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        String received = await Navigator.push(
                                            context,
                                            SlideRightTransRoute(
                                                builder: (context) =>
                                                    CaloriCalcPage(
                                                        type: index)));
                                        if (received != "") {
                                          /*
                                      if (selNutrition.contains(index)) {
                                        selNutrition.remove(index);

                                        var arr = monitoringData!.nutrition!.split(",");
                                        arr[index] = "0";
                                        monitoringData!.nutrition = arr.join(",");
                                        checkValid();
                                      } else {
                                        selNutrition.add(index);
                                        nutritionalStatus1[index] = received + "\nkcal";

                                        var arr = monitoringData!.nutrition!.split(",");
                                        arr[index] = received;
                                        monitoringData!.nutrition = arr.join(",");
                                        checkValid();
                                      }
                                       */
                                          if (!selNutrition.contains(index)) {
                                            selNutrition.add(index);
                                          }
                                          if (received != "0") {
                                            nutritionalStatus1[index] =
                                                received + "\nkcal";
                                          } else {
                                            nutritionalStatus1[index] = "";
                                          }
                                          // nutritionalStatus1[index] = received + "\nkcal";
                                          var arr = monitoringData!.nutrition!
                                              .split(",");
                                          if (received != "0") {
                                            arr[index] = received;
                                          } else {
                                            arr[index] = "";
                                          }
                                          // arr[index] = received;
                                          monitoringData!.nutrition =
                                              arr.join(",");
                                          checkValid();
                                        }
                                      },
                                      child: Container(
                                        height: 70,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.00),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: selNutrition.contains(index)
                                                ? AppColor_Primary
                                                : AppColor_BlackText
                                                    .withOpacity(0.05)),
                                        child: Center(
                                          child: H18(
                                            text: selNutrition.contains(index)
                                                ? nutritionalStatus1[index]
                                                : nutritionalStatus[index],
                                            weight: FW.medium,
                                            maxLine: 3,
                                            color: selNutrition.contains(index)
                                                ? AppColor_White
                                                : AppColor_BlackText
                                                    .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                        //수면
                        Visibility(
                          visible: widget.selPhysical!.contains(2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              H16(
                                  text: getThirdName(),
                                  weight: FW.medium,
                                  color: AppColor_BlackText,
                                  align: TextAlign.start),
                              const SizedBox(height: 18),
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
                                    child: Selector(
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
                                            //getDistrictList();
                                          });
                                        },
                                        hint: "시간"),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: (screenSize.width - 70) / 2,
                                    child: Selector(
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
                                    child: Selector(
                                        selectedCategory: sleep_night_hour,
                                        categoryList: timeList3,
                                        onSelect: (selectedCategory) {
                                          setState(() {
                                            sleep_night_hour =
                                                selectedCategory!;
                                            checkValid();
                                            //getDistrictList();
                                          });
                                        },
                                        hint: "시간"),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: (screenSize.width - 70) / 2,
                                    child: Selector(
                                        selectedCategory: sleep_night_min,
                                        categoryList: timeList2,
                                        onSelect: (selectedCategory) {
                                          setState(() {
                                            sleep_night_min = selectedCategory!;
                                            checkValid();
                                            //getDistrictList();
                                          });
                                        },
                                        hint: "분"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                        //
                        Visibility(
                          visible: widget.selPhysical!.contains(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              H16(
                                  text: getFourName(),
                                  weight: FW.medium,
                                  color: AppColor_BlackText,
                                  align: TextAlign.start),
                              const SizedBox(height: 15),
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
                                    itemCount:
                                        monitoringData!.symptom_list!.length,
                                    controller: _listController,
                                  )),
                              const SizedBox(height: 10),
                              Container(
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
                                            text: LanguageService.trans(
                                                "add_disease"),
                                            weight: FW.medium,
                                            color: AppColor_Primary),
                                      ],
                                    ))),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            H18(
                              text: (1).toString(),
                              weight: FW.bold,
                            ),
                            H18(
                              text: ' / 2',
                              weight: FW.regular,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                )),
                MainTextButton(
                  text: widget.selBrain!.isEmpty ? "모니터링 결과보기" : "다음",
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
                    goNext();
                  },
                ),
              ],
            )));
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
                  Selector(
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
                          }
                        });
                      },
                      hint: "질병 카테고리를 선택해주세요"),
                  const SizedBox(height: 10),
                  Visibility(
                    visible:
                        monitoringData!.symptom_list![index].category != "직접입력",
                    child: Selector(
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
                        hint: "증상을 선택해주세요"),
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
                          directInputController[index].text = text,
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
                                  text: LanguageService.trans(
                                      "add_prescription_photo"),
                                  weight: FW.medium,
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: imageList[index] != "",
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              // image: DecorationImage(image: AssetImage
                              //   ("assets/image_9.png"), fit: BoxFit.cover)
                            ),
                            child: ClipPath(
                              clipper: ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Image.network(
                                imageList[index],
                                width: MediaQuery.of(context).size.width - 60,
                                height: MediaQuery.of(context).size.width - 60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      ])),
                  const SizedBox(height: 20)
                ])));
  }
}
