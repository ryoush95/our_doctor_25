import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/app_res_model.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/hosiptal_list_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/selector.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/underline_input1.dart';
import 'package:ourdoctor/pages/dialog/dlg_select_date.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/pages/my/title_input.dart';
import 'package:ourdoctor/pages/signup/address.dart';

class ChildEditPage extends StatefulWidget {
  ChildEditPage({Key? key, required this.info}) : super(key: key);
  ChildList? info;

  @override
  ChildEditPageState createState() => ChildEditPageState();
}

class ChildEditPageState extends BaseState<ChildEditPage> {
  final imagePicker = ImagePicker();
  final HttpService httpService = HttpService();
  String name = "";
  String birth = "";
  String phone = "";
  String weight = "";
  String date = "";
  String postcode = "";
  String address1 = "";
  String address2 = "";
  String profileImage = "";
  String hosiptalId = "";
  ChildList? dicUserInfo;

  bool valid = false;
  var nameController = TextEditingController();
  var birthController = TextEditingController();
  var phoneController = TextEditingController();
  var weightController = TextEditingController();
  var dateController = TextEditingController();
  var codeController = TextEditingController();
  var address1Controller = TextEditingController();
  var address2Controller = TextEditingController();

  String mCity = "";
  String mDistrict = "";
  String mHospital = "";
  List<String> districtList = [];
  List<String> hospitalList = [];
  List<HospitalDto> arrHospitalList = [];

  FocusNode? detailAddrFocusNode;

  @override
  void initState() {
    super.initState();
    dicUserInfo = widget.info;
    detailAddrFocusNode = FocusNode();

    name = dicUserInfo!.name!;
    birth = dicUserInfo!.birth!;
    date = dicUserInfo!.monitoringDate!;
    phone = dicUserInfo!.phone!;
    weight = dicUserInfo!.weight!;
    profileImage = dicUserInfo!.profileImgUrl!;
    postcode = dicUserInfo!.postcode!;
    address1 = dicUserInfo!.address!;
    address2 = dicUserInfo!.addressDetail!;
    hosiptalId = dicUserInfo!.hospitalId!;

    nameController.text = name;
    birthController.text = birth;
    phoneController.text = phone;
    dateController.text = date;
    codeController.text = postcode;
    address1Controller.text = address1;
    address2Controller.text = address2;

    checkValid();

    var arr = dicUserInfo!.hospitalArea!.split(" ");
    if (arr.length == 2) {
      mCity = arr[0];
      mDistrict = arr[1];
      mHospital = dicUserInfo!.hospitalName!;
      for (int i = 0; i < gDistrictList!.length; i++) {
        DistrictList info = gDistrictList!.elementAt(i);
        if (info.city == mCity) {
          districtList = info.list!;
        }
      }

      hospitalList = [];

      setState(() {
        isLoading = true;
      });

      Future<HospitalListResModel> info = httpService.hospitalList(mCity, mDistrict);
      info.then((HospitalListResModel value) async {
        setState(() {
          isLoading = false;
        });
        if (value.result == 0) {
          arrHospitalList = value.data!;
          for (int i = 0; i < arrHospitalList.length; i++) {
            hospitalList.add(arrHospitalList.elementAt(i).name!);
          }
          setState(() {});
        } else {
          showToast(value.msg ?? "");
        }
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        showToast(onError);
      });
    } else {
      if (gCityList!.isNotEmpty) {
        mCity = gCityList!.elementAt(0);
        getDistrictList();
      }
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    detailAddrFocusNode!.dispose();

    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void getDistrictList() {
    for (int i = 0; i < gDistrictList!.length; i++) {
      DistrictList info = gDistrictList!.elementAt(i);
      if (info.city == mCity) {
        districtList = info.list!;
      }
    }

    if (districtList.isNotEmpty) {
      mDistrict = districtList.elementAt(0);
      hospitalList = [];
      getHosiptalList();
    }
  }

  //주소검색데이터로부터 병원정보 얻기
  void getHospitalFromAddress() {
    var arr = address1.split(" ");
    if (arr.length > 3) {
      // 서울특별시 강남구 선릉로90길 64
      String city = arr[0];
      String district = arr[1];
      String district1 = arr[2];
      String temp = district1.substring(district1.length - 1);
      if (temp == "구") {
        district = district.replaceAll("시", "") + district1;
      }
      for (int i = 0; i < gDistrictList!.length; i++) {
        DistrictList info = gDistrictList!.elementAt(i);
        if (city.contains(info.city!)) {
          for (int i = 0; i < info.list!.length; i++) {
            String gun = info.list!.elementAt(i);
            if (district == gun) {
              mCity = info.city!;
              mDistrict = gun;
              districtList = info.list!;
              getHosiptalList();
              break;
            }
          }
        }
      }
    }
  }

  Future<void> showBirthdayDlg() async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 1));
    if (_result != null && _result != "") {
      birth = _result;
      birthController.text = birth;
      checkValid();
    }
  }

  Future<void> showPcrDateDlg() async {
    var _result = await showDialog(context: context, builder: (_) => SelectDateDialog(type: 2));
    if (_result != null && _result != "") {
      date = _result;
      dateController.text = date;
      checkValid();
    }
  }

  void onSelectPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(onGallery: getGalleryImageAndCrop, onCamera: getCameraImageAndCrop, onprofileImage: getProfileImage,);;
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

  void onSave() {
    if (!valid) {
      return;
    }
    reqUserEdit();
  }

  void checkValid() {
    if (phone.isEmpty || name.isEmpty || birth.isEmpty || weight.isEmpty || date.isEmpty || postcode.isEmpty || address1.isEmpty || hosiptalId.isEmpty) {
      setState(() {
        valid = false;
      });
    } else {
      setState(() {
        valid = true;
      });
    }
  }

  //정보수정하기
  Future<void> reqUserEdit() async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> offerInfo = httpService.addChildren(dicUserInfo!.id!, name, birth, dicUserInfo!.gender!, phone, date, postcode, address1, address2, hosiptalId, profileImage, weight);
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('update_child_success'));
        eventBus.fire(UpdateChildEvent());
        onBackPressed();
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

  //파일 업로드
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

  //병원리스트 얻기
  Future<void> getHosiptalList() async {
    setState(() {
      isLoading = true;
    });

    Future<HospitalListResModel> info = httpService.hospitalList(mCity, mDistrict);
    info.then((HospitalListResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        hosiptalId = "";
        arrHospitalList = value.data!;
        for (int i = 0; i < arrHospitalList.length; i++) {
          hospitalList.add(arrHospitalList.elementAt(i).name!);
        }
        if (arrHospitalList.isNotEmpty) {
          mHospital = arrHospitalList.elementAt(0).name!;
          hosiptalId = arrHospitalList.elementAt(0).id!;
        }
        setState(() {});
      } else {
        showToast(value.msg ?? "");
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return PageLayout(
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: LanguageService.trans("children_info"),
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
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
                                            getRandomImg(),
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
                    const SizedBox(height: 30),
                    TitleInput(
                      title: LanguageService.trans("name"),
                      controller: nameController,
                      onEditComplete: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      hint: LanguageService.trans("nmae_hint1"),
                      onChange: (text) {
                        setState(() {
                          name = text;
                        });
                        checkValid();
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showBirthdayDlg();
                      },
                      child: TitleInput(
                        title: LanguageService.trans("birthday"),
                        controller: birthController,
                        onEditComplete: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        hint: "YYMMDD",
                        isEnable: false,
                        onChange: (text) {
                          setState(() {
                            birth = text;
                          });
                          checkValid();
                        },
                      ),
                    ),
                    TitleInput(
                      title: LanguageService.trans("phone_number"),
                      controller: phoneController,
                      onEditComplete: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      textType: TextInputType.number,
                      hint: LanguageService.trans("phone_hint"),
                      onChange: (text) {
                        setState(() {
                          phone = text;
                        });
                        checkValid();
                      },
                    ),
                    TitleInput(
                      title: LanguageService.trans("weight"),
                      controller: weightController,
                      onEditComplete: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      textType: TextInputType.number,
                      hint: LanguageService.trans("kg"),
                      onChange: (text) {
                        setState(() {
                          weight = text;
                        });
                        checkValid();
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showPcrDateDlg();
                      },
                      child: TitleInput(
                        title: LanguageService.trans("pcr_date"),
                        controller: dateController,
                        onEditComplete: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        hint: "YYMMDD",
                        isEnable: false,
                        onChange: (text) {
                          setState(() {
                            date = text;
                          });
                          checkValid();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: H14(
                        text: LanguageService.trans("address"),
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  UnderlineInput1(
                                    height: MediaQuery.of(context).size.height,
                                    controller: codeController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: () => node.nextFocus(),
                                    placeholder: LanguageService.trans("post_num"),
                                    onChanged: (text) => {address1 = text, checkValid()},
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
                              detailAddrFocusNode!.requestFocus();
                              postcode = received["postcode"];
                              address1 = received["addr"];
                              checkValid();
                              codeController.text = postcode;
                              address1Controller.text = address1;
                              getHospitalFromAddress();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: UnderlineInput1(
                        controller: address1Controller,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () => node.nextFocus(),
                        placeholder: LanguageService.trans("address1"),
                        onChanged: (text) => {address1 = text, checkValid()},
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30),
                    //   child: UnderlineInput(
                    //     controller: address2Controller,
                    //     keyboardType: TextInputType.text,
                    //     textInputAction: TextInputAction.done,
                    //     focus: detailAddrFocusNode,
                    //     onEditingComplete: () => node.nextFocus(),
                    //     placeholder: LanguageService.trans("address2"),
                    //     onChanged: (text) => {address2 = text, checkValid()},
                    //   ),
                    // ),
                    Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                          child: TextField(
                            style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.medium),
                            maxLength: -1,
                            controller: address2Controller,
                            onEditingComplete: () => node.nextFocus(),
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.done,
                            focusNode: detailAddrFocusNode,
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
                            onChanged: (text) => {address2 = text, checkValid()},
                          ),
                        )),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: H14(
                        text: LanguageService.trans("call_hosiptal"),
                        weight: FW.medium,
                        color: AppColor_BlackText.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Selector(
                          selectedCategory: mCity,
                          categoryList: gCityList!,
                          onSelect: (selectedCategory) {
                            setState(() {
                              mCity = selectedCategory!;
                              mDistrict = "";
                              getDistrictList();
                            });
                          },
                          hint: ""),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Selector(
                          selectedCategory: mDistrict,
                          categoryList: districtList,
                          onSelect: (selectedCategory) {
                            setState(() {
                              mDistrict = selectedCategory!;
                              mHospital = "";
                              hospitalList = [];
                              getHosiptalList();
                            });
                          },
                          hint: LanguageService.trans("go_select")),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Selector(
                          selectedCategory: mHospital,
                          categoryList: hospitalList,
                          onSelect: (selectedCategory) {
                            setState(() {
                              mHospital = selectedCategory!;
                              for (int i = 0; i < arrHospitalList.length + 1; i++) {
                                HospitalDto info = arrHospitalList.elementAt(i);
                                if (info.name == mHospital) {
                                  hosiptalId = info.id!;
                                }
                              }
                            });
                          },
                          hint: LanguageService.trans("choose_hospital")),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MainTextButton(
                        text: valid ? LanguageService.trans("to_save") : LanguageService.trans("fill_warning"),
                        backgroundColor: AppColor_Green,
                        style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                        disable: !valid,
                        disableBackground: !valid ? AppColor_Green_Disable : Colors.transparent,
                        onPressed: () {
                          onSave();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
