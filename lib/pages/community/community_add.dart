import 'dart:async';
import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/community_add_res_model.dart';
import 'package:ourdoctor/models/community_detail_res_model.dart';
import 'package:ourdoctor/models/upload_res_model.dart';
import 'package:ourdoctor/pages/app_event.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout1.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/option_sheet.dart';
import 'package:ourdoctor/pages/components/photo_dialog.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class AddCommunityPage extends StatefulWidget {
  AddCommunityPage({Key? key, required this.uid, this.info, this.topic = ""}) : super(key: key);
  String? uid;
  String? topic;
  CommunityDetailDto? info;

  @override
  AddCommunityPageState createState() => AddCommunityPageState();
}

class AddCommunityPageState extends BaseState<AddCommunityPage> {
  final HttpService httpService = HttpService();
  String topic = "";
  String title = "";
  String content = "";
  String topicImage = "";
  String _age = "";
  String _ageIdx = "";
  bool bSecret = false;
  final imagePicker = ImagePicker();
  //List<String> topicList = ["교육", "질문", "자유게시판", "우아팁"];
  List<String> topicList = ["질문", "자유게시판"];
  final ageList = ["0-12개월", "13-36개월", "37-72개월", "초1-3학년", "초4-6학년"];

  final titleController = TextEditingController();
  final contentsController = TextEditingController();
  List<String> imgList = [];
  final FocusNode _nodeText = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.uid != "") {
      //편집인 경우
      if (widget.info!.topic! == "notice") {
        topic = "공지/이벤트";
      } else if (widget.info!.topic! == "treatment") {
        topic = "뉴스";
      } else if (widget.info!.topic! == "school") {
        topic = "교육";
      } else if (widget.info!.topic! == "faq") {
        topic = "질문";
      } else if (widget.info!.topic! == "talk") {
        topic = "자유게시판";
      } else {
        topic = "우아팁";
      }

      if(widget.info!.topic! == 'faq') {
        checkAge();
      }

      title = widget.info!.title!;
      content = widget.info!.content!;
      topicImage = widget.info!.imgUrl!;
      titleController.text = title;
      contentsController.text = content;

      if (widget.info!.imgUrls!.isEmpty) {
        return;
      }

      var imgUrls = widget.info!.imgUrls!;
      var lastChar = imgUrls.substring(imgUrls.length - 1, imgUrls.length);
      if (lastChar == ",") {
        imgUrls = imgUrls.substring(0, imgUrls.length - 1);
      }
      imgList = imgUrls.split(",");
      setState(() {});
    } else {
      topic = widget.topic!;
      setState(() {});
    }
  }

  void checkAge() {
    if(widget.info!.age!.isNotEmpty && widget.info!.age!.length == 1) {
      switch(widget.info!.age!) {
        case '0':
          _age = ageList[0];
          break;
        case '1':
          _age = ageList[1]; 
          break;
        case '2':
          _age = ageList[2];  
          break;
        case '3':
          _age = ageList[3];
          break;
        case '4':
          _age = ageList[4];
          break;
      }
    } else {
      _age = '';
    }
    setState(() {});
  } 

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void onSelectPhoto() {
    if (imgList.length > 10) {
      showToast("최대 10장까지 등록가능합니다.");
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return PhotoDialog(onGallery: getGalleryImageAndCrop, onCamera: getCameraImageAndCrop);
        });
  }

  void getGalleryImageAndCrop() async {
    Navigator.pop(context);
    final selectedImages = await imagePicker.pickMultiImage();
    if(selectedImages != null && selectedImages != []) {
      for(var i=0; i<selectedImages.length; i++) {
        var _convertedFile = File(selectedImages[i].path);
        uploadFile(_convertedFile);
      }
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
        lockAspectRatio: false,
      ),
    );
    return croppedFile;
  }

  void addcommunity() {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    if (topic == "") {
      showToast(LanguageService.trans('select_topic'));
      return;
    }

    if (title == "") {
      showToast(LanguageService.trans('input_title'));
      return;
    }

    if (content == "") {
      showToast(LanguageService.trans('input_content'));
      return;
    }

    if (imgList.length > 10) {
      showToast("최대 10장까지 등록가능합니다.");
      return;
    }

    if (topic == "질문" && _age == "") {
      showToast("연령을 선택해 주세요.");
      return;
    }

    reqCommunityWrite();
  }

  void selectTopic() {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return OptionSheet(
              list: topicList,
              title: LanguageService.trans('choose_topic'),
              selectedItem: topic,
              onPop: (selectedIndex) {
                if (selectedIndex != -1) {
                  setState(() {
                    topic = topicList[selectedIndex];
                  });
                } else {
                  // setState(() {
                  //   topic = '';
                  // });
                }
              });
        });
  }

  void selectAge() {
    if (keyboardIsVisible(context)) {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OptionSheet(
        list: ageList, 
        selectedItem: _age,
        title: '아동 연령 선택', 
        onPop: (selectedIdx) {
          if(selectedIdx != -1) {
            setState(() {
              _age = ageList[selectedIdx];
            });
          }
        },
      ),
    );
  }

  // Network functions
  //////////////////////////////////
  //파일 업로드
  void uploadFile(File uploadFile) {
    if(imgList.length > 10) {
      showToast("최대 10장까지 등록가능합니다.");
    } else {
      setState(() {
        isLoading = true;
      });

     log('imgList - ${imgList.length.toString()}');

    Future<FileUploadResModel> uploadInfo = httpService.uploadFile(uploadFile);
    uploadInfo.then((FileUploadResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        //topicImage = value.data!.fileUrl!;
        imgList.add(value.data!.fileUrl!);
        setState(() {});
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
  }

  //커뮤니티 쓰기
  void reqCommunityWrite() {
    setState(() {
      isLoading = true;
    });

    String enTopic = "";
    if (topic == "질문") {
      enTopic = "faq";
    } else if (topic == "뉴스") {
      enTopic = "treatment";
    } else if (topic == "교육") {
      enTopic = "school";
    } else if (topic == "우아팁") {
      enTopic = "team";
    } else if (topic == "자유게시판") {
      enTopic = "talk";
    }

    if(topic == '질문') {
      _ageIdx = ageList.indexWhere((e) => e == _age).toString();
    }

    String imgs = "";
    if (imgList.isNotEmpty) {
      for (int i = 0; i < imgList.length; i++) {
        if (imgs == "") {
          imgs = imgList[i];
        } else {
          imgs = imgs + "," + imgList[i];
        }
      }
    }

    Future<CommunityAddResModel> uploadInfo = httpService.communityAdd(
      enTopic, title, content, topicImage, widget.uid!, bSecret ? "1" : "0", imgs, _ageIdx,
    );
    
    uploadInfo.then((CommunityAddResModel value) {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        if (widget.uid! != "") {
          log(content);
          eventBus.fire(EditCommunityEvent());
          showToast(LanguageService.trans('edit_community'));
        } else {
          eventBus.fire(AddCommunityEvent());
          showToast(LanguageService.trans('add_community'));
        }
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

  reorderPictures(int prevIdx, int currIdx) {
    if(currIdx>prevIdx) {
      currIdx-=1;
    }
    final items = imgList.removeAt(prevIdx);
    imgList.insert(currIdx, items);
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText,
        ),
      ]
    );
  }


  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return PageLayout1(
        isAvoidResize: false,
        isLoading: isLoading,
        child: WillPopScope(
          onWillPop: onBackPressed,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                      padding: const EdgeInsets.only(right: 30),
                      height: 55,
                      child: Row( 
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              onBackPressed();
                            },
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Image.asset(
                                'assets/path_12225.png',
                                width: 10,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: H18(
                                text: widget.uid != "" ? "글 수정하기" : "글 작성하기",
                                weight: FW.medium,
                                color: AppColor_BlackText,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: addcommunity,
                            child: H18(
                              text: keyboardIsVisible(context) ? "완료" : (widget.uid != "" ? "변경" : "등록"),
                              weight: FW.medium,
                              height: 1.0,
                              color: AppColor_Primary,
                            ),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Text(topic == '' ? LanguageService.trans('select_topic') : topic, style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular)), Image.asset('assets/Down.png', width: 15)],
                              ),
                              onTap: selectTopic,
                            ),
                          ),
                          divider(),
                          topic == '질문' 
                          ? subCategory()
                          : const SizedBox(),
                          const SizedBox(height: 10),
                          UnderlineInput(
                            focus: _nodeText,
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            placeholder: LanguageService.trans("input_title"),
                            onChanged: (text) => {title = text},
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                              height: 200,
                              child: KeyboardActions(
                                config: _buildConfig(context),
                                child: TextField(
                                  focusNode: _nodeText,
                                  controller: contentsController,
                                  style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular, height: 1.2),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  onEditingComplete: () => node.unfocus(),
                                  decoration: InputDecoration(
                                    hintText: LanguageService.trans("input_content"),
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintStyle: AppTextStyle.PD(AppColor_Hint, 16, weight: FW.regular),
                                  ),
                                  onChanged: (text) {
                                    content = text;
                                  },
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          // Visibility(
                          //   visible: topicImage != "",
                          //   child: Expanded(
                          //     child: SizedBox(
                          //       width: double.infinity,
                          //       child: Image.network(
                          //         topicImage,
                          //         width: MediaQuery.of(context).size.width - 60,
                          //         height: MediaQuery.of(context).size.width - 60,
                          //         fit: BoxFit.contain,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Expanded(child: Container()),
                          Visibility(
                            visible: imgList.isNotEmpty,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              child: 
                               ReorderableListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      key: ValueKey(imgList[index]),
                                      margin: const EdgeInsets.only(right: 10),
                                      height: 150,
                                      width: 150,
                                      child: Stack(
                                        children: [
                                          ClipPath(
                                            clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                            child: ExtendedImage(
                                              image: NetworkImage(imgList[index]),
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    imgList.removeAt(index);
                                                  });
                                                },
                                                child: const Icon(Icons.delete)),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: imgList.length,
                                  onReorder: reorderPictures,
                                ),
                              
                              // ListView.builder(
                              //     scrollDirection: Axis.horizontal,
                              //     shrinkWrap: true,
                              //     itemBuilder: (BuildContext context, int index) {
                              //       return Container(
                              //         margin: const EdgeInsets.only(right: 10),
                              //         height: 150,
                              //         width: 150,
                              //         child: Stack(
                              //           children: [
                              //             ClipPath(
                              //               clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              //               child: ExtendedImage(
                              //                 image: NetworkImage(imgList[index]),
                              //                 height: 150,
                              //                 width: 150,
                              //                 fit: BoxFit.cover,
                              //               ),
                              //             ),
                              //             Positioned(
                              //               right: 10,
                              //               top: 10,
                              //               child: InkWell(
                              //                   onTap: () {
                              //                     setState(() {
                              //                       imgList.removeAt(index);
                              //                     });
                              //                   },
                              //                   child: const Icon(Icons.delete)),
                              //             )
                              //           ],
                              //         ),
                              //       );
                              //     },
                              //     itemCount: imgList.length
                              //   ),
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
                      Row(
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
                                    text: LanguageService.trans("add_photo") + " (" + imgList.length.toString() + "/10)",
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
                          InkWell(
                            onTap: () {
                              setState(() {
                                bSecret = !bSecret;
                              });
                            },
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: topic == "자유게시판"? Container() :
                              Row(
                                children: [
                                  Image.asset(
                                    bSecret ? 'assets/ic_rect_check_on.png' : 'assets/ic_rect_check_off.png',
                                    width: 22,
                                    height: 22,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 8),
                                  H14(
                                    text: "비밀글",
                                    weight: FW.regular,
                                    height: 1.0,
                                    color: AppColor_BlackText.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

subCategory() => Column(
  children: [
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: selectAge,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _age == '' && _age.isEmpty ? '연령' : _age,
              style: AppTextStyle.PD(AppColor_BlackText, 16, weight: FW.regular)
            ),
            Image.asset('assets/Down.png', width: 15)
          ],
        ),
      ),
    ),
    divider(),
  ],
);

divider() => Container(
  height: 1,
  color: AppColor_BlackText.withOpacity(0.1),
);
}
