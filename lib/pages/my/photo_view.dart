import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/zoom.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

/**
 * 사진보기, 유튜브보기
 */
class PhotoViewPage extends StatefulWidget {
  PhotoViewPage({Key? key, this.imgs, this.type}) : super(key: key);

  List<String>? imgs;
  int? type;

  @override
  PhotoViewPageState createState() => PhotoViewPageState();
}

class PhotoViewPageState extends BaseState<PhotoViewPage> {
  List<String> arrImgList = [];
  bool _isLoading = false;
  int _selectedImgIndex = 0;
  @override
  BuildContext getContext() {
    // TODO: implement getContext
    return context;
  }

  checkImgs() {
    if(widget.imgs != null && widget.imgs != []) {
      arrImgList = widget.imgs!;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    checkImgs();
    // arrImgList = widget.imgs!;
    log(widget.type!.toString());

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  String getImgName() {
    if (widget.type == 1) {
      return "assets/img_table2.png";
    } else if (widget.type == 2) {
      return "assets/img_health_calendar.png";
    } else if (widget.type == 3) {
      return "assets/img_vacine_calendar.png";
    } else if (widget.type == 4) {
      return "assets/img_table1.png";
    } else {
      return "";
    }
  }

  Future<void> fileDownload() async {
    if (widget.type == 0) {
      return;
    }
    String fileName = "";
    if (widget.type == 1) {
      fileName = "img_table2.png";
    } else if (widget.type == 2) {
      fileName = "img_health_calendar.png";
    } else if (widget.type == 3) {
      fileName = "img_vacine_calendar.png";
    }

    File f = await getImageFileFromAssets(fileName);
    showToast("파일 다운 로드 되었습니다.");
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white, //하단된 포함된 백그라운드
              child: Scaffold(
                  body: ModalProgressHUD(
                inAsyncCall: _isLoading,
                child: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white, //기본 화면 백그라운드
                    //높이 50 헤더 - PrimaryColor
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Container(
                              //hearer
                              height: 55,
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => {Navigator.pop(context)},
                                    child: Container(
                                      width: 56,
                                      height: MediaQuery.of(context).size.height,
                                      child: Row(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.only(left: 15.0),
                                          ),
                                          Image.asset(
                                            'assets/path_12225.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      '사진보기',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: "NotoSansKR", color: AppColor_BlackText, fontSize: 18, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: InkWell(
                                      onTap: () {
                                        fileDownload();
                                      },
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Visibility(
                                          //visible: widget.type! > 0,
                                          visible: false,
                                          child: Image.asset(
                                            'assets/ic_download.png',
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15.0),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: [
                                      Visibility(
                                        visible: widget.type == 0,
                                        child: PageView.builder(
                                          itemCount: arrImgList.length,
                                          controller: PageController(viewportFraction: 1),
                                          itemBuilder: (BuildContext context, int index) {
                                            return _getTitles(index, false);
                                          },
                                          onPageChanged: (int index) => setState(() => _selectedImgIndex = index),
                                        ),
                                      ),
                                      Visibility(
                                        visible: widget.type! == 1,
                                        child: _getTitles(0, true),
                                      ),
                                      Visibility(
                                        visible: widget.type! > 1,
                                        child: Container(
                                          child: PhotoView(
                                            imageProvider: AssetImage(getImgName()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Visibility(
                              visible: widget.type == 0 || arrImgList.length > 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                                child: Center(
                                  child: DotsIndicator(
                                    dotsCount: arrImgList.isEmpty ? 1 : arrImgList.length,
                                    position: _selectedImgIndex.toDouble(),
                                    decorator: DotsDecorator(
                                      color: const Color(0xFF000000).withOpacity(0.12), // Inactive color
                                      activeColor: const Color(0xFF332A2F),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTitles(int index, bool asset) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ClipRect(
          child: Zoom(
              child: asset 
              ? Image.asset(
                arrImgList.elementAt(index),
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
              )
              : Image.network(
              arrImgList.elementAt(index),
              fit: BoxFit.fitWidth,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
            ),
          ),
        ));
  }
}