import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/language/language_service.dart';

class PhotoDialog extends StatefulWidget {
  PhotoDialog({Key? key, required this.onGallery, required this.onCamera, required this.onprofileImage}) : super(key: key);

  final void Function() onGallery;
  final void Function() onCamera;
  final void Function() onprofileImage;
  @override
  PhotoDialogState createState() => PhotoDialogState();
}

class PhotoDialogState extends State<PhotoDialog> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed,
        child: AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                InkWell(
                    onTap: widget.onGallery,
                    child: SizedBox(
                      width: 235,
                      height: 30,
                      child: Row(
                        children: [Text(LanguageService.trans('select_gallery'), style: AppTextStyle.PD(Colors.black, 14))],
                      ),
                    )),
                const SizedBox(height: 10),
                InkWell(
                  onTap: widget.onCamera,
                  child: SizedBox(
                    width: 235,
                    height: 30,
                    child: Row(
                      children: [Text(LanguageService.trans('select_camera'), style: AppTextStyle.PD(Colors.black, 14))],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: widget.onprofileImage,
                  child: SizedBox(
                    width: 235,
                    height: 30,
                    child: Row(
                      children: [
                        Text(LanguageService.trans('기본 이미지 변경'), style: AppTextStyle.PD(Colors.black, 14)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          contentPadding: const EdgeInsets.all(20),
        ));
  }
}
