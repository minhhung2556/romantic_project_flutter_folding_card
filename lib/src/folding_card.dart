import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FoldingCard extends StatefulWidget {
  final bool expanded;
  final Widget cover;
  final List<Widget> pages;
  final double pageHeight;
  final Decoration pageBackground;

  const FoldingCard({
    Key? key,
    this.expanded: false,
    required this.cover,
    required this.pages,
    required this.pageHeight,
    required this.pageBackground,
  })  : assert(pages.length > 1),
        assert(pageHeight > 1),
        super(key: key);
  @override
  _FoldingCardState createState() => _FoldingCardState();
}

class _FoldingCardState extends State<FoldingCard>
    with TickerProviderStateMixin {
  final List<AnimationController> _pageControllers = [];

  @override
  void initState() {
    _pageControllers.addAll(List.generate(
        widget.pages.length - 1,
        (index) => AnimationController(
            vsync: this, duration: Duration(milliseconds: 2000))));
    for (var i = 0; i < _pageControllers.length; ++i) {
      var e = _pageControllers[i];
      AnimationController? next =
          i < _pageControllers.length - 1 ? _pageControllers[i + 1] : null;
      e.addListener(() {
        setState(() {
          if (e.isCompleted) {
            if (next != null) {
              _startAnimation(next);
            }
          }
        });
      });
    }
    _startAnimation(_pageControllers.first);
    super.initState();
  }

  void _stopAll() {
    for (var o in _pageControllers) {
      o.stop();
    }
  }

  void _startAnimation(AnimationController controller) {
    print('_FoldingCardState._startAnimation: $controller');
    if (widget.expanded) {
      controller.forward(from: 0);
    } else {
      controller.reverse(from: 1);
    }
  }

  @override
  void didUpdateWidget(covariant FoldingCard oldWidget) {
    setState(() {
      _stopAll();
      _startAnimation(_pageControllers.first);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (var o in _pageControllers) {
      o.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    children.add(Transform.translate(
      offset: Offset(
        0.0,
        0.0,
        // -widget.pageHeight * (i - 1),
      ),
      child: _FoldingPage(
        alignment: Alignment.topCenter,
        animationValue: 0,
        background: widget.pageBackground,
        child: SizedBox(
          child: widget.pages.first,
          height: widget.pageHeight,
        ),
      ),
    ));
    for (var i = 1; i < widget.pages.length; ++i) {
      var o = widget.pages[i];
      children.add(Transform.translate(
        offset: Offset(
          0.0,
          0.0,
          // -widget.pageHeight * (i - 1),
        ),
        child: _FoldingPage(
          alignment: Alignment.bottomCenter,
          animationValue: _pageControllers[i - 1].value,
          background: widget.pageBackground,
          child: SizedBox(
            child: o,
            height: widget.pageHeight,
          ),
        ),
      ));
    }
    children.add(Transform.translate(
      offset: Offset(
        0.0,
        0.0,
        // -widget.pageHeight * widget.pages.length,
      ),
      child: _FoldingPage(
        alignment: Alignment.bottomCenter,
        animationValue: 0,
        background: widget.pageBackground,
        child: SizedBox(
          child: widget.cover,
          height: widget.pageHeight,
        ),
      ),
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _FoldingPage extends StatelessWidget {
  final Alignment alignment;
  final Widget child;
  final double animationValue;
  final Decoration? background;

  const _FoldingPage({
    Key? key,
    required this.alignment,
    required this.child,
    this.animationValue: 0,
    this.background,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: alignment,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(animationValue * -math.pi)
      //
      ,
      child: Transform(
        alignment: alignment,
        transform: Matrix4.identity()..rotateX(animationValue * math.pi),
        child: Container(
          child: child,
          // foregroundDecoration: animationValue >= 0.5 ? null : background,
        ),
      ),
    );
  }
}
