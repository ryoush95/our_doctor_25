import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/dto/report_dto.dart';
import 'package:ourdoctor/models/home_grapth_res_model.dart';
import 'package:ourdoctor/models/monitoring/food_list_model.dart';
import 'package:ourdoctor/models/monitoring/sleep_graph_model.dart';
import 'package:ourdoctor/models/monitoring/temp_graph_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/h20.dart';
import 'package:ourdoctor/pages/components/header_text.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/disease_report.dart';
import 'package:ourdoctor/pages/home/inspection_report.dart';
import 'package:ourdoctor/pages/home/lifestyle_line_chart2.dart';
import 'package:ourdoctor/pages/home/sleep_report.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:sprintf/sprintf.dart';

class MonitoringReport2 extends StatefulWidget {
  const MonitoringReport2({Key? key}) : super(key: key);

  @override
  State<MonitoringReport2> createState() => _MonitoringReport2State();
}

class _MonitoringReport2State extends BaseState<MonitoringReport2> {
  final HttpService httpService = HttpService();
  int tabIndex = 0;
  List<String> category = ["질병", "수면", "영양", "맞춤검사"];
  List<String> subTitle = ["아침식사", "점심식사", "간식", "저녁식사"];
  List<String> subCategory = [""];
  List<int> _data = [0,0,0,0,0,0,0];
  List<ReportDto> reportList = [];
  List<ReportDto> reportList1 = [];
  List<ReportDto> reportList2 = [];
  Data? tempGraphList;
  SleepDataDto? sleepGraphList;
  List<String> foodList = [];
  String foodComment = "";

  int curYear = 0;
  int curMonth = 0;
  DateTime now = DateTime.now();
  String newDate = "";

  bool foodDetail = false;
  bool foodCheck = true;

  //test data
  HomeGraphLifeStyleDto? dicHomeGraphLifeStyleInfo;

  @override
  void initState() {
    super.initState();
    dicHomeGraphLifeStyleInfo = null;

    newDate = DateFormat('yyyy-MM-dd').format(now);

    curYear = now.year;
    curMonth = now.month;
    getTempList();
    getHomeGraphLifeStyle();
    int birthYear = int.parse(gSelChildInfo!.birth!.substring(0,4));
    int birthMonth = int.parse(gSelChildInfo!.birth!.substring(5,7));
    DateTime birthDate = DateTime(birthYear, birthMonth); // 태어난 날짜
    int months = ((now.year - birthDate.year) * 12) + (now.month - birthDate.month);
    if (months >= 12 && months <= 107) {
      getFoodList();
    }
    getSleepList();
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

  //체온 그래프
  Future<void> getTempList() async{
    Future<TempGraphModel> info2 = httpService.getTempGraph(newDate);
    info2.then((TempGraphModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        tempGraphList = value.data!;
        // tempGraphList == null || tempGraphList!.graphTemperature!.isEmpty
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
      print(onError.toString());
    });
  }

  //수면 그래프
  Future<void> getSleepList() async{
    Future<SleepGraphModel> info2 = httpService.getSleepGraph(newDate);
    info2.then((SleepGraphModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        sleepGraphList = value.data!;
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
      print(onError);
    });
  }

  // 영양 리스트
  Future<void> getFoodList() async{
    Future<FoodListModel> info2 = httpService.getFoodList();
    info2.then((FoodListModel value) async {
      setState(() {
        isLoading = false;
      });

      if (value.result == 0) {
        foodList.add(value.data!.breakfast!);
        foodList.add(value.data!.lunch!);
        foodList.add(value.data!.snack!);
        foodList.add(value.data!.dinner!);
        foodComment = value.data!.comment!;

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
      print(onError.toString());
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

  Widget symptom() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: tempGraphList == null || tempGraphList!.graphTemperature!.isEmpty ? Center(
            child: H14(text: "체온 정보가 없습니다."),
          ): LifestyleLineChart2(data:tempGraphList!),
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
  }

  Widget sleep() {
    return sleepGraphList != null
        ? Column(
      children: [
        /*
          // 선택 월 변경 탭
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
              H16(text: '$curYear년 $curMonth월', color: AppColor_BlackText.withOpacity(0.5), weight: FW.semi_bold),
              const SizedBox(width: 18),
              InkWell(
                  onTap: () {
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
          ),*/
        Container(padding: const EdgeInsets.symmetric(horizontal: 30), child: SleepReport(data: sleepGraphList!, result: 1)),
      ],
    ) : const SizedBox(
      child: Text("검사결과 없음"),
    );
  }

  Widget _body() {
    if (tabIndex == 0) {
      // CATE : 질병
      return symptom();
    } else if (tabIndex == 1) {
      // CATE : 수면
      // print(gUserInfo!.accessToken!);
      return sleep();
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
        padding: const EdgeInsets.only(left: 30.0,right: 30.0, top: 30.0),
        child: InspectionReport(data: reportList, data1: reportList1, data2: reportList2),
      );
    }
    return const CircularProgressIndicator();
  }

  Widget _getTiles1(int index) {
    double mWidth = (MediaQuery.of(context).size.width) / category.length;
    return InkWell(
      onTap: () {
        setState(() {
          tabIndex = index;
        });
      },
      child: SizedBox(
        width: mWidth,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(
              child: H14(
                text: category[index],
                weight: FW.medium,
                align: TextAlign.center,
                maxLine: 2,
                color: tabIndex == index ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
              ),
            ),
            Positioned(
              child: SizedBox(
                  width: mWidth,
                  height: 2,
                  child: Container(
                    width: 80,
                    height: MediaQuery.of(context).size.width,
                    color: tabIndex == index ? AppColor_Primary : AppColor_BlackText.withOpacity(0.1),
                  )),
              bottom: 0,
            )
          ],
        ),
      ),
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
                      // width: screenSize.width,
                      height: 40,
                      padding: const EdgeInsets.only(bottom: 10),
                      // margin: const EdgeInsets.all(25),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _getTiles1(index);
                        },
                        itemCount: category.length,
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
        foodList.isNotEmpty ?
        HeaderText(text: "${gSelChildInfo!.name!}의 영양식단을 추천해요!")
         : Align(
          alignment: Alignment.centerLeft,
           child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "1살",
                  style: AppTextStyle.PD(AppColor_Primary, 20, weight: FW.bold),
                ),
                TextSpan(
                  text: "부터 ",
                  style: AppTextStyle.PD(Colors.black, 20, weight: FW.bold),
                ),
                TextSpan(
                  text: "8살",
                  style: AppTextStyle.PD(AppColor_Primary, 20, weight: FW.bold),
                ),
                TextSpan(
                  text: "까지\n영양식단을 제공해요 😥",
                  style: AppTextStyle.PD(Colors.black, 20, weight: FW.bold),
                ),
              ])),
         ),
        const SizedBox(height: 20),
        foodList.isEmpty
            ? Image.asset("assets/food_next.png")
            : Visibility(
          visible: foodList.isNotEmpty,
          child: SizedBox(
            height: 1300,
            child: ListView.builder(
              itemCount: subTitle.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: 330,
                      height: 300,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: AppColor_Light_Gray),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          H18(text: subTitle[index]),
                          const SizedBox(height: 10),
                          CachedNetworkImage(imageUrl: foodList[index],height: 240, width: 326,
                            errorWidget: (context, url, error) => const SizedBox(
                              child: Center(child: Text("검사결과가 없습니다"))
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
        Visibility(
            visible: foodList.isNotEmpty,
            child: H18(text: "우리아이는?"),
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: foodList.isNotEmpty,
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: AppColor_Light_Gray),
            padding: const EdgeInsets.only(
                left: 30, right: 30, top: 20, bottom: 20),
            // margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              foodComment,
              style: const TextStyle(
                  color: AppColor_GrayText,
                  fontSize: 16,
                  height: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 30,),
        // SolutionArea(),
      ],
    ),
  );
}
