import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/default_res_model.dart';
import 'package:ourdoctor/pages/base/page_layout1.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h16.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/intro/first.dart';

class ReportPage extends StatefulWidget {
  ReportPage({
    required this.uid,
    required this.writer,
    required this.title,
    this.comment = false,
  });

  String uid;
  String writer;
  String title;
  bool comment;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final options = [
    '스팸/홍보글',
    '청소년에게 부적절한 내용 또는 음란물',
    '지적 재산권 및 저작권 침해 등',
    '기타',
  ];
  int? _selectedIdx;
  String? _reason; 
  bool _canClear = false;
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  HttpService httpService = HttpService();

  report() {
    if(_reason != null && _reason != '') {
        _isLoading = true;
        setState(() {});

      Future<DefaultResModel> info = httpService.report("community", widget.uid, _reason!);
      
      info.then((DefaultResModel value) {
        _isLoading = false;
        setState(() {});

        if (value.result == 0) {
          showToast(LanguageService.trans("msg_report_success"));
          Navigator.of(context).pop();
        } else {
          showToast(value.msg ?? "");
          Navigator.of(context).pop();
          if (value.result == 106) {
            //token expired
            Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
          }
        }
      }).catchError((onError) {
        _isLoading = false;
        setState(() {});
        showToast(onError);
      });
      } else {
        showToast('신고사유를 선택해 주세요.');
      }
    }
    
  @override
  Widget build(BuildContext context) {
    return PageLayout1(
      isLoading: _isLoading,
      child: Container(
        child: Column(
          children: [
            header(),
            info(),
            divider(),
            reasons(),
          ],
        )
      )
    );
  }

  header() => Container(
    height: 62,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.translucent,
          child: H18(
            text: LanguageService.trans('cancel1'), 
            color: AppColor_BlackText, 
            weight: FW.medium,
          ),
        ),
        H18(text: LanguageService.trans('report'), color: AppColor_BlackText, weight: FW.medium,),
        GestureDetector(
          onTap: () => report(),
          child: H18(
            text: LanguageService.trans('report1'), 
            color: _reason != '' && _reason != null ? AppColor_Red : AppColor_Red.withOpacity(.2), 
            weight: FW.medium
          ),
        ),
      ],
    )
  );

  info() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    margin: const EdgeInsets.only(top: 10, bottom: 15),
    child: Column(
      children: [
        infoText(widget.writer, LanguageService.trans('writer')),
        infoText(
          widget.title, 
          widget.comment 
          ? LanguageService.trans('contents')
          : LanguageService.trans('title'),
        ),
      ],
    ),
  );

  infoText(String text, String title) => Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: 45,
          child: H16(
            text: title,
            color: AppColor_BlackText.withOpacity(.3),
            weight: FW.regular,
            align: TextAlign.left,
          ),
        ),
        const SizedBox(width: 24),
        Container(
          width: 240,
          child: H16(
            text: text, 
            color: AppColor_BlackText, 
            weight: FW.medium, 
            isEllipsis: true, 
            align: TextAlign.start
          ),
        ),
      ],
    );

  divider() => Container(
    color: const Color(0xFFF8F9FA),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    width: double.infinity,
    child: H14(
      text: '신고사유', 
      color: AppColor_BlackText.withOpacity(.5),
      align: TextAlign.left,
      weight: FW.medium,
    ),
  );

  reasons() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    child: Column(
      children: [
        ...List.generate(4, (int idx) => reason(idx)),
        _selectedIdx == options.length -1
        ? input()
        : const SizedBox(),
      ],
    )
  );


  reason(int idx) => Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: idx != options.length -1 
    ? const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Color(0xFFF7F7F7), width: 1),
      ),
    )
    : null,
    child: Row(
      children: [
        circle(idx),
        const SizedBox(width: 18),
        H16(text: options[idx], color: AppColor_BlackText, weight: FW.regular),
      ],
    ),
  );

  circle(int idx) => GestureDetector(
    onTap: () {
      _selectedIdx = idx;
      if(_selectedIdx != options.length -1) {
        _reason = options[_selectedIdx!];
      }
      setState(() {});
    },
    child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            // color: const Color(0xFFEDEEEF),
            border: Border.all(
              color: const Color(0xFFEDEEEF),
              width: 1.5,
            )
          ),
          child: _selectedIdx == idx 
          ? Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColor_Primary,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
          )
          : const SizedBox(),
        ),
  );

  input() => Container(
    height: 150,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(5)), 
      border: Border.all(color: const Color(0xFFEDEEEF)),
    ),
    child: TextField(
      controller: _controller,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        border: InputBorder.none,
        suffix: _canClear
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _controller.clear();
                    _canClear = false;
                    _reason = '';
                    setState((){});
                  },
                  child: Container(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      'assets/ic_clear.svg',
                    ),
                  ),
                )
              : const SizedBox() ,
      ),
      style: AppTextStyle.PD(AppColor_BlackText, 14, weight: FW.regular),
      onChanged: (text) {
        if(_selectedIdx == options.length -1) {
          _canClear = (_controller.text.isNotEmpty);
          _reason = text;
          setState(() {});
        }
      },
    ),
  );

}