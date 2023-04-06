
import 'package:flutter/material.dart';

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
            trailing: IconButton(
              icon: Icon(
                  _showContent ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded),
              iconSize: 40,
              color: Colors.black,
              onPressed: () => _toggleContainer(),

            ),
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