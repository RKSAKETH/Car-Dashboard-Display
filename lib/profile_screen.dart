import 'package:flutter/material.dart';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rainController;
  bool _showRain = false;
  final List<RainDrop> _rainDrops = [];

  @override
  void initState() {
    super.initState();
    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          for (var drop in _rainDrops) {
            drop.fall();
          }
        });
      });
  }

  @override
  void dispose() {
    _rainController.dispose();
    super.dispose();
  }

  void _startRainAnimation() {
    setState(() {
      _showRain = true;
      _rainDrops.clear();
      
      // Create rain drops
      for (int i = 0; i < 100; i++) {
        _rainDrops.add(RainDrop());
      }
    });

    _rainController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logging out..."))
          );
          setState(() {
            _showRain = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "John@email.com",
                ),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Trip History"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.red)),
                  onTap: _startRainAnimation,
                ),
              ],
            ),
          ),
          if (_showRain)
            IgnorePointer(
              child: CustomPaint(
                painter: RainPainter(_rainDrops),
                size: Size.infinite,
              ),
            ),
        ],
      ),
    );
  }
}

class RainDrop {
  late double x;
  late double y;
  late double speed;
  late double length;
  late double opacity;
  final Random _random = Random();

  RainDrop() {
    reset();
  }

  void reset() {
    x = _random.nextDouble();
    y = -_random.nextDouble() * 0.5;
    speed = 0.01 + _random.nextDouble() * 0.02;
    length = 15 + _random.nextDouble() * 25;
    opacity = 0.3 + _random.nextDouble() * 0.4;
  }

  void fall() {
    y += speed;
    if (y > 1.2) {
      reset();
    }
  }
}

class RainPainter extends CustomPainter {
  final List<RainDrop> rainDrops;

  RainPainter(this.rainDrops);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var drop in rainDrops) {
      paint.color = Colors.blue.withOpacity(drop.opacity);
      
      final startX = drop.x * size.width;
      final startY = drop.y * size.height;
      final endX = startX - 5;
      final endY = startY + drop.length;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}