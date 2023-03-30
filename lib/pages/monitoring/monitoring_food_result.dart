import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/home/radar_chart.dart';
import 'package:ourdoctor/pages/monitoring/provider/food_result_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MonitoringFoodResult extends StatefulWidget {
  const MonitoringFoodResult({Key? key}) : super(key: key);

  @override
  State<MonitoringFoodResult> createState() => _MonitoringFoodResultState();
}

class _MonitoringFoodResultState extends State<MonitoringFoodResult> {
  final p = getIt.get<FoodResultProvider>();
  int cateIndex = 0;
  int foodHabitIndex = 0;
  List<String> cateList = ["종합", "식단", "식습관"];
  List<String> foodList = ["곡류", "고기", "채소", "과일", "유제품"];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _showMessage = false;

  int graphIndex = 0;

  final List<bool> checkList = List.generate(5, (_) => false);


  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  Widget _getTiles1(int index) {
    double mWidth = (MediaQuery.of(context).size.width) / cateList.length;
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
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
                  color: cateIndex == index ? AppColor_BlackText : AppColor_BlackText.withOpacity(0.2),
                ),
              ),
              Positioned(
                child: SizedBox(
                    width: mWidth,
                    height: 2,
                    child: Container(
                      width: 80,
                      height: MediaQuery.of(context).size.width,
                      color: cateIndex == index ? AppColor_Primary : AppColor_BlackText.withOpacity(0.1),
                    )),
                bottom: 0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget foodListTile(index) {
    return InkWell(
      onTap: () {
        setState(() {
          _showMessage = true;
        });
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _showMessage = false;
          });
        });
      },
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor_Primary,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                foodList[index],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: _showMessage ? 0 : -60,
            left: 0,
            right: 0,
            height: 40,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('+1 point',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
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

  Widget monitorFood() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          H18(
            text: "${gSelChildInfo!.name}는\n${DateTime.now().month}월에 골고루 먹었을까요?",
            maxLine: 2,
            align: TextAlign.start,
          ),
          foodCalendar(),
          const SizedBox(height: 30),
          H18(
            text: "식단 종합",
            maxLine: 2,
            align: TextAlign.start,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: (MediaQuery.of(context).size.width - 40) / 5,
                  child: Column(
                    children: [
                      H14(text: foodList[index]),
                      Container(
                        margin: const EdgeInsets.all(3),
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor_Oxygen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: H14(
                              text: "과다",
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          H18(
            text: "식단 종합",
            maxLine: 2,
            align: TextAlign.start,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H16(text: "최신 기록은 3월 25일 이에요"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColor_Primary),
                child: Center(
                  child: H14(
                    text: "업데이트 하기",
                    weight: FW.bold,
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return foodListTile(index);
              },),
          ),
          Center(
            child: MainTextButton(
              text: "duddid",
              style: AppTextStyle.PD(Colors.white, 16, weight: FW.medium),
              width: 185,
              height: 40,
              radius: 6,
              onPressed: () {

              },
            ),
          ),
          const SizedBox(height: 55),
        ],
      ),
    );
  }

  Widget foodCalendar() {
    Map<DateTime, List> _events = {
      DateTime.utc(2023, 03, 11): ['Event 1', 'Event 2'],
      DateTime.utc(2023, 03, 12): ['Event 3', 'Event 4'],
      DateTime.utc(2023, 03, 13): ['Event 5', 'Event 6'],
    };

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
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (day) => _events[day] ?? [],

      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, date) => Text(
          DateFormat("yyyy년 MM월").format(date), // 원하는 날짜 형식으로 변경
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        // 토요일 일요일 날짜 색변경
        defaultBuilder: (context, day, focusedDay) {
          if (day.weekday == DateTime.sunday) {
            final text = day.day.toString();
            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (day.weekday == DateTime.saturday) {
            final text = day.day.toString();
            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.blue),
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
                style: const TextStyle(color: Colors.white),
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
                style: const TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
            width: 40,
            height: 40,
          );
        },
        markerBuilder: (context, day, events) {
          if(events.isNotEmpty && _selectedDay != day) {
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

  Widget foodHabitTestTile1(index) {
    return InkWell(
      onTap: () {
        setState(() {
          checkList[index] = !checkList[index];
        });
      },
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(8)),
                color: checkList[index]
                    ? AppColor_Primary
                    : AppColor_Light_Gray),
            child: Icon(
              Icons.check_rounded,
              color: checkList[index]
                  ? AppColor_White
                  : Colors.grey,
              size: 50,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(8)),
                  color: checkList[index]
                      ? AppColor_Primary
                      : AppColor_Light_Gray),
              child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: H16(
                      text: "asdasd",
                      color: checkList[index]
                          ? AppColor_White
                          : Colors.black,
                      maxLine: 2,
                      align: TextAlign.start,
                      weight: FW.medium,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget monitor1() {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
        child: monitorFood());
  }

  Widget monitor2() {
    return SingleChildScrollView(
      child: SizedBox(
          height: 900,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(30),
                child: H18(
                  text: DateFormat("yyyy년 MM월 dd일").format(DateTime.now()),
                  align: TextAlign.start,
                ),
              ),
              RadarChartWidget(state: true,),
              // explain(),
            ],
          )),
    );
  }

  Widget monitor3() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: H18(
                    text: "문제 행동",
                    color: AppColor_Primary,
                    align: TextAlign.start,
                  ),
                ),
                H18(
                  text: "체크 리스트",
                  align: TextAlign.start,
                ),
                const SizedBox(height: 55),
                Container(
                  height: 500,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 10),
                        height: 100,
                        child: foodHabitTestTile1(index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 55),
                MainTextButton(
                  text: "완료하기",
                  style: AppTextStyle.PD(Colors.white, 24, weight: FW.medium),
                  width: double.infinity,
                  height: 80,
                  radius: 10,
                  onPressed: () {},
                ),
                const SizedBox(height: 55),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (cateIndex == 0) {
      return monitor1();
    } else if (cateIndex == 1) {
      return monitor2();
    } else {
      return monitor3();
    }
  }

  @override
  Widget build(BuildContext context) {
    p.changeGraphIndex(-1);
    return PageLayout(
      onBack: onBackPressed,
      child: Column(
        children: [
          SimpleHeader(title:"영양모니터링",onBackPressed: onBackPressed,),
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
