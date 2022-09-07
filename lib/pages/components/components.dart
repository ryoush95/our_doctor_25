import 'package:extended_masked_text_fixed/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/app_checkbox.dart';
import 'package:ourdoctor/pages/components/dialog.dart';
import 'package:ourdoctor/pages/components/h32_b.dart';
import 'package:ourdoctor/pages/components/main_text_button.dart';
import 'package:ourdoctor/pages/components/round_input.dart';
import 'package:ourdoctor/pages/components/selector.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/components/underline_input.dart';
import 'package:share/share.dart';
import 'H16.dart';
import 'app_floating_button.dart';
import 'h10.dart';
import 'h12.dart';
import 'h18.dart';
import 'img_add_button.dart';
import 'line_chart.dart';

class ComponentsPage extends StatefulWidget {
  @override
  ComponentsPageState createState() => ComponentsPageState();
}

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);

  final String name;
  final String initials;
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ComponentsPageState extends BaseState<ComponentsPage> {
  var roundInputController = TextEditingController(text: "initial text");
  bool isLoading = false;
  String? dropdownValue;
  var moneyController = MoneyMaskedTextController(leftSymbol: 'R\$ ', rightSymbol: 'RR');
  List<String> categoryList = ['One', 'Two', 'Free', 'Four'];
  var options = ["Option 1", "Option 2", "Option 3"];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> filterList = [
    'Foot/Mart',
    'Restaurant/Cafe',
    'Beauty/Salon',
    'Cloth/Miscell',
    'Hospital/Sport',
    'Travel/Free',
    'Furniture/Interior',
    'HomeElect/Digital',
    'Etc123'
  ];

  Future<bool> onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }

  final List<String> listaPagine = [
    'http://192.168.0.63:8005/assets/images/logo.png',
    'http://192.168.0.63:8005/assets/images/logo.png'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      isLoading: isLoading,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SimpleHeader(
                title: LanguageService.trans("alarm"),
                onBackPressed: onBackPressed,
              ),
              MainTextButton(
                text: 'start',
                style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
                onPressed: () {},
                disable: true,
                disableBackground: AppColor_Primary_Disable,
              ),
              const SizedBox(height: 10),
              MainTextButton(
                text: 'Leave a review',
                style: AppTextStyle.PD(Colors.white, 18, weight: FW.semi_bold),
                backgroundColor: AppColor_Green,
                radius: 0,
                onPressed: () {
                  AppDialog.showConfirmDialog(
                      context, "will you delete it?\nwill you delete it?\nsdfsdf", false, (){});
                },
              ),
              const SizedBox(height: 10),
              MainTextButton(
                text: 'to the next',
                style: AppTextStyle.PD(AppColor_BlackText, 18, weight: FW.semi_bold),
                backgroundColor: Colors.white,
                onPressed: () {
                  AppDialog.showConfirmDialog(
                      context, "will you delete it?\nwill you delete it?\nsdfsdf", false, (){});
                },
              ),
              const SizedBox(height: 10),
              const H32B(
                text: "HotDeal Town",
              ),
              const SizedBox(height: 10),
              H18(
                text: "Have Already Account?",
                color: Colors.blue,
                weight: FW.medium,
                align: TextAlign.center,
              ),
              const SizedBox(height: 10),
              H18(
                text: "PhoneAuth",
                align: TextAlign.center,
              ),
              const SizedBox(height: 10),
              H16(
                text: "Login?",
                color: AppColor_Primary,
              ),
              const SizedBox(height: 10),
              Selector(
                  selectedCategory: '',
                  categoryList: categoryList,
                  onSelect: (selectedCategory) {
                    print(selectedCategory);
                  },
                  hint: 'Go select'),
              const SizedBox(height: 10),
              LineChartWidget(gradientColor: Color(0xff4b9eff), data: [], type: 'temperature'),
              const SizedBox(height: 10),
              RoundInput(
                controller: roundInputController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {},
                placeholder: "please input phone number",
                onChanged: (text) => {},
                suffix: false,
              ),
              const SizedBox(height: 10),
              UnderlineInput(
                controller: roundInputController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {},
                placeholder: "please input your name",
                onChanged: (text) => {
                  print(text)
                },
              ),
              const SizedBox(height: 10),
              AppCheckbox(
                  text: "Does not measure oxygen saturation",
                  checked: false,
                  onChecked: (checked) => {}),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AppCheckbox(
                        text: "shortness of breath",
                        checked: false,
                        withBorder: true,
                        onChecked: (checked) => {}),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: AppCheckbox(
                        text: "hemoptysis",
                        checked: true,
                        withBorder: true,
                        onChecked: (checked) => {}),
                  )
                ],
              ),
              const SizedBox(height: 10),
              MainTextButton(
                text: 'confirm',
                backgroundColor: Colors.white,
                style: AppTextStyle.PD(AppColor_BlackText, 15),
                width: 125,
                showBorder: true,
                onPressed: () {
                  Share.share("df");
                  print("confirm clicked!");
                },
              ),
              const SizedBox(height: 10),
              ImgAddButton(text: "2/5", onPressed: () {}),
              const SizedBox(height: 20),
              AppFloatingButton(
                onPressed: () {

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
