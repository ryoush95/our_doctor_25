import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/pages/components/h18.dart';

class PrescriptionDialog extends StatefulWidget {
  PrescriptionDialog({Key? key, required this.amImage, required this.pmImage})
      : super(key: key);

  late String amImage;
  late String pmImage;

  @override
  PrescriptionDialogState createState() => PrescriptionDialogState();
}

class PrescriptionDialogState extends State<PrescriptionDialog> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void onSave() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return WillPopScope(
          child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: 30,
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Image.asset(
                                      'assets/clear_black_24dp.png',
                                      width: 20)),
                              onTap: onBackPressed,
                            )),
                        Center(
                          child: H18(
                              text: LanguageService.trans("prescription"),
                              weight: FW.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Visibility(
                            visible: widget.amImage.isNotEmpty,
                            child: H18(text: LanguageService.trans("am")),
                          ),
                          Visibility(
                            visible: widget.amImage.isNotEmpty,
                            child: const SizedBox(height: 5),
                          ),
                          Visibility(
                            visible: widget.amImage.isNotEmpty,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ExtendedImage(
                                image: NetworkImage(widget.amImage),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.pmImage.isNotEmpty,
                            child: const SizedBox(height: 15),
                          ),
                          Visibility(
                            visible: widget.pmImage.isNotEmpty,
                            child: H18(text: LanguageService.trans("pm")),
                          ),
                          Visibility(
                            visible: widget.pmImage.isNotEmpty,
                            child: const SizedBox(height: 5),
                          ),
                          Visibility(
                            visible: widget.pmImage.isNotEmpty,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ExtendedImage(
                                image: NetworkImage(widget.pmImage),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  )),
                ],
              )),
          onWillPop: onBackPressed);
    });
  }
}
