import 'package:flutter/material.dart';
import 'dart:math' as math;

class ScanningAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const ScanningAnimation({
    Key? key,
    this.size = 200,
    this.color = const Color(0xFF6C63FF),
  }) : super(key: key);

  @override
  State<ScanningAnimation> createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _radiusAnimation = Tween<double>(
      begin: widget.size * 0.3,
      end: widget.size * 0.4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer rotating circle
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: ScannerPainter(
                      color: widget.color,
                      radiusAnimation: _radiusAnimation,
                    ),
                  ),
                );
              },
            ),
            // Inner pulse effect
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: widget.size * 0.4,
                  height: widget.size * 0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        spreadRadius: _pulseAnimation.value * 20,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
            // Center icon
            Icon(
              Icons.security,
              size: widget.size * 0.25,
              color: widget.color,
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerPainter extends CustomPainter {
  final Color color;
  final Animation<double> radiusAnimation;

  ScannerPainter({
    required this.color,
    required this.radiusAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw dashed circle
    final radius = radiusAnimation.value;
    final dashCount = 8;
    final dashLength = (2 * math.pi * radius) / (dashCount * 2);
    
    for (var i = 0; i < dashCount; i++) {
      final startAngle = (i * 2 * math.pi) / dashCount;
      final sweepAngle = math.pi / dashCount;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ScannerPainter oldDelegate) => true;
} 