import 'package:flutter/material.dart';

class WidgetShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const WidgetShimmer({
    Key? key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  _WidgetShimmerState createState() => _WidgetShimmerState();
}

class _WidgetShimmerState extends State<WidgetShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + (_controller.value * 3), 0.0),
              end: Alignment(0.0 + (_controller.value * 3), 0.0),
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
              ],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}
