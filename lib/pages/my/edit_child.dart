import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_checkbox.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h17.dart';
import 'package:ourdoctor/pages/components/h24_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/outline_num_input.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';

class EditChildPage extends StatefulWidget {
  EditChildPage({Key? key, required this.child_id}) : super(key: key);
  int? child_id;

  @override
  EditChildPageState createState() => EditChildPageState();
}

class EditChildPageState extends BaseState<EditChildPage> {
  final HttpService httpService = HttpService();
  final imagePicker = ImagePicker();

  var birthInputController = TextEditingController();
  var nameInputController = TextEditingController();
  var childHeightInputController = TextEditingController();
  var childWeightInputController = TextEditingController();
  var directInputController = TextEditingController();
  var address1InputController = TextEditingController();
  var address2InputController = TextEditingController();
  var address3InputController = TextEditingController();

  bool valid = true;
  String birth = "";
  String name = "";
  int gender = 1; //성별

  String child_height = "";
  String child_weight = "";

  List<String> childSymptom = [];
  List<int> selChildSymptom = [];
  String direct = "";
  String profileImage = "";
  String profileImageName = "";
  String medical_history = "";
  ChildList? childInfo;
  String address1 = ""; //우편번호
  String address2 = ""; //주소 1
  String address3 = ""; //주소 2
  bool isSame = false;

  @override
  void initState() {
    super.initState();
    childInfo = gUserInfo!.childList![widget.child_id!];
    name = childInfo!.name!;
    gender = childInfo!.gender!;
    child_height = childInfo!.height!;
    child_weight = childInfo!.weight!;
    birth = childInfo!.birth!;
    profileImage = childInfo!.profileImgUrl!;
    profileImageName = childInfo!.profileImg!;
    medical_history = childInfo!.medications!;
    address1 = childInfo!.postcode!;
    address2 = childInfo!.address!;
    address3 = childInfo!.addressDetail!;

    address1InputController.text = address1;
    address2InputController.text = address2;
    address3InputController.text = address3;

    nameInputController.text = name;
    childHeightInputController.text = child_height;
    childWeightInputController.text = child_weight;
    birthInputController.text = birth;
    for (int i = 0; i < gDiseaseList!.child!.length; i++) {
      childSymptom.add(gDiseaseList!.child![i].name!);
    }
    // for (int i = 0; i < gDiseaseList!.child!.length; i++) {
    //   if (medical_history.contains(childSymptom[i])) {
    //     selChildSymptom.add(i);
    //     if (i == (gDiseaseList!.child!.length - 1)) {
    //       direct = medical_history.substring(childInfo!.medications!.indexOf(") ") + 2);
    //       directInputController.text = direct;
    //     }
    //   }
    // }
    for (int i = 0; i < gDiseaseList!.child!.length; i++) {
      if (getMedicalIdx(gDiseaseList!.child!.elementAt(i).name!)) {
        selChildSymptom.add(i);
        if (gDiseaseList!.child!.elementAt(i).name == "직접입력") {
          direct = getDirectName("직접입력");
          directInputController.text = direct;
        }
      }
    }

    checkValid();
    setState(() {});
  }

  bool getMedicalIdx(String name) {
    for (int i = 0; i < childInfo!.medicalHistory!.length; i++) {
      if (childInfo!.medicalHistory!.elementAt(i).name == name) {
        return true;
      }
    }
    return false;
  }

  String getDirectName(String name) {
    for (int i = 0; i < childInfo!.medicalHistory!.length; i++) {
      if (childInfo!.medicalHistory!.elementAt(i).name == name) {
        return childInfo!.medicalHistory!.elementAt(i).detail!;
      }
    }
    return "";
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void onChangeChild() {
    reqChangeChild();
  }

  void checkValid() {
    if (name.isEmpty || child_height.isEmpty || child_weight.isEmpty || birth.isEmpty /*|| selChildSymptom.isEmpty || (selChildSymptom.contains(4) && direct.isEmpty)*/) {
      setState(() {
        valid = false;
      });
    } else {
      setState(() {
        valid = true;
      });
    }
  }

  void onSelect(int index, bool selected) {
    if (selected) {
      selChildSymptom.add(index);
    } else {
      selChildSymptom.remove(index);
    }
    setState(() {});
    checkValid();
  }

  Future<void> showBirthdayDlg() async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 1));
    if (_result != null && _result != "") {
      birth = _result;
      birthInputController.text = birth;
      checkValid();
    }
  }

  void onSelectPhoto() {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(onGallery: getGalleryImageAndCrop, onCamera: getCameraImageAndCrop);
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
        profileImage = value.data!.fileUrl!;
        profileImageName = value.data!.fileName!;
        setState(() {});
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

  // Network functions
  //////////////////////////////////
  Future<void> reqChangeChild() async {
    String history = "";
    List<Map<String, String>> historyList = [];
    for (int i = 0; i < gDiseaseList!.child!.length; i++) {
      if (selChildSymptom.contains(i)) {
        if (i < gDiseaseList!.child!.length - 1) {
          // history = history + childSymptom[i];
          Map<String, String> info = {
            'id': gDiseaseList!.child!.elementAt(i).id!,
            'name': gDiseaseList!.child!.elementAt(i).name!,
            'detail': "",
          };
          historyList.add(info);
        }
        if (i == gDiseaseList!.child!.length - 1) {
          // history = history + "(" + childSymptom[i] + ") " + direct;
          Map<String, String> info = {
            'id': gDiseaseList!.child!.elementAt(i).id!,
            'name': gDiseaseList!.child!.elementAt(i).name!,
            'detail': direct,
          };
          historyList.add(info);
        }
      }
    }
    if (historyList.isNotEmpty) {
      history = json.encode(historyList);
    }

    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> offInfo = httpService.editChildren3(
        gUserInfo!.accessToken!, childInfo!.id!, name, gender, child_height, child_weight, birth, history,
        profileImage == "" ? "profileImage" : profileImageName);
    offInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast("아이정보 수정되었습니다.");
        eventBus.fire(UpdateUserEvent());
        eventBus.fire(SelectChildEvent());
        onBackPressed();
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
    final node = FocusScope.of(context);
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("edit_child_information"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    H24B(
                      text: "아이 정보 수정하기",
                      color: AppColor_BlackText,
                    ),
                    const SizedBox(height: 14),
                    Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 3,
                        child: Container(
                            width: screenSize.width - 60,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const SizedBox(height: 14),
                              Center(
                                child: InkWell(
                                    onTap: onSelectPhoto,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          padding: EdgeInsets.all(profileImage.isEmpty ? 20 : 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: AppColor_Light_Gray,
                                          ),
                                          child: Stack(
                                            children: [
                                              Visibility(
                                                  visible: profileImage.isEmpty,
                                                  child: Center(
                                                    child: Image.asset(
                                                      gender == 1 ? "assets/ic_default_male.png" : "assets/ic_default_female.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                              Visibility(
                                                visible: profileImage.isNotEmpty,
                                                child: ExtendedImage.network(
                                                  profileImage,
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
                                              onTap: onSelectPhoto,
                                            ))
                                      ],
                                    )),
                              ),
                              Visibility(
                                visible: profileImage.isNotEmpty,
                                child: ElevatedButton(onPressed: (){
                                  setState(() {
                                    print(profileImage);
                                    profileImage = "";
                                  });
                                }, child: Text('사진 지우기')),
                              ),
                              const SizedBox(height: 15),
                              H14(
                                text: LanguageService.trans("name"),
                                weight: FW.medium,
                                color: AppColor_BlackText.withOpacity(0.5),
                              ),
                              UnderlineInput(
                                controller: nameInputController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),
                                placeholder: LanguageService.trans("enter_your_name"),
                                onChanged: (text) => {name = text, checkValid()},
                              ),
                              const SizedBox(height: 30),
                              Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        gender = 1;
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
                                              color: gender == 1 ? AppColor_White : AppColor_BlackText.withOpacity(0.04),
                                            ),
                                            child: Image.asset(gender == 1 ? "assets/ic_male_on.png" : "assets/ic_male_off.png"),
                                          )),
                                      const SizedBox(height: 10),
                                      H14(text: LanguageService.trans("male"), weight: FW.regular, color: gender == 1 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.5))
                                    ]),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        gender = 2;
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
                                                color: gender == 2 ? AppColor_White : AppColor_BlackText.withOpacity(0.04),
                                              ),
                                              child: Image.asset(gender == 2 ? "assets/ic_female_on.png" : "assets/ic_female_off.png"))),
                                      const SizedBox(height: 10),
                                      H14(text: LanguageService.trans("female"), weight: FW.regular, color: gender == 2 ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.5))
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
                                        SizedBox(
                                          width: screenSize.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: OutlineNumInput(
                                                  controller: childHeightInputController,
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.next,
                                                  onEditingComplete: () => node.nextFocus(),
                                                  placeholder: "",
                                                  onChanged: (text) => {child_height = text, checkValid()},
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
                                        )
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
                                        SizedBox(
                                          width: screenSize.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: OutlineNumInput(
                                                  controller: childWeightInputController,
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.next,
                                                  onEditingComplete: () => node.nextFocus(),
                                                  placeholder: "",
                                                  onChanged: (text) => {child_weight = text, checkValid()},
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
                                        )
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
                                  controller: birthInputController,
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
                                    showBirthdayDlg();
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColor_Selector_Border), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColor_BlackText), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                    hintText: "YYMMDD",
                                    hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 30),
                              // H16(text: LanguageService.trans("address"), weight: FW.medium, color: AppColor_BlackText),
                              // const SizedBox(height: 10),
                              // SizedBox(
                              //   height: 48,
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //         child: SizedBox(
                              //           height: MediaQuery.of(context).size.height,
                              //           child: Stack(
                              //             children: [
                              //               UnderlineInput1(
                              //                 height: MediaQuery.of(context).size.height,
                              //                 controller: address1InputController,
                              //                 keyboardType: TextInputType.text,
                              //                 textInputAction: TextInputAction.done,
                              //                 onEditingComplete: () => node.nextFocus(),
                              //                 placeholder: LanguageService.trans("zip_code"),
                              //                 onChanged: (text) => {address1 = text, checkValid()},
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(width: 15),
                              //       MainTextButton(
                              //         text: LanguageService.trans("search"),
                              //         backgroundColor: AppColor_Primary,
                              //         style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                              //         width: 90,
                              //         disable: true,
                              //         disableBackground: AppColor_BlackText,
                              //         onPressed: () async {
                              //           Map received = await Navigator.push(context, SlideRightTransRoute(builder: (context) => AddressSearchPage()));
                              //           node.requestFocus();
                              //           address1 = received["postcode"];
                              //           address2 = received["addr"];
                              //           checkValid();
                              //           // address1 = "123";
                              //           // address2 = "address1";
                              //           address1InputController.text = address1;
                              //           address2InputController.text = address2;
                              //           //getHospitalFromAddress();
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(height: 10),
                              // UnderlineInput1(
                              //   controller: address2InputController,
                              //   keyboardType: TextInputType.text,
                              //   textInputAction: TextInputAction.done,
                              //   onEditingComplete: () => node.nextFocus(),
                              //   placeholder: LanguageService.trans("address1"),
                              //   onChanged: (text) => {address2 = text, checkValid()},
                              // ),
                              // const SizedBox(height: 10),
                              // SizedBox(
                              //     height: 40,
                              //     child: Center(
                              //       child: TextField(
                              //         style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                              //         maxLength: -1,
                              //         controller: address3InputController,
                              //         onEditingComplete: () => node.nextFocus(),
                              //         keyboardType: TextInputType.text,
                              //         obscureText: false,
                              //         textAlignVertical: TextAlignVertical.center,
                              //         textAlign: TextAlign.start,
                              //         textInputAction: TextInputAction.done,
                              //         // focusNode: detailAddrFocusNode,
                              //         decoration: InputDecoration(
                              //           counterText: "",
                              //           enabledBorder: const UnderlineInputBorder(
                              //             borderSide: BorderSide(color: AppColor_Selector_Border),
                              //           ),
                              //           focusedBorder: const UnderlineInputBorder(
                              //             borderSide: BorderSide(color: AppColor_BlackText),
                              //           ),
                              //           hintText: LanguageService.trans("address2"),
                              //           hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.medium),
                              //           border: InputBorder.none,
                              //         ),
                              //         onChanged: (text) => {address3 = text, checkValid()},
                              //       ),
                              //     )),
                              // const SizedBox(height: 30),
                              // InkWell(
                              //   onTap: () {
                              //     isSame = !isSame;
                              //     if (isSame) {
                              //       address1 = gUserInfo!.postcode!;
                              //       address2 = gUserInfo!.address!;
                              //       address3 = gUserInfo!.addressDetail!;
                              //       address1InputController.text = address1;
                              //       address2InputController.text = address2;
                              //       address3InputController.text = address3;
                              //     }
                              //     setState(() {});
                              //     checkValid();
                              //   },
                              //   child: SizedBox(
                              //     width: double.infinity,
                              //     height: 24,
                              //     child: Row(
                              //       children: [
                              //         Image.asset(
                              //           isSame ? 'assets/ic_radio_on.png' : 'assets/ic_radio_off.png',
                              //           width: 24,
                              //           height: 24,
                              //         ),
                              //         const SizedBox(width: 10),
                              //         H14(
                              //           text: LanguageService.trans("same_as_address_guardian"),
                              //           weight: FW.medium,
                              //           height: 1.3,
                              //           color: isSame ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 35),
                              H16(text: LanguageService.trans("child_past_medical_history"), weight: FW.medium, color: AppColor_BlackText),
                              const SizedBox(height: 5),
                              H14(text: "과거 병력이 없다면 체크하지 않아도 돼요", weight: FW.medium, color: AppColor_BlackText.withOpacity(0.3)),
                              const SizedBox(height: 20),
                              GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: childSymptom.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 80 / 30, mainAxisSpacing: 10, crossAxisSpacing: 15),
                                  itemBuilder: (BuildContext context, int index) {
                                    return AppCheckbox(text: childSymptom[index], checked: selChildSymptom.contains(index) ? true : false, padding: 20.0, withBorder: true, onChecked: (checked) => {onSelect(index, checked!)});
                                  }),
                              const SizedBox(height: 20),
                              Visibility(
                                visible: selChildSymptom.contains(gDiseaseList!.child!.length - 1),
                                child: UnderlineInput(
                                  controller: directInputController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),
                                  placeholder: LanguageService.trans("direct_input"),
                                  onChanged: (text) => {direct = text, checkValid()},
                                ),
                              ),
                              const SizedBox(height: 20)
                            ]))),
                    const SizedBox(height: 25),
                    MainTextButton(
                      text: "저장하기",
                      backgroundColor: AppColor_Primary,
                      style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                      disable: !valid,
                      disableBackground: !valid ? AppColor_Primary_Disable : Colors.transparent,
                      onPressed: () {
                        onChangeChild();
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              )),
            ),
          ],
        ));
  }
}
