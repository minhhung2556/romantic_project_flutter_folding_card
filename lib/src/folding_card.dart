import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FoldingPage extends StatefulWidget {
  final Widget expandedChild;
  final double expandedHeight;
  final double foldingHeight;
  final Widget cover;
  final Widget? pageBackground;
  final bool foldOut;
  final Function(double value, AnimationStatus status)? listener;
  final Curve curve;
  final Duration duration;

  const FoldingPage({
    Key? key,
    this.foldOut: false,
    this.listener,
    this.curve: Curves.linear,
    this.duration: const Duration(milliseconds: 1200),
    required this.cover,
    this.pageBackground,
    required this.expandedChild,
    required this.expandedHeight,
    required this.foldingHeight,
  })  : assert(expandedHeight ~/ foldingHeight >= 1),
        super(key: key);

  @override
  _FoldingPageState createState() => _FoldingPageState();
}

class _FoldingPageState extends State<FoldingPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late TweenSequence<Alignment> _alignmentTween;
  late TweenSequence<Offset> _translateTween;
  late int foldCount;
  late final AnimationController _controllerShadow;
  late TweenSequence<double> _shadowTween;
  late TweenSequence<double> _bottomMarginTween;
  late TweenSequence<double> _topMarginTween;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: widget.duration, value: 1.0);
    _controller.addListener(() {
      if (widget.listener != null) {
        widget.listener!(_controller.value, _controller.status);
      }
      setState(() {});
    });
    _controllerShadow =
        AnimationController(vsync: this, duration: widget.duration);
    _controllerShadow.addListener(() {
      setState(() {});
    });
    _createTweens();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createTweens() {
    foldCount = (widget.expandedHeight / widget.foldingHeight).round();
    if (foldCount * widget.foldingHeight > widget.expandedHeight) {
      foldCount--;
    } else if (foldCount * widget.foldingHeight < widget.expandedHeight) {
      foldCount++;
    }
    var weightPerPage = 1.0 / foldCount;
    _alignmentTween = TweenSequence(List.generate(foldCount, (index) {
      var a = index % 2 == 0 ? Alignment.bottomCenter : Alignment.topCenter;
      return TweenSequenceItem(
        tween: Tween(begin: a, end: a),
        weight: weightPerPage,
      );
    }));
    _translateTween = TweenSequence(List.generate(
      foldCount,
      (index) {
        var y = index ~/ 2 * (-widget.foldingHeight * 2);
        return TweenSequenceItem(
          tween: Tween(begin: Offset(0, y), end: Offset(0, y)),
          weight: weightPerPage,
        );
      },
    ));
    _shadowTween = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 0.1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0),
        weight: 0.8,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 0.1,
      ),
    ]);
    _bottomMarginTween = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: widget.foldingHeight),
        weight: 0.2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.foldingHeight, end: widget.foldingHeight),
        weight: 0.7,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.foldingHeight, end: 0.0),
        weight: 0.1,
      ),
    ]);
    _topMarginTween = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: widget.foldingHeight, end: 0.0),
        weight: weightPerPage / 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: widget.foldingHeight),
        weight: 1 - weightPerPage,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.foldingHeight, end: 0.0),
        weight: weightPerPage / 2,
      ),
    ]);
  }

  @override
  void didChangeDependencies() {
    _controllerShadow.value = 0;
    if (widget.foldOut) {
      _controller.value = 0;
    } else {
      _controller.value = 1;
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant FoldingPage oldWidget) {
    _createTweens();

    if (oldWidget.foldOut != widget.foldOut) {
      if (widget.foldOut) {
        _controllerShadow.forward(from: 0);
        if (_controller.value > 0) _controller.reverse(from: 1);
      } else {
        _controllerShadow.reverse(from: 1.0);
        if (_controller.value < 1) _controller.forward(from: 0);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var animationValue =
        widget.curve.transform(_controller.value).clamp(0.0, 1.0);
    var weightPerPage = 1.0 / foldCount;
    var needBackground = animationValue >= weightPerPage / 2;
    var offsetY = widget.expandedHeight +
        widget.foldingHeight -
        (foldCount + 1) * widget.foldingHeight;
    var expandedHeightFactor = math.max(
        widget.foldingHeight / widget.expandedHeight,
        ((1.0 - animationValue) * 1.22).clamp(0.0, 1.0));
    return Padding(
      padding: EdgeInsets.only(
        bottom: _bottomMarginTween.transform(1 - animationValue),
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Column(
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: expandedHeightFactor,
                  child: SizedBox(
                    height: widget.expandedHeight,
                    child: widget.expandedChild,
                  ),
                ),
              ),
              Stack(
                children: [
                  SizedBox(
                    height: _topMarginTween.transform(animationValue),
                  ),
                  Opacity(
                    opacity: _shadowTween.transform((1 - animationValue)),
                    child: Container(
                      foregroundDecoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87,
                            blurRadius: widget.foldingHeight,
                            spreadRadius: widget.foldingHeight * 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Transform(
            transform: Matrix4.identity()
              ..translate(
                  0.0, widget.foldingHeight * (foldCount - 1) + offsetY),
            child: Transform(
              transform: Matrix4.identity()
                ..translate(
                    0.0,
                    _translateTween.transform(animationValue).dy -
                        (needBackground ? offsetY : 0)),
              child: Transform(
                alignment: _alignmentTween.transform(animationValue),
                transform: Matrix4.identity() //
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(animationValue * -math.pi * foldCount),
                child: Transform(
                  alignment: _alignmentTween.transform(animationValue),
                  transform: Matrix4.identity() //
                    ..rotateX(math.pi),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity() //
                      ..rotateX(math.pi),
                    child: Stack(
                      children: [
                        SizedBox(
                          child: widget.cover,
                          width: double.infinity,
                          height: widget.foldingHeight,
                        ),
                        if (needBackground && widget.pageBackground != null)
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity() //
                              ..rotateX(foldCount % 2 != 0 ? math.pi : 0),
                            child: SizedBox(
                              child: widget.pageBackground!,
                              width: double.infinity,
                              height: widget.foldingHeight,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
