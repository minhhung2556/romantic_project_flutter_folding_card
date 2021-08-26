import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FoldingCard extends StatefulWidget {
  final bool collapsed;
  final double collapsedHeight;
  final double expandedHeight;

  const FoldingCard({
    Key? key,
    this.collapsed: true,
    this.collapsedHeight: 120,
    this.expandedHeight: 240,
  }) : super(key: key);
  @override
  _FoldingCardState createState() => _FoldingCardState();
}

class _FoldingCardState extends State<FoldingCard>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  bool collapsed = true;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animationController.addListener(() {
      setState(() {});
    });
    _initValues();
    super.initState();
  }

  void _initValues() {
    if (collapsed != widget.collapsed) {
      if (collapsed)
        _animationController.forward(from: 0);
      else
        _animationController.reverse(from: 1);
      collapsed = widget.collapsed;
    }
  }

  @override
  void didUpdateWidget(covariant FoldingCard oldWidget) {
    setState(() {
      _initValues();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var animationValue = _animationController.value;
    var aniHeight = Tween<double>(
            begin: widget.collapsedHeight,
            end: widget.expandedHeight + widget.collapsedHeight)
        .evaluate(_animationController);
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.passthrough,
        children: [
          SizedBox(
            height: aniHeight,
            child: _buildExpanded(context),
          ),
          Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX((1 - animationValue) * -math.pi)
              ..translate(0.0, animationValue * widget.collapsedHeight)
            //
            ,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()..rotateX(math.pi),
              child: Container(
                height: widget.collapsedHeight,
                child: _buildCollapsed(context),
                // foregroundDecoration: animationValue < 0.5
                //     ? null
                //     : BoxDecoration(
                //         color: Colors.red,
                //       ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleState(context);
      },
      child: Container(
        height: widget.expandedHeight,
        color: Colors.blue,
        child: Image.network(
          'https://cdn.aiktry.com/monthly_2020_08/2141736640_NicoRobinRender(OnePieceWorldSeeker).png.c1ef912d4c49b92e34bc9950f32a7fa6.png',
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildCollapsed(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleState(context);
      },
      child: Container(
        height: widget.collapsedHeight,
        child: Image.network(
          'https://gamek.mediacdn.vn/133514250583805952/2021/8/5/spoiler-one-piece-1021pcqy-16281430347201268838506.jpg',
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  void _toggleState(BuildContext context) {
    setState(() {
      if (collapsed)
        _animationController.forward(from: 0);
      else
        _animationController.reverse(from: 1);
      collapsed = !collapsed;
    });
  }
}
