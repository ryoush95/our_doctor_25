import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';

class MonitoringResult2 extends StatefulWidget {
  const MonitoringResult2({Key? key}) : super(key: key);

  @override
  State<MonitoringResult2> createState() => _MonitoringResult2State();
}

class _MonitoringResult2State extends BaseState<MonitoringResult2> {

  int tabIndex = 0;
  List<String> category = ["질병", "영양", "맞춤검사"];

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  Widget _body() {
    if(tabIndex == 0) {
      return Container();
    } else if (tabIndex == 1){
      return Container();
    } else if (tabIndex == 2) {
      return Container();
    }
    return CircularProgressIndicator();
  }

  Widget getBannerTitle(int index) {
    return InkWell(
      onTap: (){
        setState(() {
          tabIndex = index;
        });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          margin: const EdgeInsets.only(right: 8),
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
              child: Container(
                margin: EdgeInsets.all(25),
                child: GridView.builder(
                  // scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return getBannerTitle(index);
                  },
                  itemCount: category.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ),
                ),
              ),
          ),
          _body(),

        ],
      )
      );
  }
}
