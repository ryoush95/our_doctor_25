import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/home_disease_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout1.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class SymptomPaperDetailPage extends StatefulWidget {
  SymptomPaperDetailPage({Key? key, required this.data}) : super(key: key);

  SymptomList data;

  @override
  SymptomPaperDetailPageState createState() => SymptomPaperDetailPageState();
}

class SymptomPaperDetailPageState extends BaseState<SymptomPaperDetailPage> {
  final HttpService httpService = HttpService();
  late SymptomList s;

  //리스트뷰 컨트롤러
  late ScrollController controller;
  int _selectedImgIndex = 0;
  List<String> arrImgList = [];

  @override
  void initState() {
    super.initState();
    s = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout1(
        isLoading: isLoading,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            child: Column(
              children: [
                Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 20),
                            child: Image.asset(
                              'assets/path_12225.png',
                              width: 10,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: H18(
                              text: s.symptom!,
                              color: AppColor_BlackText,
                              weight: FW.regular,
                              maxLine: 10,
                              align: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 1,
                            color: AppColor_BlackText.withOpacity(0.1),
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          //NOTE: content
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            margin: EdgeInsets.only(top: 25),
                            child: Linkify(
                              text: "",
                              maxLines: 150,
                              textAlign: TextAlign.start,
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 50,
                            margin: const EdgeInsets.only(top: 30.0),
                            child: StreamBuilder<Object>(
                              stream: null,
                              builder: (context, snapshot) {
                                return Stack(
                                  children: <Widget>[
                                    PageView.builder(
                                      itemCount: 1,
                                      controller:
                                          PageController(viewportFraction: 1),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        print(s.medicationUrl!);
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 25),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  SlideRightTransRoute(
                                                      builder: (context) =>
                                                          PhotoViewPage(imgs: [s.medicationUrl!], type: 0)));
                                            },
                                            child: ExtendedImage.network(
                                              s.medicationUrl!,
                                              fit: BoxFit.contain,
                                              cache: true,
                                            ),
                                          ),
                                        );
                                      },
                                      onPageChanged: (int index) => setState(
                                          () => _selectedImgIndex = index),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // arrImgList.length > 1
                          //     ? Visibility(
                          //         visible: arrImgList.isNotEmpty,
                          //         child: Container(
                          //           width: MediaQuery.of(context).size.width,
                          //           margin: const EdgeInsets.only(top: 5.0),
                          //           child: Center(
                          //             child: DotsIndicator(
                          //               dotsCount: arrImgList.isEmpty
                          //                   ? 1
                          //                   : arrImgList.length,
                          //               position:
                          //                   _selectedImgIndex.toDouble(),
                          //               decorator: DotsDecorator(
                          //                 color: const Color(0xFF000000)
                          //                     .withOpacity(
                          //                         0.12), // Inactive color
                          //                 activeColor:
                          //                     const Color(0xFF332A2F),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
