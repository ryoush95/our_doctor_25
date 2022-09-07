import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class Zoom extends StatefulWidget {
  Zoom({
    required this.child,
  });

  final Widget child;

  @override
  State<Zoom> createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> with SingleTickerProviderStateMixin {
  // final _transController = TransformationController();
  // TapDownDetails _doubleTapDetails = TapDownDetails();
  // AnimationController? _animationController;
  // Animation<Matrix4>? _animation;


  // _handleDoubleTapDown(TapDownDetails details) {
  //   _doubleTapDetails = details;
  // }
  
  // _handleDoubleTap() {
  //   Matrix4 _endMatrix;
  //   Offset _position = _doubleTapDetails.localPosition;
  
  //   if (_transController.value != Matrix4.identity()) {
  //     _endMatrix = Matrix4.identity();
  //   } else {
  //     _endMatrix = Matrix4.identity()
  //       ..translate(-_position.dx * 2, -_position.dy * 2)
  //       ..scale(3.0);
  //   }

  //   _animation = Matrix4Tween(
  //     begin: _transController.value,
  //     end: _endMatrix,
  //   ).animate(
  //     CurveTween(curve: Curves.easeOut).animate(_animationController!),
  //   );
  //   _animationController!.forward(from: 0);
  // }

@override
  void initState() {
    super.initState();

    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 400),
    // )..addListener(() {
    //     _transController.value = _animation!.value;
    //   });

  }

  @override
  void dispose() {
    // _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PinchZoom(
        child: widget.child,
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 3,
      );
    
    // GestureDetector(
    // // onDoubleTapDown: _handleDoubleTapDown,
    // // onDoubleTap: _handleDoubleTap,
    // child: Center(
    //   child: InteractiveViewer(
    //     transformationController: _transController,
    //     child: widget.child,
    //   ),
    // ),
  // );
  }
}