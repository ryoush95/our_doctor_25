import 'package:flutter/material.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/pages/my/photo_view.dart';

/**
 * 공통 팝업
 */
class CommonDialog {
  //버튼 한개를 가진 팝업
  Future<int> showOneBtnPopup(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              content: Container(
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(context, SlideRightTransRoute(builder: (context) => PhotoViewPage(imgs: [], type: 1)));
                        },
                        child: Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                          child: Image.asset(
                            'assets/img_table2.png',
                            width: MediaQuery.of(context).size.width - 80,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ],
                  )));
        });
  }

  //검진 캘린더
  Future<int> showHealthCalendarPopup(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              content: Container(
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(context, SlideRightTransRoute(builder: (context) => PhotoViewPage(imgs: ['assets/img_health_calendar.png'], type: 2)));
                        },
                        child: Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                          child: Image.asset(
                            'assets/img_health_calendar.png',
                            width: MediaQuery.of(context).size.width - 80,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ],
                  )));
        });
  }

  //접종 캘린더
  Future<int> showVaccineCalendarPopup(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              content: Container(
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(context, SlideRightTransRoute(builder: (context) => PhotoViewPage(imgs: [], type: 3)));
                        },
                        child: Container(
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                          child: Image.asset(
                            'assets/img_vacine_calendar.png',
                            width: MediaQuery.of(context).size.width - 80,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ],
                  )));
        });
  }
}
