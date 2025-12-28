// Save this file as: car_loading_screen.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

class CarLoadingScreen extends StatefulWidget {
  final String? message;
  final Duration? duration; // How long the animation should run before stopping
  final VoidCallback? onComplete; // Callback when animation completes
  
  const CarLoadingScreen({
    super.key,
    this.message,
    this.duration = const Duration(seconds: 5), // Default 5 seconds
    this.onComplete,
  });

  @override
  State<CarLoadingScreen> createState() => _CarLoadingScreenState();
}

class _CarLoadingScreenState extends State<CarLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _carAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // If duration is provided, use it; otherwise loop indefinitely
    if (widget.duration != null) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
      );
      
      _controller.forward().then((_) {
        if (mounted) {
          // Call the completion callback if provided
          widget.onComplete?.call();
          // Or automatically pop the screen
          if (widget.onComplete == null) {
            Navigator.of(context).pop();
          }
        }
      });
    } else {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat();
    }

    _carAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(300, 100),
                  painter: CarLoadingPainter(_carAnimation.value),
                );
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 450,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 40,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.message ?? 'loading..',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarLoadingPainter extends CustomPainter {
  final double progress;

  CarLoadingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Calculate car position (moving back and forth)
    double carX = size.width * 0.3 + 
                  (size.width * 0.4) * math.sin(progress * 2 * math.pi);
    double carY = size.height * 0.4;

    // Draw speed lines behind the car
    for (int i = 0; i < 3; i++) {
      double lineX = carX - 40 - (i * 15);
      double lineY = carY - 10 + (i * 5);
      double lineLength = 20 - (i * 5);
      
      canvas.drawLine(
        Offset(lineX, lineY),
        Offset(lineX - lineLength, lineY),
        linePaint..strokeWidth = 2 - (i * 0.5),
      );
    }

    // Save canvas state for car drawing
    canvas.save();
    canvas.translate(carX, carY);

    // Draw car body (simplified vintage car shape)
    final carBodyPath = Path();
    carBodyPath.moveTo(-25, 0);
    carBodyPath.lineTo(-20, -15);
    carBodyPath.lineTo(-5, -20);
    carBodyPath.lineTo(15, -20);
    carBodyPath.lineTo(25, -10);
    carBodyPath.lineTo(25, 0);
    carBodyPath.close();
    canvas.drawPath(carBodyPath, paint);

    // Draw car roof
    final roofPath = Path();
    roofPath.moveTo(-15, -20);
    roofPath.lineTo(-10, -28);
    roofPath.lineTo(5, -28);
    roofPath.lineTo(10, -20);
    roofPath.close();
    canvas.drawPath(roofPath, paint);

    // Draw windows
    final windowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      const Rect.fromLTWH(-12, -26, 8, 6),
      windowPaint,
    );
    canvas.drawRect(
      const Rect.fromLTWH(2, -26, 6, 6),
      windowPaint,
    );

    // Draw wheels with rotation
    final wheelPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final wheelBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Wheel rotation
    double wheelRotation = progress * 4 * math.pi;

    // Front wheel
    canvas.save();
    canvas.translate(-12, 5);
    canvas.rotate(wheelRotation);
    canvas.drawCircle(Offset.zero, 6, wheelPaint);
    canvas.drawCircle(Offset.zero, 6, wheelBorder);
    canvas.drawLine(
      const Offset(-4, 0),
      const Offset(4, 0),
      wheelBorder,
    );
    canvas.drawLine(
      const Offset(0, -4),
      const Offset(0, 4),
      wheelBorder,
    );
    canvas.restore();

    // Back wheel
    canvas.save();
    canvas.translate(12, 5);
    canvas.rotate(wheelRotation);
    canvas.drawCircle(Offset.zero, 6, wheelPaint);
    canvas.drawCircle(Offset.zero, 6, wheelBorder);
    canvas.drawLine(
      const Offset(-4, 0),
      const Offset(4, 0),
      wheelBorder,
    );
    canvas.drawLine(
      const Offset(0, -4),
      const Offset(0, 4),
      wheelBorder,
    );
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}