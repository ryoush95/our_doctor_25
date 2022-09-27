import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ourdoctor/pages/base/base_state.dart';

class PageLayout extends StatefulWidget {
  PageLayout(
      {Key? key,
      required this.child,
      this.onBack,
      this.isLoading,
      this.isAvoidResize,
      this.drawer,
      this.scaffoldKey,
      this.top})
      : super(key: key) {
    this.isLoading ??= false;
    this.isAvoidResize ??= true;
    this.drawer ??= null;
    this.top ??= true;
  }

  Widget child;
  Future<bool> Function()? onBack;
  bool? isLoading;
  bool? isAvoidResize;
  Widget? drawer;
  bool? top;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  PageLayoutState createState() => PageLayoutState();
}

class PageLayoutState extends BaseState<PageLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.onBack,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            top: widget.top!,
            child: Container(
              child: Scaffold(
                key: widget.scaffoldKey,
                resizeToAvoidBottomInset: widget.isAvoidResize,
                drawer: widget.drawer,
                body: ModalProgressHUD(
                  inAsyncCall: widget.isLoading!,
                  color: Colors.transparent,
                  child: SafeArea(
                    bottom: false,
                    top: widget.top!,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Center(
                          child: widget.child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
