import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/text_highlighting.dart';
import 'package:ourdoctor/pages/home/symptom_paper_detail.dart';

class SymtomPaperList extends StatefulWidget {
  const SymtomPaperList({Key? key}) : super(key: key);

  @override
  State<SymtomPaperList> createState() => _SymtomPaperListState();
}

class _SymtomPaperListState extends BaseState<SymtomPaperList> {
  HttpService httpService = new HttpService();

  String img = "https://blog.kakaocdn.net/dn/XsNHt/btrb3m0cuQb/62QmvGg1bUVrI5uZfcWEi1/img.png";


  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      onBack: onBackPressed,
        isLoading: isLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SimpleHeader(
              title: "처방전 기록",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, SlideRightTransRoute(builder: (context) => SymptomPaperDetailPage(),));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: const BoxDecoration(
                          color: AppColor_Light_Gray,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(left: 20, right: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DynamicTextHighlighting(
                                      text: "제목ㅁㅁㄱㅁㄱㅁㄱㅁㄱㅁㄱㅁ",
                                      highlights: [],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor_BlackText,
                                        height: 1.1,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      color: AppColor_Yellow,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            "date",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColor_BlackText.withOpacity(.4),
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            maxFontSize: 12,
                                            minFontSize: 8,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width:  60,
                              height: 60,
                              margin: const EdgeInsets.only(right: 20),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  img,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}
