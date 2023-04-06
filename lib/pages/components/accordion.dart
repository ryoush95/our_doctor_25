
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  final String leadingImagePath;
  final bool defaultOpen;

  const Accordion({Key? key, required this.title, required this.content , required this.leadingImagePath , required this.defaultOpen})
      : super(key: key);
  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> with SingleTickerProviderStateMixin{
  // Show or hide the content
  bool _showContent = false;

  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    if(widget.defaultOpen){
      _controller.forward();
      _showContent=true;
    }

  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  _toggleContainer() {
    if (_animation.status != AnimationStatus.completed) {
      _controller.forward();
      setState(() {
        _showContent=true;
      });

    } else {
      _controller.animateBack(0, duration: Duration(milliseconds: 300));
      setState(() {
        _showContent=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(


        child: Column(children: [
          ListTile(
            leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.leadingImagePath),
      ),
            title: widget.title,
            trailing:
            GestureDetector(
              onTap: () => _toggleContainer(),
                child: _showContent ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(math.pi),
                    child: Image.asset('assets/polygon_7.png', width: 16)
                ):Image.asset('assets/polygon_7.png', width: 16)
            )
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            child: Container(

              padding:
              const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 1,
                  ),

                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: widget.content
                  ),
                ],
              ),
            )
          ),


        ]),
      ),
    );
  }
}