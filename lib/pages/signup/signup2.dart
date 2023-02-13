//import 'dart:html';

import 'dart:convert';
import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/global/local_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/signup_parent_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_checkbox.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_input.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/signup/address.dart';
import 'package:ourdoctor/pages/signup/signup3.dart';
import 'package:ourdoctor/pages/signup/signup_finish.dart';

class SignupFamilyPage extends StatefulWidget {
  SignupFamilyPage({Key? key, required this.info, this.childHeight = "", this.childWeight = ""}) : super(key: key);
  SignupParentInfo? info;
  String? childHeight;
  String? childWeight;

  @override
  SignupFamilyPageState createState() => SignupFamilyPageState();
}

class SignupFamilyPageState extends BaseState<SignupFamilyPage> {
  final HttpService httpService = HttpService();

  final imagePicker = ImagePicker();

  List<TextEditingController> birthInputController1 = [];
  // List<TextEditingController> parentInputController = [];
  // List<String> parentHistory = [];
  var highBloodInputController = TextEditingController();
  var diabeticInputController = TextEditingController();
  var cardiovascularInputController = TextEditingController();
  var asthmaInputController = TextEditingController();
  var cancerInputController = TextEditingController();
  List<TextEditingController> directInputController = [];

  List<TextEditingController> nameInputController = [];
  List<TextEditingController> childHeightInputController = [];
  List<TextEditingController> childWeightInputController = [];
  List<TextEditingController> childSymptomInputController = [];
  List<TextEditingController> address1InputController = [];
  List<TextEditingController> address2InputController = [];
  List<TextEditingController> address3InputController = [];

  String birth = "";
  String sHigh_blood = "";
  String sDiabetic = "";
  String sCardiovascular = "";
  String sAsthma = "";
  String sCancer = "";
  List<String> sDirect = [];

  bool isValid = false;

  String profileImage1 = "";

  List<String> commonSymptoms = [];
  List<int> selCommon = [];

  late ScrollController _listController;
  late ScrollController _listController1;
  late ScrollController _listController2;
  int children_count = 1;
  List<int> gender = [];
  List<String> name = [];

  List<String> child_height = [];
  List<String> child_weight = [];
  List<String> birthday = [];

  List<String> childSymptom = [];

  List<List<int>> childSymptoms = [];
  List<String> profileImage = [];
  List<String> profileImageName = [];
  List<String> childSymptomDirect = [];

  List<String> address1 = []; //우편번호
  List<String> address2 = []; //주소 1
  List<String> address3 = []; //주소 2

  List<bool> allFamilyIdx1 = [false, false, false, false, false, false];
  List<bool> allFamilyIdx2 = [false, false, false, false, false, false];
  List<bool> allFamilyIdx3 = [false, false, false, false, false, false];
  List<bool> allDiseaseIdx1 = []; //질병
  List<bool> allDiseaseIdx2 = []; //질병
  List<bool> allDiseaseIdx3 = []; //질병
  List<String> allDiseaseContent = []; //질병입력내용

  SignupFamilyPageState() {
    // sDirect.add("");
    // directInputController.add(TextEditingController());
    for (int i = 0; i < gDiseaseList!.parent!.length; i++) {
      commonSymptoms.add(gDiseaseList!.parent![i].name!);
      // allFamilyIdx1.add(false);
      // allFamilyIdx2.add(false);
      // allFamilyIdx3.add(false);
      // if (i < gDiseaseList!.parent!.length) {
      //   parentInputController.add(TextEditingController());
      //   parentHistory.add("");
      // }
    }
    for (int i = 0; i < gDiseaseList!.child!.length; i++) {
      childSymptom.add(gDiseaseList!.child![i].name!);
    }
    // for (int i = 0; i < widget.info!.child_number; i++) {
    //   nameInputController.add(TextEditingController());
    //   childHeightInputController.add(TextEditingController());
    //   childWeightInputController.add(TextEditingController());
    //   birthInputController1.add(TextEditingController());
    //   address1InputController.add(TextEditingController());
    //   address2InputController.add(TextEditingController());
    //   address3InputController.add(TextEditingController());
    //   gender.add(1);
    //   name.add("");
    //   profileImage.add("");
    //   child_height.add("");
    //   child_weight.add("");
    //   birthday.add("");
    //   List<int> selChildSymptom = [];
    //   //List.generate(5, (index) => selChildSymptom.add(-1));
    //   childSymptoms.add(selChildSymptom);
    //   childSymptomInputController.add(TextEditingController());
    //   childSymptomDirect.add("");
    // }
  }

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _listController1 = ScrollController();
    _listController2 = ScrollController();
    children_count = widget.info!.child_number;

    for (int i = 0; i < widget.info!.child_number; i++) {
      nameInputController.add(TextEditingController());
      childHeightInputController.add(TextEditingController());
      childWeightInputController.add(TextEditingController());
      birthInputController1.add(TextEditingController());
      address1InputController.add(TextEditingController());
      address2InputController.add(TextEditingController());
      address3InputController.add(TextEditingController());
      gender.add(1);
      name.add("");
      profileImage.add("");
      profileImageName.add("");
      child_height.add("");
      child_weight.add("");
      birthday.add("");
      List<int> selChildSymptom = [];
      //List.generate(5, (index) => selChildSymptom.add(-1));
      childSymptoms.add(selChildSymptom);
      childSymptomInputController.add(TextEditingController());
      childSymptomDirect.add("");
    }
    for (int i = 0; i < widget.info!.child_number; i++) {
      if (widget.info!.same_addr) {
        address1.add(widget.info!.code);
        address2.add(widget.info!.addr1);
        address3.add(widget.info!.addr2);
        address1InputController[i].text = address1[i];
        address2InputController[i].text = address2[i];
        address3InputController[i].text = address3[i];
      } else {
        address1.add("");
        address2.add("");
        address3.add("");
        address1InputController[i].text = "";
        address2InputController[i].text = "";
        address3InputController[i].text = "";
      }
    }

    if (childHeightInputController.isNotEmpty && child_height.isNotEmpty) {
      childHeightInputController[0].text = widget.childHeight!;
      child_height[0] = widget.childHeight!;
    }

    if (childWeightInputController.isNotEmpty && child_weight.isNotEmpty) {
      childWeightInputController[0].text = widget.childWeight!;
      child_weight[0] = widget.childWeight!;
    }

    print(widget.info!.relationship);

    // for (int i = 0; i < gDiseaseList!.parent!.length - 1; i++) {
    //   allFamilyIdx.add(0);
    // }

    setState(() {});
  }

  void onSelect(int type, int index, bool selected) {
    if (type == 7) {
      if (selected) {
        selCommon.add(index);
        allFamilyIdx1[index] = false;
        allFamilyIdx2[index] = false;
        allFamilyIdx3[index] = false;
        if (index == 5) {
          onAddDisease();
        }
      } else {
        selCommon.remove(index);
        if (index == 5) {
          onAllDelDisease();
        }
      }
    } else {
      if (selected) {
        childSymptoms[type].add(index);
      } else {
        childSymptoms[type].remove(index);
      }
    }
    setState(() {});
    checkValid();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    // detailAddrFocusNode!.dispose();
    FocusScope.of(context).unfocus();
    _listController.dispose();
    _listController1.dispose();
    _listController2.dispose();
    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void checkValid() {
    // if (selCommon.isEmpty) {
    //   setState(() {
    //     isValid = false;
    //   });
    // } else {
    //   setState(() {
    //     isValid = true;
    //   });
    // }

    // directInputController
    isValid = false;
    if (selCommon.isEmpty) {
      setState(() {
        isValid = false;
      });
    } else {
      for (int i = 0; i < selCommon.length; i++) {
        String name = commonSymptoms[selCommon[i]];
        if (name != "직접입력") {
          if (!allFamilyIdx1[selCommon[i]] && !allFamilyIdx2[selCommon[i]] && !allFamilyIdx3[selCommon[i]]) {
            setState(() {
              isValid = false;
            });
            return;
          }
        }
      }

      for (int i = 0; i < allDiseaseContent.length; i++) {
        if (!allDiseaseIdx1[i] && !allDiseaseIdx2[i] && !allDiseaseIdx3[i]) {
          setState(() {
            isValid = false;
          });
          return;
        }
        if (allDiseaseContent[i] == "") {
          setState(() {
            isValid = false;
          });
          return;
        }
      }
      setState(() {
        isValid = true;
      });
    }
    /*
    for (int i = 0; i < selCommon.length; i++) {
      //상단 질병 직접입력인 경우
      if (selCommon.elementAt(i) == (gDiseaseList!.parent!.length - 1)) {
        for (int k = 0; k < sDirect.length; k++) {
          String content = sDirect.elementAt(k);
          if (content == "") {
            return;
          }
        }
      } else {
        // String content = parentInputController.elementAt(selCommon.elementAt(i)).text;
        // if (content == "") {
        //   return;
        // }
      }
    }
    */
    //자녀관련들
    for (int i = 0; i < nameInputController.length; i++) {
      String content = nameInputController.elementAt(i).text;
      if (content == "") {
        return;
      }
    }

    for (int i = 0; i < childHeightInputController.length; i++) {
      String content = childHeightInputController.elementAt(i).text;
      if (content == "") {
        return;
      }
    }

    for (int i = 0; i < childWeightInputController.length; i++) {
      String content = childWeightInputController.elementAt(i).text;
      if (content == "") {
        return;
      }
    }

    for (int i = 0; i < birthInputController1.length; i++) {
      String content = birthInputController1.elementAt(i).text;
      if (content == "") {
        return;
      }
    }

    for (int i = 0; i < address1InputController.length; i++) {
      String content = address1InputController.elementAt(i).text;
      if (content == "") {
        return;
      }
    }

    for (int i = 0; i < address2InputController.length; i++) {
      String content = address2InputController.elementAt(i).text;
      if (content == "") {
        return;
      }
    }
    /*
    for (int i = 0; i < children_count; i++) {
      if (childSymptoms[i].isEmpty) {
        return;
      }

      if (childSymptoms[i].contains(gDiseaseList!.child!.length - 1)) {
        String content = childSymptomInputController.elementAt(i).text;
        if (content == "") {
          return;
        }
      }
    }
    */
    isValid = true;
    setState(() {});
  }

  Future<void> showBirthdayDlg(int index) async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 1));
    if (_result != null && _result != "") {
      birth = _result;
      birthInputController1[index].text = birth;
      birthday[index] = birth;
      checkValid();
    }
  }

  void onSelectPhoto(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(onGallery: () {
            getGalleryImageAndCrop(index);
          }, onCamera: () {
            getCameraImageAndCrop(index);
          }, onprofileImage: () {
            getProfileImage();
          },);
        });
  }

  void getGalleryImageAndCrop(int index) async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image == null) return;

    var croppedImage = await cropImage(image.path);
    if (croppedImage != null) {
      uploadFile(croppedImage, index);
    }
  }

  void getCameraImageAndCrop(int index) async {
    Navigator.pop(context);
    final image = await imagePicker.getImage(source: ImageSource.camera);
    if (image == null) return;

    var croppedImage = await cropImage(image.path);
    if (croppedImage != null) {
      uploadFile(croppedImage, index);
    }
  }

  void getProfileImage() async {
    Navigator.pop(context);
    if (profileImage1.isNotEmpty) {
      profileImage1 = "";
    }
  }

  Future<File?> cropImage(String imagePath) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: imagePath,
      maxWidth: 500,
      maxHeight: 500,
      compressQuality: 50,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(toolbarTitle: LanguageService.trans('image_crop'), toolbarColor: Colors.white, toolbarWidgetColor: Colors.black, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
    );
    return croppedFile;
  }

  void uploadFile(File uploadFile, int index) {
    setState(() {
      isLoading = true;
    });
    Future<FileUploadResModel> uploadInfo = httpService.uploadFile(uploadFile);
    print("--------------");
    uploadInfo.then((FileUploadResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        profileImage[index] = value.data!.fileUrl!;
        profileImageName[index] = value.data!.fileName!;
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
      showToast(onError);
    });
  }

  void onDeleteChild(int index) {
    children_count = children_count - 1;
    print(index);
    name.removeAt(index);
    nameInputController.removeAt(index);
    gender.removeAt(index);
    child_height.removeAt(index);
    childHeightInputController.removeAt(index);
    child_weight.removeAt(index);
    childWeightInputController.removeAt(index);
    birthday.removeAt(index);
    birthInputController1.removeAt(index);
    childSymptoms.removeAt(index);
    childSymptomInputController.removeAt(index);
    address1InputController.removeAt(index);
    address2InputController.removeAt(index);
    address3InputController.removeAt(index);
    address1.removeAt(index);
    address2.removeAt(index);
    address3.removeAt(index);
    profileImage.removeAt(index);
    profileImageName.removeAt(index);
    setState(() {});
    checkValid();
  }

  void onAddChildren() {
    children_count = children_count + 1;
    nameInputController.add(TextEditingController());
    childHeightInputController.add(TextEditingController());
    childWeightInputController.add(TextEditingController());
    birthInputController1.add(TextEditingController());
    childSymptomInputController.add(TextEditingController());
    TextInputType.text;
    TextInputAction.next;
    gender.add(1);
    name.add("");
    profileImage.add("");
    profileImageName.add("");
    child_height.add("");
    child_weight.add("");
    birthday.add("");
    List<int> selChildSymptom = [];
    //List.generate(5, (index) => selChildSymptom.add(-1));
    childSymptoms.add(selChildSymptom);
    address1InputController.add(TextEditingController());
    address2InputController.add(TextEditingController());
    address3InputController.add(TextEditingController());
    if (widget.info!.same_addr) {
      address1.add(widget.info!.code);
      address2.add(widget.info!.addr1);
      address3.add(widget.info!.addr2);

      address1InputController[address1InputController.length - 1].text = widget.info!.code;
      address2InputController[address1InputController.length - 1].text = widget.info!.addr1;
      address3InputController[address1InputController.length - 1].text = widget.info!.addr2;
    } else {
      address1.add("");
      address2.add("");
      address3.add("");
    }
    setState(() {});
    checkValid();
  }

  void onAddDisease() {
    sDirect.add("");
    allDiseaseIdx1.add(false);
    allDiseaseIdx2.add(false);
    allDiseaseIdx3.add(false);
    allDiseaseContent.add("");
    directInputController.add(TextEditingController());
    setState(() {});
    checkValid();
  }

  void onDelDisease(int index) {
    allDiseaseIdx1.removeAt(index);
    allDiseaseIdx2.removeAt(index);
    allDiseaseIdx3.removeAt(index);
    allDiseaseContent.removeAt(index);
    sDirect.removeAt(index);
    directInputController.removeAt(index);

    if (allDiseaseIdx1.isEmpty) {
      selCommon.remove(5);
    }
    setState(() {});
    checkValid();
  }

  void onAllDelDisease() {
    allDiseaseIdx1.clear();
    allDiseaseIdx2.clear();
    allDiseaseIdx3.clear();
    allDiseaseContent.clear();
    sDirect.clear();
    directInputController.clear();
    setState(() {});
    checkValid();
  }

  Future<void> goNext() async {
    //SignupChildInfo info = SignupChildInfo(parentHistory, selCommon, sDirect, disease_count, children_count, name, child_height, child_weight, profileImage, gender, birthday, childSymptoms, childSymptomDirect, address1, address2, address3);
    //Navigator.push(context, SlideRightTransRoute(builder: (context) => SignupHomePage(parentInfo: widget.info!, childInfo: info)));
    String family_history = "";
    String child_list = "";

    String token = await LocalService.getToken();

    List<Map<String, String>> historyList = [];
    for (int i = 0; i < selCommon.length; i++) {
      //상단 질병 직접입력인 경우
      String name = commonSymptoms[selCommon[i]];
      if (name == "직접입력") {
        // for (int i = 0; i < allDiseaseIdx.length; i++) {
        //
        // }
        String? _id = gDiseaseList!.parent![selCommon.elementAt(i)].id;
        for (int k = 0; k < allDiseaseContent.length; k++) {
          // String? _name = gDiseaseList!.parent![selCommon.elementAt(i)].name;
          // String content = directInputController.elementAt(k).text;
          if (allDiseaseIdx1[k]) {
            Map<String, String> info = {
              'id': _id!,
              'name': allDiseaseContent[k],
              'detail': "조부모",
            };
            historyList.add(info);
          }

          if (allDiseaseIdx2[k]) {
            Map<String, String> info = {
              'id': _id!,
              'name': allDiseaseContent[k],
              'detail': "부모",
            };
            historyList.add(info);
          }

          if (allDiseaseIdx3[k]) {
            Map<String, String> info = {
              'id': _id!,
              'name': allDiseaseContent[k],
              'detail': "형제 ˑ 자매",
            };
            historyList.add(info);
          }
        }
      } else {
        //String content = parentInputController.elementAt(selCommon.elementAt(i)).text;
        if (allFamilyIdx1[i]) {
          String? _id = gDiseaseList!.parent![selCommon.elementAt(i)].id;
          String? _name = gDiseaseList!.parent![selCommon.elementAt(i)].name;
          Map<String, String> info = {
            'id': _id!,
            'name': _name!,
            'detail': "조부모",
          };
          historyList.add(info);
        }

        if (allFamilyIdx2[i]) {
          String? _id = gDiseaseList!.parent![selCommon.elementAt(i)].id;
          String? _name = gDiseaseList!.parent![selCommon.elementAt(i)].name;
          Map<String, String> info = {
            'id': _id!,
            'name': _name!,
            'detail': "부모",
          };
          historyList.add(info);
        }

        if (allFamilyIdx3[i]) {
          String? _id = gDiseaseList!.parent![selCommon.elementAt(i)].id;
          String? _name = gDiseaseList!.parent![selCommon.elementAt(i)].name;
          Map<String, String> info = {
            'id': _id!,
            'name': _name!,
            'detail': "형제 ˑ 자매",
          };
          historyList.add(info);
        }
      }
    }
    family_history = json.encode(historyList);

    List<Map<String, Object>> childList = [];
    for (int i = 0; i < children_count; i++) {
      String _name = nameInputController.elementAt(i).text;
      String _birth = birthInputController1.elementAt(i).text;
      String _height = childHeightInputController.elementAt(i).text;
      String _weight = childWeightInputController.elementAt(i).text;
      int _gender = gender.elementAt(i);
      String _code = address1InputController.elementAt(i).text;
      String _add1 = address2InputController.elementAt(i).text;
      String _add2 = address3InputController.elementAt(i).text;

      List<Map<String, String>> historyList = [];
      // for (int k = 0; k < childSymptoms[i].length; k++) {
      //   int index = childSymptoms[i].elementAt(k);
      //   if (index == gDiseaseList!.child!.length - 1) {
      //     String content = childSymptomInputController.elementAt(i).text;
      //     String? _iid = gDiseaseList!.child!.elementAt(index).id;
      //     String? _nname = gDiseaseList!.child!.elementAt(index).name;
      //     Map<String, String> info = {
      //       'id': _iid!,
      //       'name': _nname!,
      //       'detail': content,
      //     };
      //     historyList.add(info);
      //   } else {
      //     String? _iid = gDiseaseList!.child!.elementAt(index).id;
      //     String? _nname = gDiseaseList!.child!.elementAt(index).name;
      //     Map<String, String> info = {
      //       'id': _iid!,
      //       'name': _nname!,
      //       'detail': "",
      //     };
      //     historyList.add(info);
      //   }
      // }
      Map<String, String> direct = {
        'id': gDiseaseList!.child!.elementAt(4).id!,
        'name': gDiseaseList!.child!.elementAt(4).name!,
        'detail': childSymptomDirect.elementAt(i),
      };
      historyList.add(direct);
      Map<String, Object> info = {
        'profile_img': profileImageName[i],
        'name': _name,
        'gender': _gender.toString(),
        'height': _height,
        'weight': _weight,
        'birth': _birth,
        'postcode': _code,
        'address': _add1,
        'address_detail': _add2,
        'family_history': historyList,
      };
      // Map obj = Map();
      childList.add(info);
    }
    child_list = json.encode(childList);

    setState(() {
      isLoading = true;
    });

    Future<SignupParentResModel> offInfo = httpService.signup3(widget.info!.id, widget.info!.pwd, widget.info!.type, token, widget.info!.name, widget.info!.birth, widget.info!.phone, widget.info!.code, widget.info!.addr1, widget.info!.addr2, widget.info!.dad_height, widget.info!.mom_height,
        family_history, child_list, widget.info!.relationship, widget.info!.nickname, widget.info!.alarm);
    offInfo.then((SignupParentResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        Navigator.push(context, SlideRightTransRoute(builder: (context) => SignupFinishPage(parentInfo: widget.info!)));
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
      //showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                    height: 55,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            onBackPressed();
                          },
                          child: Image.asset(
                            'assets/path_12225.png',
                            width: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: H18(
                              text: LanguageService.trans("sign_up"),
                              weight: FW.medium,
                              height: 1.5,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ),
                        Container(
                          width: 10,
                        ),
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        H24B(
                          text: LanguageService.trans("family_history"),
                          color: AppColor_BlackText,
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: commonSymptoms.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 80 / 30, mainAxisSpacing: 10, crossAxisSpacing: 15),
                            itemBuilder: (BuildContext context, int index) {
                              return AppCheckbox(
                                text: commonSymptoms[index],
                                checked: selCommon.contains(index) ? true : false,
                                padding: 10.0,
                                withBorder: true,
                                onChecked: (checked) => {onSelect(7, index, checked!)},
                              );
                            }),
                        Visibility(
                          visible: (selCommon.isNotEmpty),
                          child: const SizedBox(height: 20),
                        ),
                        // Visibility(
                        //   visible: (selCommon.isNotEmpty && selCommon.contains(0)),
                        //   child: Column(
                        //     children: [
                        //       OutlineInput(
                        //         controller: highBloodInputController,
                        //         keyboardType: TextInputType.text,
                        //         textInputAction: TextInputAction.next,
                        //         onEditingComplete: () => node.nextFocus(),
                        //         placeholder: LanguageService.trans("high blood"),
                        //         onChanged: (text) => {sHigh_blood = text, checkValid()},
                        //       ),
                        //       const SizedBox(height: 10)
                        //     ]
                        //   )
                        // ),
                        /*
                        가족력 입력 조부모, 부모, 형체 체크관련
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: _itemBuilder2,
                          itemCount: gDiseaseList!.parent!.length - 1,
                          controller: _listController2,
                        ),
                         */
//고혈압
                        Visibility(
                          visible: selCommon.contains(0),
                          child: Container(
                            margin: const EdgeInsets.only(top: 36.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: "고혈압 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx1[0] = !allFamilyIdx1[0];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx1[0] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx2[0] = !allFamilyIdx2[0];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx2[0] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx3[0] = !allFamilyIdx3[0];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx3[0] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //당뇨
                        Visibility(
                          visible: selCommon.contains(1),
                          child: Container(
                            margin: const EdgeInsets.only(top: 36.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: "당뇨 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx1[1] = !allFamilyIdx1[1];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx1[1] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx2[1] = !allFamilyIdx2[1];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx2[1] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx3[1] = !allFamilyIdx3[1];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx3[1] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //심/뇌혈관 질환
                        Visibility(
                          visible: selCommon.contains(2),
                          child: Container(
                            margin: const EdgeInsets.only(top: 36.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: "심/뇌혈관 질환 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx1[2] = !allFamilyIdx1[2];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx1[2] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx2[2] = !allFamilyIdx2[2];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx2[2] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx3[2] = !allFamilyIdx3[2];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx3[2] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //천식
                        Visibility(
                          visible: selCommon.contains(3),
                          child: Container(
                            margin: const EdgeInsets.only(top: 36.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: "천식 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx1[3] = !allFamilyIdx1[3];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx1[3] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx2[3] = !allFamilyIdx2[3];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx2[3] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx3[3] = !allFamilyIdx3[3];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx3[3] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //암
                        Visibility(
                          visible: selCommon.contains(4),
                          child: Container(
                            margin: const EdgeInsets.only(top: 36.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H14(text: "암 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx1[4] = !allFamilyIdx1[4];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx1[4] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx2[4] = !allFamilyIdx2[4];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx2[4] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        allFamilyIdx3[4] = !allFamilyIdx3[4];
                                        setState(() {});
                                        checkValid();
                                      },
                                      child: SizedBox(
                                        width: (screenSize.width - 60) / 3,
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Image.asset(allFamilyIdx3[4] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                                            const SizedBox(width: 8),
                                            H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                            //visible: (selCommon.isNotEmpty && selCommon.contains(gDiseaseList!.parent!.length - 1)),
                            visible: selCommon.contains(5),
                            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const SizedBox(height: 40),
                              Container(
                                height: 1,
                                color: AppColor_Selector_Border,
                              ),
                              const SizedBox(height: 40),
                              H16(text: "질병 직접입력", weight: FW.medium, color: AppColor_BlackText),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (ctx, idx) => _itemBuilder1(ctx, idx),
                                itemCount: allDiseaseContent.length,
                                controller: _listController1,
                              ),
                              const SizedBox(height: 25),
                              Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor_Light_Gray),
                                child: InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      onAddDisease();
                                    },
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/add_circle_black_24dp.png",
                                          width: 25,
                                          height: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        H16(text: "질병 추가", weight: FW.bold, color: AppColor_Primary),
                                      ],
                                    ))),
                              ),
                            ])),
                        const SizedBox(height: 60),
                        H24B(
                          text: LanguageService.trans("child_basic_information"),
                          color: AppColor_BlackText,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: _itemBuilder,
                          itemCount: children_count,
                          controller: _listController,
                        ),
                        Visibility(
                          visible: children_count != 6,
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColor_Light_Gray),
                            child: InkWell(
                                onTap: () {
                                  onAddChildren();
                                },
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/add_circle_black_24dp.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(width: 5),
                                    H16(text: "자녀 추가", weight: FW.medium, color: AppColor_Primary),
                                  ],
                                ))),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: MainTextButton(
                            text: LanguageService.trans("next"),
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                            width: MediaQuery.of(context).size.width - 60,
                            disable: !isValid,
                            disableBackground: !isValid ? AppColor_Primary_Disable : Colors.transparent,
                            onPressed: () {
                              if (!isValid) {
                                return;
                              }
                              goNext();
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
        child: Container(
            width: screenSize.width - 60,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 15),
              Visibility(
                  visible: index != 0,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    InkWell(
                      child: Image.asset('assets/clear_black_24dp.png', height: 24),
                      onTap: () {
                        onDeleteChild(index);
                      },
                    )
                  ])),
              const SizedBox(height: 5),
              Center(
                child: InkWell(
                    onTap: () {
                      onSelectPhoto(index);
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          padding: EdgeInsets.all(profileImage[index].isEmpty ? 20 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColor_Light_Gray,
                          ),
                          child: Stack(
                            children: [
                              Visibility(
                                  visible: profileImage[index].isEmpty,
                                  child: Center(
                                    child: Image.asset(
                                      index == 0 ? "assets/group_19977.png" : "assets/group_20021.png",
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Visibility(
                                visible: profileImage[index].isNotEmpty,
                                child: ExtendedImage.network(
                                  profileImage[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  cache: true,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            bottom: 1,
                            right: 1,
                            child: InkWell(
                                child: Image.asset('assets/add_circle_black_24dp.png', width: 25),
                                onTap: () {
                                  onSelectPhoto(index);
                                }))
                      ],
                    )),
              ),
              const SizedBox(height: 15),
              H14(
                text: LanguageService.trans("name"),
                weight: FW.medium,
                color: AppColor_BlackText.withOpacity(0.5),
              ),
              UnderlineInput(
                controller: nameInputController[index],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                placeholder: LanguageService.trans("enter_your_name"),
                onChanged: (text) => {name[index] = text, checkValid()},
              ),
              const SizedBox(height: 30),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender[index] = 1;
                      });
                    },
                    child: Column(children: [
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 3,
                          child: Container(
                            width: 75,
                            height: 75,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: gender[index] == 1 ? AppColor_White : AppColor_BlackText.withOpacity(0.04),
                            ),
                            child: Image.asset(gender[index] == 1 ? "assets/ic_male_on.png" : "assets/ic_male_off.png"),
                          )),
                      const SizedBox(height: 10),
                      H14(text: LanguageService.trans("male"), weight: FW.regular, color: gender[index] == 1 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.5))
                    ]),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender[index] = 2;
                      });
                    },
                    child: Column(children: [
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 3,
                          child: Container(
                              width: 75,
                              height: 75,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: gender[index] == 2 ? AppColor_White : AppColor_BlackText.withOpacity(0.04),
                              ),
                              child: Image.asset(gender[index] == 2 ? "assets/ic_female_on.png" : "assets/ic_female_off.png"))),
                      const SizedBox(height: 10),
                      H14(text: LanguageService.trans("female"), weight: FW.regular, color: gender[index] == 2 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.5))
                    ]),
                  ),
                ],
              )),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (screenSize.width - 110) / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H16(text: LanguageService.trans("child_height"), weight: FW.medium, color: AppColor_BlackText),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlineNumInput(
                                controller: childHeightInputController[index],
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                textInputAction: TextInputAction.next,
                                placeholder: "",
                                onChanged: (text) => {child_height[index] = text, checkValid()},
                              ),
                            ),
                            const SizedBox(width: 10),
                            H17(
                              text: LanguageService.trans("cm"),
                              weight: FW.medium,
                              color: AppColor_BlackText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: (screenSize.width - 110) / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H16(text: LanguageService.trans("child_weight"), weight: FW.medium, color: AppColor_BlackText),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlineNumInput(
                                controller: childWeightInputController[index],
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                textInputAction: TextInputAction.next,
                                placeholder: "",
                                onChanged: (text) => {child_weight[index] = text, checkValid()},
                              ),
                            ),
                            const SizedBox(width: 10),
                            H17(
                              text: LanguageService.trans("kg"),
                              weight: FW.medium,
                              color: AppColor_BlackText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              H16(text: LanguageService.trans("child_date_birth"), weight: FW.medium, color: AppColor_BlackText),
              const SizedBox(height: 10),
              SizedBox(
                height: 55,
                child: TextField(
                  style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                  controller: birthInputController1[index],
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
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColor_Selector_Border), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColor_BlackText), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    hintText: "YYYY-MM-DD",
                    hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Visibility(
                  visible: widget.info!.same_addr == false,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 30),
                    H16(text: LanguageService.trans("address"), weight: FW.medium, color: AppColor_BlackText),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  UnderlineInput1(
                                    height: MediaQuery.of(context).size.height,
                                    controller: address1InputController[index],
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    placeholder: LanguageService.trans("zip_code"),
                                    onChanged: (text) => {address1[index] = text, checkValid()},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          MainTextButton(
                            text: LanguageService.trans("search"),
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                            width: 90,
                            disable: true,
                            disableBackground: AppColor_BlackText,
                            onPressed: () async {
                              Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => AddressSearchPage()));
                              address1[index] = received["postcode"];
                              address2[index] = received["addr"];
                              checkValid();
                              // address1[index] = "22044";
                              // address2[index] = "서울시 종로구 27";
                              address1InputController[index].text = address1[index];
                              address2InputController[index].text = address2[index];
                              //getHospitalFromAddress();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    UnderlineInput1(
                      controller: address2InputController[index],
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      placeholder: LanguageService.trans("address1"),
                      onChanged: (text) => {address2[index] = text, checkValid()},
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 40,
                        child: Center(
                          child: TextField(
                            style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                            maxLength: -1,
                            controller: address3InputController[index],
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.done,
                            // focusNode: detailAddrFocusNode,
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColor_Selector_Border),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColor_BlackText),
                              ),
                              hintText: LanguageService.trans("address2"),
                              hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) => {address3[index] = text, checkValid()},
                          ),
                        )),
                  ])),
              const SizedBox(height: 35),
              H16(text: LanguageService.trans("child_past_medical_history"), weight: FW.medium, color: AppColor_BlackText),
              const SizedBox(height: 5),
              H14(text: "과거력, 수술병력, 알러지, 출생력(미숙아) 등\n있다면 적어주세요", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.3), maxLine: 2, align: TextAlign.start,),
              const SizedBox(height: 10),
              // GridView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: childSymptom.length,
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 80 / 30, mainAxisSpacing: 10, crossAxisSpacing: 15),
              //     itemBuilder: (BuildContext context, int index) {
              //       return AppCheckbox(
              //         text: childSymptom[index],
              //         checked: selChildSymptom.contains(index) ? true : false,
              //         padding: 20.0,
              //         withBorder: true,
              //         onChecked: (checked) => {
              //           onSelect(index, checked!),
              //         },
              //       );
              //     }),
              // const SizedBox(height: 20),
              UnderlineInput(
                controller: childSymptomInputController[index],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                placeholder: "예시) 복숭아 알러지",
                onChanged: (text) => {childSymptomDirect[index] = text, checkValid()},
              ),
              const SizedBox(height: 30)
            ])));
  }

  // Widget _itemBuilder1(BuildContext context, int index) {
  //   return Container(
  //       child: Column(
  //     children: [
  //       OutlineInput(
  //         controller: directInputController[index],
  //         keyboardType: TextInputType.text,
  //         textInputAction: TextInputAction.next,
  //         //onEditingComplete: () => node.nextFocus(),
  //         placeholder: "질병명(관계)",
  //         onChanged: (text) => {sDirect[index] = text, checkValid()},
  //       ),
  //       const SizedBox(height: 10)
  //     ],
  //   ));
  // }
  Widget _itemBuilder1(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child:
                TextField(
                  controller: directInputController[index],
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor_Selector_Border),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor_BlackText),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),
                    hintText: "가족력 질병 직접입력",
                    hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) => {
                    sDirect[index] = text,
                    allDiseaseContent[index] = text,
                    checkValid(),
                  },
                ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                onDelDisease(index);
              },
              child: Image.asset(
                'assets/ic_delete.png',
                width: 25,
                height: 25,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        H14(text: "질병 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
        const SizedBox(height: 15),
        Row(
          children: [
            InkWell(
              onTap: () {
                allDiseaseIdx1[index] = !allDiseaseIdx1[index];
                checkValid();
              },
              child: SizedBox(
                width: (screenSize.width - 60) / 3,
                height: 24,
                child: Row(
                  children: [
                    Image.asset(allDiseaseIdx1[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                allDiseaseIdx2[index] = !allDiseaseIdx2[index];
                checkValid();
              },
              child: SizedBox(
                width: (screenSize.width - 60) / 3,
                height: 24,
                child: Row(
                  children: [
                    Image.asset(allDiseaseIdx2[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                allDiseaseIdx3[index] = !allDiseaseIdx3[index];
                checkValid();
              },
              child: SizedBox(
                width: (screenSize.width - 60) / 3,
                height: 24,
                child: Row(
                  children: [
                    Image.asset(allDiseaseIdx3[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _itemBuilder2(BuildContext context, int index) {
  //   return Visibility(
  //       visible: selCommon.contains(index),
  //       child: Container(
  //           child: Column(
  //         children: [
  //           OutlineInput(
  //             controller: parentInputController[index],
  //             keyboardType: TextInputType.text,
  //             textInputAction: TextInputAction.next,
  //             //onEditingComplete: () => node.nextFocus(),
  //             placeholder: gDiseaseList!.parent!.elementAt(index).name! + " 환자와의 관계",
  //             onChanged: (text) => {parentHistory[index] = text, checkValid()},
  //           ),
  //           const SizedBox(height: 10)
  //         ],
  //       )));
  // }
  /*
  Widget _itemBuilder2(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Visibility(
      visible: selCommon.contains(index),
      child: Container(
        margin: const EdgeInsets.only(top: 36.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H14(text: gDiseaseList!.parent!.elementAt(index).name! + " 환자", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.5)),
            const SizedBox(height: 15),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    int idx = getFamilyIdx(gDiseaseList!.parent!.elementAt(index).name!);
                    allFamilyIdx1[idx] = !allFamilyIdx1[idx];
                    checkValid();
                  },
                  child: SizedBox(
                    width: (screenSize.width - 60) / 3,
                    height: 24,
                    child: Row(
                      children: [
                        Image.asset(allFamilyIdx1[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                        const SizedBox(width: 8),
                        H16(text: "조부모", weight: FW.medium, color: AppColor_BlackText),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    int idx = getFamilyIdx(gDiseaseList!.parent!.elementAt(index).name!);
                    allFamilyIdx2[idx] = !allFamilyIdx2[idx];
                    checkValid();
                  },
                  child: SizedBox(
                    width: (screenSize.width - 60) / 3,
                    height: 24,
                    child: Row(
                      children: [
                        Image.asset(allFamilyIdx2[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                        const SizedBox(width: 8),
                        H16(text: "부모", weight: FW.medium, color: AppColor_BlackText),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    int idx = getFamilyIdx(gDiseaseList!.parent!.elementAt(index).name!);
                    allFamilyIdx3[idx] = !allFamilyIdx3[idx];
                    checkValid();
                  },
                  child: SizedBox(
                    width: (screenSize.width - 60) / 3,
                    height: 24,
                    child: Row(
                      children: [
                        Image.asset(allFamilyIdx3[index] ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png', width: 24, height: 24),
                        const SizedBox(width: 8),
                        H16(text: "형제 ˑ 자매", weight: FW.medium, color: AppColor_BlackText),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  */
}
