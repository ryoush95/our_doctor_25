import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/models/home_data_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';
import 'package:ourdoctor/pages/components/h14.dart';

class ItemDevelopment extends StatefulWidget {
  ItemDevelopment({Key? key, this.info}) : super(key: key);
  DevelopmentList? info;

  @override
  ItemDevelopmentState createState() => ItemDevelopmentState();
}

class ItemDevelopmentState extends BaseState<ItemDevelopment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 56,
      height: 351,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Stack(
                children: [
                  Visibility(
                      visible: widget.info!.mainImage!.isEmpty,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColor_f4f5f7,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  Visibility(
                    visible: widget.info!.mainImage!.isNotEmpty,
                    child: ExtendedImage.network(
                      widget.info!.mainImage!,
                      height: 326,
                      fit: BoxFit.fill,
                      cache: true,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 15),
          H14(text: widget.info!.name!, weight: FW.semi_bold),
        ],
      ),
    );
  }
}
