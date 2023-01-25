import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/disease_report.dart';
import 'package:ourdoctor/pages/home/inspection_report.dart';
import 'package:ourdoctor/pages/home/lifestyle_line_chart2.dart';
import 'package:ourdoctor/pages/home/lifestyle_report.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:sprintf/sprintf.dart';

class MonitoringResult2 extends StatefulWidget {
  const MonitoringResult2({Key? key}) : super(key: key);

  @override
  State<MonitoringResult2> createState() => _MonitoringResult2State();
}

class _MonitoringResult2State extends BaseState<MonitoringResult2> {
  final HttpService httpService = HttpService();
  int tabIndex = 0;
  List<String> category = ["질병", "수면", "영양", "맞춤검사"];
  List<String> subTitle = ["아침식사", "점심식사", "간식", "저녁식사"];
  List<String> subCategory = [""];
  List<int> _data = [0,0,0,0,0,0,0];
  List<ReportDto> reportList = [];
  List<ReportDto> reportList1 = [];
  List<ReportDto> reportList2 = [];

  int curYear = 0;
  int curMonth = 0;
  DateTime now = DateTime.now();

  bool foodDetail = false;
  bool foodCheck = true;

  //test data
  HomeGraphLifeStyleDto? dicHomeGraphLifeStyleInfo;

  @override
  void initState() {
    super.initState();
    dicHomeGraphLifeStyleInfo = null;

    curYear = now.year;
    curMonth = now.month;
    getHomeGraphLifeStyle();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  //홈 그래프 생활습관 얻기
  Future<void> getHomeGraphLifeStyle() async {
    setState(() {
      isLoading = true;
    });

    String curDate = sprintf("%04d-%02d", [curYear, curMonth]);
    Future<HomeGraphLifeStyleResModel> info = httpService.homeGraphLifeStyle1(curDate);
    info.then((HomeGraphLifeStyleResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        setState(() {
          dicHomeGraphLifeStyleInfo = value.data!;
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
  }

  bool isTomorrowMonth() {
    int year = curYear;
    int month = curMonth;
    if (month + 1 == 13) {
      month = 1;
      year = year + 1;
    } else {
      month = month + 1;
    }

    if (DateTime(year,month).compareTo(now) > 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget _body() {
    if (tabIndex == 0) {
      // CATE : 질병
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: dicHomeGraphLifeStyleInfo == null ? Container(): LifestyleLineChart2(data:dicHomeGraphLifeStyleInfo!),
          ),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DiseaseReport(
                  data: reportList,
                  data1: reportList1,
                  data2: reportList2,
                  result: 1),
          ),
          const SizedBox(height: 50),
        ],
      );
    } else if (tabIndex == 1) {
      // CATE : 수면
      print(gUserInfo!.accessToken!);
      return dicHomeGraphLifeStyleInfo!.monitoringSleep != null
          ? Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    if (curMonth - 1 == 0) {
                      curMonth = 12;
                      curYear = curYear - 1;
                    } else {
                      curMonth = curMonth - 1;
                    }
                    setState(() {});
                    getHomeGraphLifeStyle();
                  },
                  child: Image.asset('assets/chevron_left_black_24dp.png', width: 20)),
              const SizedBox(width: 18),
              //H16(text: '${firstDate.month}월 ${numOfWeeks(firstDate)}주차' /*firstDateString + ' - ' + lastDateString*/, color: const Color(0xFF888888), weight: FW.semi_bold),
              H16(text: '$curYear년 $curMonth월', color: AppColor_BlackText.withOpacity(0.5), weight: FW.semi_bold),
              const SizedBox(width: 18),
              InkWell(
                  onTap: () {
                    // if (firstDate.subtract(const Duration(days: -7)).isAfter(now)) {
                    //   return;
                    // }
                    if (isTomorrowMonth()) {
                      return;
                    }

                    if (curMonth + 1 == 13) {
                      curMonth = 1;
                      curYear = curYear + 1;
                    } else {
                      curMonth = curMonth + 1;
                    }
                    setState(() {});
                    getHomeGraphLifeStyle();
                  },
                  child: Opacity(opacity: (now.year == curYear && now.month == curMonth) ? 0.2 : 1.0, child: Image.asset('assets/chevron_right_black_24dp.png', width: 20))),
              // const SizedBox(width: 10),
            ],
          ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: LifestyleReport(data: dicHomeGraphLifeStyleInfo!, result: 1)),
        ],
      ) : const SizedBox(
        child: Text("검사결과 없음"),
      );
    } else if (tabIndex == 2) {
      // CATE : 영양
      return Stack(
        children: [
          // firstPage(),
          secondPage(),
        ],
      );
    } else if (tabIndex == 3) {
      // CATE : 맞춤검사
      return Padding(
        padding: const EdgeInsets.only(left: 30.0,right: 30.0),
        child: InspectionReport(data: reportList, data1: reportList1, data2: reportList2),
      );
    }
    return CircularProgressIndicator();
  }

  Widget categoryTile(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          tabIndex = index;
          print(tabIndex);
        });
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: tabIndex == index ? AppColor_Primary : AppColor_f4f5f7),
          child: SizedBox(
            child: Stack(
              children: [
                Center(
                  child: H14(
                    text: category[index],
                    weight: FW.bold,
                    align: TextAlign.center,
                    maxLine: 1,
                    color: tabIndex == index
                        ? AppColor_White
                        : AppColor_BlackText.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PageLayout(
        onBack: onBackPressed,
        isLoading: isLoading,
        child: Column(
          children: [
            SimpleHeader(
              title: "모니터링 결과",
              onBackPressed: onBackPressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: screenSize.width,
                      height: 40,
                      margin: EdgeInsets.all(25),
                      child: GridView.builder(
                        // scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return categoryTile(index);
                        },
                        itemCount: category.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 2.5 / 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                      ),
                    ),
                    _body(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget firstPage() => Visibility(
      visible: !foodDetail,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H20(
              text: "우아냠냠 체크 리스트",
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Container(
                    height: 250,
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: AppColor_Light_Gray),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (_data[index] == 0){
                                  _data[index] = 1;
                                } else {
                                  _data[index] = 0;
                                }
                                setState(() {});
                              },
                              child: Row(children: [
                                Image.asset(
                                  _data[index] == 0 ? "assets/ic_radio_off.png"
                                      :"assets/ic_radio_on.png",
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                H16(
                                  text: "아이가 잘 먹고 있나요?",
                                  weight: FW.regular,
                                )
                              ]),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    )),
                const SizedBox(height: 20),
                MainTextButton(
                  text: "완료",
                  width: 200,
                  height: 40,
                  style: AppTextStyle.PD(Colors.white, 16, weight: FW.semi_bold),
                  // disableBackground: AppColor_Primary_Disable,
                  // disable: _data.where((element) => element == 1).length < 3 ? true : false,
                  onPressed: (){
                    foodDetail = !foodDetail;
                    foodCheck = _data.where((element) => element == 1).length < 3;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),

          ],
        ),
      )
  );

  Widget secondPage() => Container(
    margin: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(children: [
              TextSpan(
                text: gSelChildInfo!.name!,
                style: AppTextStyle.PD(AppColor_Primary, 20, weight: FW.bold),
              ),
              TextSpan(
                text: "의 영양식단을 추천해요!",
                style: AppTextStyle.PD(Colors.black, 20, weight: FW.bold),
              )
            ])),
        const SizedBox(height: 20),
        SizedBox(
          height: 1100,
          child: ListView.builder(
            itemCount: subTitle.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: 300,
                    height: 250,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: AppColor_Light_Gray),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        H18(text: subTitle[index]),
                        // Expanded(child: H18(text: "아침 식사")),
                        // FIXME: 영양 이미지넣을때 주석 해제
                        // const SizedBox(height: 10),
                        // foodCheck ?
                        // Image.asset("food_image${index}_down.png", width: 260,):
                        // Image.asset("food_image${index}_up.png", width: 260),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
