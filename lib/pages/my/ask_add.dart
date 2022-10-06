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
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class AddAskPage extends StatefulWidget {
  @override
  AddAskPageState createState() => AddAskPageState();
}

class AddAskPageState extends BaseState<AddAskPage> {
  final HttpService httpService = HttpService();
  String title = "";
  String content = "";
  String askImage = "";
  final imagePicker = ImagePicker();
  bool isValid = false;

  final titleController = TextEditingController();
  final contentsController = TextEditingController();
  
  String profileImage = "";

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void checkValid() {
    if (title.isEmpty || content.isEmpty) {
      setState(() {
        isValid = false;
      });
    } else {
      setState(() {
        isValid = true;
      });
    }
  }

  void onSelectPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(onGallery: getGalleryImageAndCrop, onCamera: getCameraImageAndCrop, onprofileImage: getProfileImage,);
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
        askImage = value.data!.fileUrl!;
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

  //커뮤니티 쓰기
  void reqAddAsk() {
    if (!isValid) {
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });

    Future<DefaultResModel> info = httpService.addAsk(title, content, askImage);
    info.then((DefaultResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        eventBus.fire(AddAskEvent());
        showToast(LanguageService.trans('add_ask_success'));
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

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return PageLayout(
        isAvoidResize: false,
        isLoading: isLoading,
        child: WillPopScope(
          onWillPop: onBackPressed,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
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
                              text: LanguageService.trans("ask"),
                              weight: FW.medium,
                              height: 1.5,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: reqAddAsk,
                          child: H18(
                            text: LanguageService.trans("register"),
                            weight: FW.medium,
                            height: 1.0,
                            color: isValid ? AppColor_Primary : AppColor_Primary.withOpacity(0.2),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        UnderlineInput(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          placeholder: LanguageService.trans("input_title"),
                          onChanged: (text) => {title = text, checkValid()},
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: TextField(
                            controller: contentsController,
                            style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular),
                            decoration: InputDecoration(
                              hintText: LanguageService.trans("input_content"),
                              counterText: "",
                              border: InputBorder.none,
                              hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.regular),
                            ),
                            onChanged: (text) {
                              content = text;
                              checkValid();
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: askImage != "",
                          child: Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.network(
                                askImage,
                                width: MediaQuery.of(context).size.width - 60,
                                height: MediaQuery.of(context).size.width - 60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  color: AppColor_Light_Gray,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: onSelectPhoto,
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/ic_camera.png',
                                width: 18,
                                height: 18,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              H14(
                                text: LanguageService.trans("add_photo"),
                                weight: FW.regular,
                                height: 1.0,
                                color: AppColor_BlackText.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
