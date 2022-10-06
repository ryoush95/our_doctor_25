import 'dart:async';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/home_disease_res_model.dart';
import 'package:ourdoctor/models/home_monitor_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/round_container.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class InfoArea extends StatefulWidget {
  final type;

  InfoArea({Key? key, this.type}) : super(key: key);

  @override
  InfoAreaState createState() => InfoAreaState();
}

class InfoAreaState extends BaseState<InfoArea> {
  final HttpService httpService = HttpService();
  HomeMonitorDto? dicHomeDataInfo;
  final imagePicker = ImagePicker();
  String? finalMeasureDate = "";
  String not_measure = LanguageService.trans("not_measured");
  String newDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  HOmeSymptomGraphDto? dicDiseaseInfo;
  int type = 0;
  String firstSym = "";
  String profileImage = "";

  @override
  void initState() {
    super.initState();

    getMonitor2HomeDataInfo();
    eventBus.on<SelectChildEvent>().listen((event) {
      if (mounted) {
        getMonitor2HomeDataInfo();
      }
    });
  }

  void onSelectPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(
              onGallery: getGalleryImageAndCrop,
              onCamera: getCameraImageAndCrop,
              onprofileImage: getProfileImage,);
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
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: LanguageService.trans('image_crop'),
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    return croppedFile;
  }

  void connect() {
    callPhone(context);
  }

  void emergencyCall() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 215,
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                H18(
                    text: LanguageService.trans('want_emergency_call'),
                    height: 1.5),
                H18(
                    text: LanguageService.trans('emergency_call_detail'),
                    height: 1.5,
                    weight: FW.regular),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: H16(
                            text: LanguageService.trans('connect'),
                            color: AppColor_Red,
                            weight: FW.medium),
                        onTap: () {
                          Navigator.pop(context);
                          connect();
                        },
                      ),
                      InkWell(
                        child: H16(
                            text: LanguageService.trans('cancel'),
                            weight: FW.medium),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  // Network functions
  //////////////////////////////////
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
        reqUserEdit(value.data!.fileUrl!);
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //정보수정하기
  Future<void> reqUserEdit(String profile) async {
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> offerInfo =
        httpService.userEdit("", "", "", "", profile);
    offerInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('update_user_profile'));
        gSelChildInfo!.profileImgUrl = profile;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      showToast(onError);
    });
  }

  //홈 발달 리포트 얻기
  Future<void> getMonitor2HomeDataInfo() async {
    setState(() {
      isLoading = true;
    });

    Future<HOmeSymptomGraphResModel> info2 = httpService.homeDiseaseGraph(newDate);
    info2.then((HOmeSymptomGraphResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (value.data!.symptomList!.isEmpty) {
          type = 0;
        } else {
          type = 1;
        }
        dicDiseaseInfo = value.data;
        setState(() {
          if(type == 1){
            firstSym = dicDiseaseInfo!.symptomList![0].symptom!;
          }
        });
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

    Future<HomeMonitorResModel> info = httpService.homeMonitorInfo();
    info.then((HomeMonitorResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        dicHomeDataInfo = value.data!;
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(
              context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      height: 210,
      child: RoundContainer(
        child: Row(
          children: [
            Container(
              width: 120,
              height: 180,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 18),
                  InkWell(
                    //onTap: onSelectPhoto,
                    child: SizedBox(
                      width: 84,
                      height: 84,
                      child: Stack(
                        children: [
                          Visibility(
                            visible: (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.profileImgUrl!.isEmpty) ||
                                dicHomeDataInfo!.profileImgUrl!
                                    .contains("img_photo_default"),
                            child: Center(
                              child: RoundContainer(
                                width: 76.0,
                                height: 76.0,
                                bgColor: Colors.white,
                                child: Center(
                                  child: Image.asset(
                                      (dicHomeDataInfo == null ||
                                              dicHomeDataInfo!.gender == 1)
                                          ? 'assets/ic_default_male.png'
                                          : 'assets/ic_default_female.png',
                                      width: 45),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: dicHomeDataInfo != null &&
                                dicHomeDataInfo!.profileImgUrl!.isNotEmpty &&
                                !dicHomeDataInfo!.profileImgUrl!
                                    .contains("img_photo_default"),
                            child: ExtendedImage.network(
                              dicHomeDataInfo == null
                                  ? ""
                                  : dicHomeDataInfo!.profileImgUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              cache: true,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                  'assets/add_circle_black_24dp.png',
                                  width: 22),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          (dicHomeDataInfo == null ||
                                  dicHomeDataInfo!.gender == 1)
                              ? 'assets/ic_male.png'
                              : 'assets/ic_female.png',
                          width: 15),
                      const SizedBox(width: 2),
                      H18(
                        text: dicHomeDataInfo == null
                            ? ""
                            : dicHomeDataInfo!.name!,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  H16(
                      text: dicHomeDataInfo == null
                          ? "0"
                          : dicHomeDataInfo!.age.toString() +
                              LanguageService.trans('sae'),
                      weight: FW.regular),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (widget.type == 0)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              H16(
                                  text: dicHomeDataInfo == null
                                      ? "0"
                                      : dicHomeDataInfo!.height.toString(),
                                  weight: FW.bold),
                              H16(text: "cm", weight: FW.regular)
                            ],
                          ),
                          H16(
                            text: (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.heightDiagnose == null)
                                ? "미측정"
                                : dicHomeDataInfo!.heightDiagnose!.result!,
                            weight: FW.bold,
                            color: (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.heightDiagnose == null)
                                ? AppColor_Primary
                                : getColorFromString(
                                    dicHomeDataInfo!.heightDiagnose!.color!),
                          ),
                          // const Padding(padding: EdgeInsets.only(right: 30.0)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              H16(
                                  text: dicHomeDataInfo == null
                                      ? "0"
                                      : dicHomeDataInfo!.weight.toString(),
                                  weight: FW.bold),
                              H16(text: "kg", weight: FW.regular)
                            ],
                          ),
                          H16(
                            text: (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.weightDiagnose == null)
                                ? "미측정"
                                : dicHomeDataInfo!.weightDiagnose!.result!,
                            weight: FW.bold,
                            color: (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.weightDiagnose == null)
                                ? AppColor_Primary
                                : getColorFromString(
                                    dicHomeDataInfo!.weightDiagnose!.color!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              H16(
                                  text: dicHomeDataInfo == null
                                      ? "0"
                                      : roundOff(dicHomeDataInfo!.kcal!),
                                  weight: FW.bold),
                              H16(text: "kcal", weight: FW.regular)
                            ],
                          ),
                          //H16(text: (dicInfo == null || dicInfo!.heartCnt! == "") ? LanguageService.trans('(0%-)') : (dicInfo!.heartCnt! == "-1" ? "측정하지 않음" : ("분당 " + dicInfo!.heartCnt! + "회")), weight: FW.bold, color: AppColor_Primary),
                          H16(
                              text: (dicHomeDataInfo == null ||
                                      dicHomeDataInfo!.kcalResult! == "")
                                  ? "미측정"
                                  : dicHomeDataInfo!.kcalResult!,
                              weight: FW.bold,
                              color: (dicHomeDataInfo == null ||
                                      dicHomeDataInfo!.kcalResult! == "")
                                  ? AppColor_Primary
                                  : getColorFromString2(
                                      dicHomeDataInfo!.kcalResult!)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              H16(
                                  text: dicHomeDataInfo == null
                                      ? "0"
                                      : dicHomeDataInfo!.sleep!
                                          .toStringAsFixed(1),
                                  weight: FW.bold),
                              H16(text: "시간", weight: FW.regular)
                            ],
                          ),
                          //H16(text: (dicInfo == null || dicInfo!.pillUrl! == "") ? LanguageService.trans('(0%-)') : LanguageService.trans('exist_taking_medication'), weight: FW.bold, color: AppColor_Primary),
                          H16(
                            text: (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.sleep! == 0)
                                ? "미측정"
                                : dicHomeDataInfo!.sleepResult!,
                            weight: FW.bold,
                            color: (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.sleepResult! == "")
                                ? AppColor_Primary
                                : getColorFromString1(
                                    dicHomeDataInfo!.sleepResult!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          H16(
                            text: "질병",
                            weight: FW.regular,
                          ),
                          H16(
                            text: type == 0
                                ? " 질병 없음"
                                : " $firstSym",
                            weight: FW.regular,
                            color: Colors.red,
                          ),
                          type == 1 && dicDiseaseInfo!.symptomList!.length > 1
                              ? Row(
                                children: [
                                  H16(
                                    text: " 외 ",
                                    weight: FW.regular,
                                  ),
                                  H16(
                                    text: " ${dicDiseaseInfo!.symptomList!.length -1}",
                                    weight: FW.regular,
                                    color: Colors.red,
                                  )
                                ],
                              ):const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 7),
                      H14(
                        text: LanguageService.trans('final_measurement') +
                            ' : ' +
                            (dicHomeDataInfo == null ||
                                    dicHomeDataInfo!.bodyLastDate == ""
                                ? not_measure
                                : convertDate(dicHomeDataInfo!.bodyLastDate!)),
                        color: const Color(0xFFb2b3b3),
                        weight: FW.regular,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !isMoreBirth1(85),
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H16(
                                    text: LanguageService.trans('language_age'),
                                    weight: FW.medium),
                                //H16(text: (dicInfo == null || dicInfo!.temperature! == "" ) ? LanguageService.trans('0 ') + LanguageService.trans('sae') : (dicInfo!.temperature! + "℃"), weight: FW.bold, color: AppColor_Primary),
                                H16(
                                  text: (dicHomeDataInfo == null ||
                                          dicHomeDataInfo!.language == "")
                                      ? "미측정"
                                      : dicHomeDataInfo!.language.toString(),
                                  weight: FW.bold,
                                  color: (dicHomeDataInfo == null ||
                                          dicHomeDataInfo!.language! == "")
                                      ? AppColor_Primary
                                      : getColorFromString1(
                                          dicHomeDataInfo!.language!),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H16(
                                    text: LanguageService.trans('athletic_age'),
                                    weight: FW.medium),
                                //H16(text: (dicInfo == null || dicInfo!.oxygen! == "") ? LanguageService.trans('0 ') + LanguageService.trans('sae') : (dicInfo!.oxygen! == "-1" ? "측정하지 않음" : (dicInfo!.oxygen! + "%")), weight: FW.bold, color: AppColor_Primary),
                                H16(
                                  text: (dicHomeDataInfo == null ||
                                          dicHomeDataInfo!.workout == "")
                                      ? "미측정"
                                      : dicHomeDataInfo!.workout.toString(),
                                  weight: FW.bold,
                                  color: (dicHomeDataInfo == null ||
                                          dicHomeDataInfo!.workout! == "")
                                      ? AppColor_Primary
                                      : getColorFromString1(
                                          dicHomeDataInfo!.workout!),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H16(
                                    text: LanguageService.trans('social_age'),
                                    weight: FW.medium),
                                //H16(text: (dicInfo == null || dicInfo!.heartCnt! == "") ? LanguageService.trans('0 ') + LanguageService.trans('sae') : (dicInfo!.heartCnt! == "-1" ? "측정하지 않음" : ("분당 " + dicInfo!.heartCnt! + "회")), weight: FW.bold, color: AppColor_Primary),
                                H16(
                                  text: (dicHomeDataInfo == null ||
                                          dicHomeDataInfo!.social == "")
                                      ? "미측정"
                                      : dicHomeDataInfo!.social.toString(),
                                  weight: FW.bold,
                                  color: (dicHomeDataInfo == null ||
                                          dicHomeDataInfo!.social! == "")
                                      ? AppColor_Primary
                                      : getColorFromString1(
                                          dicHomeDataInfo!.social!),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                H16(text: "", weight: FW.medium),
                                Expanded(child: Container()),
                                //H16(text: (dicInfo == null || dicInfo!.pillUrl! == "") ? LanguageService.trans('0 ') + LanguageService.trans('sae') : LanguageService.trans('exist_taking_medication'), weight: FW.bold, color: AppColor_Primary),
                                const Padding(
                                    padding: EdgeInsets.only(right: 30.0)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                H16(
                                  text: (dicHomeDataInfo == null ||
                                          dicHomeDataInfo!.mchat == "")
                                      ? "맞춤검사 없음"
                                      : "맞춤검사 완료",
                                  weight: FW.regular,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isMoreBirth1(85),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              H16(
                                text: "맞춤검사",
                                weight: FW.regular,
                              ),
                              Expanded(child: Container()),
                              H16(
                                text: (dicHomeDataInfo == null ||
                                        dicHomeDataInfo!.mchat == "")
                                    ? "검사 필요"
                                    : "검사 완료",
                                weight: FW.bold,
                                color: AppColor_Primary,
                              ),
                              const SizedBox(width: 30),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    H14(
                      text: LanguageService.trans('final_measurement') +
                          ' : ' +
                          (dicHomeDataInfo == null ||
                                  dicHomeDataInfo!.brainLastDate == ""
                              ? not_measure
                              : convertDate(dicHomeDataInfo!.brainLastDate!)),
                      color: const Color(0xFFb2b3b3),
                      weight: FW.regular,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
