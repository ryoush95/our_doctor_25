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
import 'package:ourdoctor/models/review_detail_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:sprintf/sprintf.dart';

class EditReviewPage extends StatefulWidget {
  EditReviewPage({Key? key, required this.review}) : super(key: key);
  ReviewDetailDto? review;

  @override
  EditReviewPageState createState() => EditReviewPageState();
}

class EditReviewPageState extends BaseState<EditReviewPage> {
  final HttpService httpService = HttpService();
  bool valid = true;
  final contentsController = TextEditingController();
  String content = "";
  final imagePicker = ImagePicker();
  late ScrollController _listController;
  int star = -1;
  List<String> images = [];
  List<String> imageNames = [];
  int imageCount = 0;

  String profileImage = "";

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    star = int.parse(widget.review!.rating!) - 1;
    imageNames = widget.review!.photosUrl!.split(",");
    images = widget.review!.photos!.split(",");
    imageCount = images.length;
    images.add("");
    images.add("");
    content = widget.review!.text!;
    contentsController.text = content;
    setState(() {});
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _listController.dispose();
    super.dispose();
  }

  String? getReviewPoint(String type) {
    String result = "";
    for (int i = 0; i < gReviewPoint!.length; i++) {
      if (type == gReviewPoint!.elementAt(i).TYPE) {
        return gReviewPoint!.elementAt(i).value;
      }
    }
    return result;
  }

  Future<bool> onBackPressed() async {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    Navigator.of(context).pop();
    return true;
  }

  void onSelectPhoto() {
    FocusScope.of(context).requestFocus(FocusNode());
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
        images[imageCount] = value.data!.fileUrl!;

        imageCount = imageCount + 1;
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

  void checkValid() {
    int imgCount = 0;
    for (int i = 0; i < imageCount; i++) {
      if (imageNames[i] != "") {
        imgCount++;
      }
    }
    if (content.length < 20 || star == -1 || imgCount == 0) {
      setState(() {
        valid = false;
      });
    } else {
      setState(() {
        valid = true;
      });
    }
  }

  // Network functions
  //////////////////////////////////
  //리뷰수정
  Future<void> reqEdit() async {
    String photos = "";
    for (int i = 0; i < imageCount; i++) {
      if (imageNames[i] != "") {
        if (photos == "") {
          photos = imageNames[i];
        } else {
          photos = photos + ", " + imageNames[i];
        }
      }
    }
    setState(() {
      isLoading = true;
    });
    Future<DefaultResModel> offInfo = httpService.editReview(widget.review!.id!, (star + 1).toString(), content, photos);
    offInfo.then((DefaultResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        showToast(LanguageService.trans('review_edit_success'));
        eventBus.fire(EditReviewEvent());
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
              title: "후기 수정하기",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              ExtendedImage.network(widget.review!.mainImage!, width: 80, height: 80, fit: BoxFit.fill, cache: true, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(6))),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H16(text: widget.review!.name!, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.8)),
                                  const SizedBox(height: 5),
                                  H14(text: widget.review!.optionName!, weight: FW.medium, color: AppColor_BlackText.withOpacity(0.4)),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                      height: 20,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: _itemBuilder,
                                        itemCount: 5,
                                      ))
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 32),
                          Container(
                              height: 115,
                              decoration: BoxDecoration(
                                color: AppColor_Light_Gray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              child: TextField(
                                controller: contentsController,
                                style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                // maxLength: 20,
                                decoration: InputDecoration(
                                  hintText: LanguageService.trans("review_content_hint"),
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.regular),
                                ),
                                onChanged: (text) {
                                  content = text;
                                  setState(() {});
                                  checkValid();
                                },
                              )),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: Container()),
                            H16(text: sprintf("%s / %s", [content.length.toString(), "최소 20자"]), weight: FW.medium, color: AppColor_414141),
                          ]),
                          const SizedBox(height: 15),
                          InkWell(
                              onTap: () {
                                if (imageCount == 4) {
                                  showToast("사진은 최대 4장까지 등록 가능합니다.");
                                  return;
                                }
                                onSelectPhoto();
                              },
                              child: Container(
                                  width: 110,
                                  decoration: BoxDecoration(border: Border.all(color: AppColor_BlackText), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/camera_alt_black_24dp.png", width: 16),
                                      const SizedBox(width: 10),
                                      H14(text: sprintf("%s %s/4", ["사진", imageCount.toString()]), weight: FW.regular)
                                    ],
                                  ))),
                          const SizedBox(height: 10),
                          Visibility(
                              visible: imageCount > 0,
                              child: Container(
                                  height: 160,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: _itemBuilder1,
                                    itemCount: imageCount,
                                    controller: _listController,
                                  ))),
                          const SizedBox(height: 15),
                          H12(text: "상품과 무관한 사진을 첨부할 시 노출 제한 처리될 수 있습니다.\n개인정보가 포함된 사진은 포함되지 않도록 유의해주세요.", color: AppColor_GrayText, maxLine: 3, height: 1.5, align: TextAlign.left, weight: FW.regular),
                          const SizedBox(height: 10)
                        ])),
                    const Divider(thickness: 10, color: AppColor_Light_Gray),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Row(children: [
                            H14(text: LanguageService.trans("text_review"), weight: FW.regular, color: AppColor_BlackText.withOpacity(0.8)),
                            Expanded(child: Container()),
                            H14(text: sprintf("%s p", [getReviewPoint("REVIEW_TEXT_POINT")]), weight: FW.semi_bold, color: AppColor_BlackText.withOpacity(0.8)),
                          ]),
                          const SizedBox(height: 15),
                          Row(children: [
                            H16(text: LanguageService.trans("photo_review"), weight: FW.regular, color: AppColor_BlackText.withOpacity(0.8)),
                            Expanded(child: Container()),
                            H14(text: sprintf("%s p", [getReviewPoint("REVIEW_IMAGE_POINT")]), weight: FW.semi_bold, color: AppColor_414141),
                          ]),
                          const SizedBox(height: 20),
                          H14(
                              text: "- 작성 완료된 리뷰는 7일 이내 수정/삭제가 가능합니다.\n- 리뷰 작성 완료 후 약 1일 이내 포인트가 지급되며 지급 시기는 운영 사정에 따라 달라질 수 있습니다.\n- 작성된 내용 검토 후 광고, 비방 등 부적절한 내용이 있을 경우/상품과 무관하거나 부적절한 사진을 첨부한 경우 노출 제한 처리와 차후 후기 작성에 제한이 생길 수 있습니다.",
                              color: AppColor_GrayText,
                              maxLine: 8,
                              height: 1.5,
                              align: TextAlign.left,
                              weight: FW.regular),
                          const SizedBox(height: 15),
                          MainTextButton(
                            text: "수정완료",
                            backgroundColor: AppColor_Primary,
                            style: AppTextStyle.PD(Colors.white, 18, weight: FW.bold),
                            disable: !valid,
                            disableBackground: !valid ? AppColor_Primary_Disable : Colors.transparent,
                            onPressed: () {
                              reqEdit();
                            },
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        star = index;
        checkValid();
        setState(() {});
      },
      child: Image.asset(index <= star ? "assets/ic_star_on.png" : "assets/ic_star_off.png"),
    );
  }

  Widget _itemBuilder1(BuildContext context, int index) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        ExtendedImage.network(imageNames[index],
            width: 160,
            height: 160,
            fit: BoxFit.fill,
            cache: true,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            )),
        const SizedBox(width: 10),
      ],
    );
  }
}
