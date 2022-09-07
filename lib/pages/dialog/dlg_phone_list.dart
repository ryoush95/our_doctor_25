import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';

/**
 * 타이틀 2개 버튼을 가진 팝업
 */
class PhoneListDialog extends StatefulWidget {
  @override
  _PhoneListDialogState createState() => _PhoneListDialogState();
}

class _PhoneListDialogState extends State<PhoneListDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          color: Colors.transparent,
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        child: Center(
                          child: Text(
                            LanguageService.trans("hospital_phone"),
                            maxLines: 2,
                            style: const TextStyle(fontSize: 20, fontFamily: "NotoSansKR", color: Color(0xFF191919), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 200,
                      //   margin: const EdgeInsets.only(top: 25.0),
                      //   child: ListView.builder(
                      //     physics: ClampingScrollPhysics(),
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return _getTiles(index);
                      //     },
                      //     itemCount: gUserInfo!.emergencyList!.length,
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, gSelChildInfo!.hospitalPhoneNumber!);
                        },
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: H16(
                              text: gSelChildInfo!.hospitalName! + " : " + gSelChildInfo!.hospitalPhoneNumber!,
                              weight: FW.medium,
                              maxLine: 2,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: H16(
                            text: "=====================",
                            weight: FW.medium,
                            color: AppColor_BlackText,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text(
                            LanguageService.trans("hospital_phone1"),
                            maxLines: 2,
                            style: const TextStyle(fontSize: 20, fontFamily: "NotoSansKR", color: Color(0xFF191919), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, "02-6300-9080");
                        },
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: H16(
                              text: LanguageService.trans("call_default_phone1"),
                              weight: FW.medium,
                              maxLine: 2,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, "02-920-9147");
                        },
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: H16(
                              text: LanguageService.trans("call_default_phone2"),
                              weight: FW.medium,
                              maxLine: 2,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, "119");
                        },
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: H16(
                              text: LanguageService.trans("call_default_phone3"),
                              weight: FW.medium,
                              maxLine: 2,
                              color: AppColor_BlackText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      MainTextButton(
                        text: "취소",
                        backgroundColor: Colors.white,
                        style: AppTextStyle.PD(AppColor_BlackText, 15),
                        width: 100,
                        height: 40,
                        showBorder: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              })),
        ),
      ),
    );
  }
  /*
  Widget _getTiles(int index) {
    EmergencyList info = gUserInfo!.emergencyList!.elementAt(index);
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              Navigator.pop(context, info.phoneNumber);
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              child: Center(
                child: Text(
                  info.phoneNumber!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400, color: Color(0xFF191919)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}
