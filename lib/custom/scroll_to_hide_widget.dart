import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final double childHeight;

  const ScrollToHideWidget(
      {Key key, this.child, this.scrollController, this.childHeight})
      : super(key: key);

  @override
  _ScrollToHideWidgetState createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          widget.scrollController.position.pixels ==
              widget.scrollController.initialScrollOffset) {
        isVisible = true;
      } else {
        isVisible = false;
      }
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // Use the properties stored in the State class.
      width: MediaQuery.of(context).size.width,
      height: isVisible ? widget.childHeight : 0,
      // Define how long the animation should take.
      duration: const Duration(seconds: 1),
      // Provide an optional curve to make the animation feel smoother.
      curve: Curves.easeInOutExpo,
      child: Container(child: widget.child),
    );
  }
}
