import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/models/monitoring/food_home_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/header_text.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/radar_chart.dart';
import 'package:ourdoctor/pages/monitoring/food_write_list.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_habit.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_food_test1.dart';
import 'package:ourdoctor/pages/monitoring/provider/food_result_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MonitoringFoodResult extends StatefulWidget {
  const MonitoringFoodResult({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodResult> createState() => _MonitoringFoodResultState();
}

class _MonitoringFoodResultState extends BaseState<MonitoringFoodResult> {
  final p = getIt.get<FoodResultProvider>();
  final HttpService httpService = HttpService();
  int cateIndex = 0;
  int foodHabitIndex = 0;
  List<String> cateList = ["종합", "식단", "식습관"];
  List<String> foodList = ["곡류", "고기", "채소", "과일", "유제품"];
  List<bool> missionList = [];
  List<String> missionKey = [];
  Map<String, Mission> missionListData = {};
  FoodHomeData? foodHome;
  Map<DateTime, List> _events = {};
  DateTime? lastDate;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final bool _showMessage = false;

  int graphIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    p.changeGraphIndex(-1);
    getFoodHomeData();
    missionList = List.generate(5, (_) => false);
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  getFoodHomeData() async {
    setState(() {
      isLoading = true;
    });
    Future<FoodHomeModel> getFoodAll = httpService.getFoodHome();
    await getFoodAll.then((value) {
      if (value.result == 0) {
        foodHome = value.data!;
        missionListData = foodHome!.habits!.missions!;
        missionListData = {
          "0": Mission(complete: false, text: foodHome!.habits!.score!.text),
          ...missionListData,
        };
        foodHome!.habits!.missions = missionListData;
        missionKey = foodHome!.habits!.missions!.keys.toList();
        lastDate = foodHome!.habits!.lastMonitoring!;
        _events = addEvent();
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
    });
  }

  Widget _getTiles1(int index) {
    double mWidth = (MediaQuery.of(context).size.width) / cateList.length;
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (index == 0) {
            getFoodHomeData();
          }
          setState(() {
            cateIndex = index;
          });
        },
        child: SizedBox(
          width: mWidth,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Center(
                child: H14(
                  text: cateList[index],
                  weight: FW.medium,
                  align: TextAlign.center,
                  maxLine: 2,
                  color: cateIndex == index
                      ? AppColor_BlackText
                      : AppColor_BlackText.withOpacity(0.2),
                ),
              ),
              Positioned(
                child: SizedBox(
                    width: mWidth,
                    height: 2,
                    child: Container(
                      width: 80,
                      height: MediaQuery.of(context).size.width,
                      color: cateIndex == index
                          ? AppColor_Primary
                          : AppColor_BlackText.withOpacity(0.1),
                    )),
                bottom: 0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMission(Mission mdata, int index) async {
    Future<DefaultResModel> info =
        httpService.missionComplete(missionKey[index]);
    await info.then((value) {
      if (value.result == 0) {
        Fluttertoast.cancel();
        showToast("미션을 완료했어요! +1point");
        setState(() {
          // _showMessage = true;
          mdata.complete = !mdata.complete!;
        });
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError.toString());
    });
  }

  Widget foodListTile(index) {
    final mdata = missionListData[missionKey[index]]!;
    return InkWell(
      onTap: () {
        if (index == 0) {
          return;
        }
        if (!mdata.complete!) {
          sendMission(mdata, index);
        }

        // Future.delayed(Duration(seconds: 1), () {
        //   setState(() {
        //     _showMessage = false;
        //   });
        // });
      },
      child: Stack(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width - 40) / 2.5,
            height: 100,
            padding: EdgeInsets.all(10),
            margin: index == foodHome!.habits!.missions!.length - 1
                ? EdgeInsets.symmetric(horizontal: 10)
                : EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: mdata.complete!
                  ? AppColor_Primary.withOpacity(0.5)
                  : Colors.transparent,
              border: Border.all(
                color: index == 0
                    ? colorSwitch(foodHome!.habits!.score!.status)
                    : !mdata.complete!
                        ? AppColor_Primary
                        : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H14(
                  text: index == 0 ? "식습관 지수" : "미션$index",
                  color: mdata.complete! ? Colors.white : Colors.black,
                ),
                Center(
                  child: H16(
                    text: mdata.text!,
                    weight: FW.regular,
                    maxLine: 3,
                    align: TextAlign.start,
                    color: mdata.complete! ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
          Visibility(
            visible: mdata.complete!,
            child: Container(
              width: (MediaQuery.of(context).size.width - 40) / 2.5,
              height: 100,
              padding: EdgeInsets.all(6),
              margin: index == 3
                  ? EdgeInsets.symmetric(horizontal: 10)
                  : EdgeInsets.only(left: 10),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8),
              //   color: AppColor_Primary.withOpacity(0.5),
              // ),
              child: Image.asset(
                "assets/도장_$index.png",
              ),
            ),
          ),
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 500),
          //   top: _showMessage ? 0 : -60,
          //   left: 0,
          //   right: 0,
          //   height: 40,
          //   child: Container(
          //     padding: EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.grey.withOpacity(0.8),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Text('+1 point',
          //         style: TextStyle(fontSize: 16, color: Colors.white)),
          //   ),
          // ),
          // Opacity(
          //   opacity: _showMessage ? 1 : 0,
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     margin: EdgeInsets.all(3),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8),
          //       color: Colors.grey.withOpacity(0.4),
          //     ),
          //     child: Center(
          //       child: Text(
          //         '+1 point',
          //         style: TextStyle(fontSize: 16, color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget missionAreaText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H18(
              text: "식습관 종합",
              maxLine: 2,
              align: TextAlign.start,
            ),
            lastDate == null
                ? H16(text: "", color: AppColor_BlackText, weight: FW.regular)
                : RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "최신 기록은 ",
                          style: AppTextStyle.PD(AppColor_BlackText, 16,
                              weight: FW.regular),
                        ),
                        TextSpan(
                          text: "${lastDate!.month}월 ${lastDate!.day}일",
                          style: AppTextStyle.PD(AppColor_Primary, 16,
                              weight: FW.bold, height: 1.4),
                        ),
                        TextSpan(
                          text: " 이에요",
                          style: AppTextStyle.PD(AppColor_BlackText, 16,
                              weight: FW.regular, height: 1.4),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        //   margin: const EdgeInsets.only(right: 8),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(18),
        //       color: AppColor_Primary),
        //   child: Center(
        //     child: H14(
        //       text: "업데이트 하기",
        //       weight: FW.bold,
        //       align: TextAlign.center,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Color colorSwitch(status) {
    if (status == "G") {
      return AppColor_Oxygen;
    } else if (status == "Y") {
      return Colors.amber;
    } else if (status == "R") {
      return AppColor_Red;
    } else {
      return Colors.grey;
    }
  }

  Widget monitor1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(text: foodHome!.title!),
                foodCalendar(),
                const SizedBox(height: 30),
                // 식단 상태 area
                H18(
                  text: "식단 종합",
                  maxLine: 2,
                  align: TextAlign.start,
                ),
                const SizedBox(height: 20),
                foodHome!.food == null || foodHome!.food!.isEmpty
                    ? SizedBox(
                        height: 50,
                        child: Center(child: H16(text: "아직 검사기록이 없습니다.")),
                      )
                    : SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return foodHome!.food![foodList[index]] == null
                                ? Container()
                                : SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            40) /
                                        5,
                                    child: Column(
                                      children: [
                                        H14(text: foodList[index]),
                                        Container(
                                          margin: const EdgeInsets.all(3),
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: colorSwitch(foodHome!
                                                .food![foodList[index]]!
                                                .status),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/food_icon_noback_$index.png",
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                const SizedBox(height: 4),
                                                Center(
                                                    child: H14(
                                                  text: foodHome!
                                                          .food![
                                                              foodList[index]]!
                                                          .text ??
                                                      "없음",
                                                  color: Colors.white,
                                                )),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                          },
                        ),
                      ),
                // 미션 area
                missionAreaText(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 미션 area list
          foodHome!.habits!.missions!.isEmpty || lastDate == null
              ? H16(text: "아직 검사기록이 없습니다.")
              : SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: missionKey.length,
                    itemBuilder: (context, index) {
                      return foodListTile(index);
                    },
                  ),
                ),
          // Center(
          //   child: MainTextButton(
          //     text: "duddid",
          //     style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
          //     width: 185,
          //     height: 40,
          //     radius: 6,
          //     onPressed: () {
          //
          //     },
          //   ),
          // ),
          const SizedBox(height: 55),
        ],
      ),
    );
  }

  Map<DateTime, List> addEvent() {
    Map<DateTime, List> _event = {};
    for (var i in foodHome!.calendar!) {
      _event.putIfAbsent(i, () => ["Event"]);
    }
    return _event;
  }

  Widget foodCalendar() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime(2020, 1, 1),
      lastDay: DateTime(2050, 12, 31),
      calendarFormat: CalendarFormat.month,
      availableGestures: AvailableGestures.none,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) async {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
        if (_events.containsKey(selectedDay)) {
          setState(() {
            cateIndex = 1;
          });
        } else {
          if (selectedDay.isAfter(DateTime.now())) {
            return;
          }
          String selDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
          final result = await Navigator.push(
              context,
              SlideRightTransRoute(
                builder: (context) => FoodWriteList(
                  date: selDate,
                ),
              ));
          if (result != null && result) {
            getFoodHomeData();
          }
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (day) => _events[day] ?? [],
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, date) => Text(
          DateFormat("yyyy년 M월").format(date), // 원하는 날짜 형식으로 변경
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        // 토요일 일요일 날짜 색변경
        defaultBuilder: (context, day, focusedDay) {
          final text = day.day.toString();
          if (day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          } else if (day.weekday == DateTime.saturday) {
            final text = day.day.toString();
            return Center(
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Center(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
        },
        // 헤더 주말색 변경
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            final text = DateFormat.E().format(day);
            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (day.weekday == DateTime.saturday) {
            final text = DateFormat.E().format(day);
            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.blue),
              ),
            );
          }
        },
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor_Primary.withOpacity(0.6),
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            width: 40,
            height: 40,
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor_Primary,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            width: 40,
            height: 40,
          );
        },
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty && _selectedDay != day) {
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor_Primary,
              ),
              width: 10,
              height: 10,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget foodHabitTestTile(index) {
    return Container();
  }

  Widget monitor2() {
    String selDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
    return SingleChildScrollView(
      child: SizedBox(
          height: MediaQuery.of(context).size.width + 550,
          child: RadarChartWidget(
            state: true,
            date: selDate,
          )),
    );
  }

  Widget monitor3() {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://mingles-dev.s3.ap-northeast-2.amazonaws.com/uploads/product/main_image_object/41/%EB%B0%B0%EC%93%B0%EB%B0%A4_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
              H18(
                text: "미션을 수행하며\n건강한 식습관을 가져보세요!",
                maxLine: 2,
              ),
              Divider(),
              MainTextButton(
                text: "다시 점검하기",
                style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
                width: 185,
                height: 40,
                radius: 6,
                onPressed: () {
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                        builder: (context) => MonitoringFoodTest1(),
                      ));
                },
              ),
            ],
          ),
          MonitoringFoodHabit(),
        ],
      ),
    );
  }

  Widget _body() {
    if (cateIndex == 0) {
      return foodHome == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : monitor1();
    } else if (cateIndex == 1) {
      return monitor2();
    } else {
      return monitor3();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      isLoading: isLoading,
      onBack: onBackPressed,
      child: Column(
        children: [
          SimpleHeader(
            title: "영양모니터링",
            onBackPressed: onBackPressed,
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _getTiles1(index);
              },
              itemCount: cateList.length,
            ),
          ),
          Expanded(
            child: _body(),
          ),
        ],
      ),
    );
  }
}
