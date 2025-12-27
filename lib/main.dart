import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CarDashboardApp());
}

class CarDashboardApp extends StatelessWidget {
  const CarDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial', color: Colors.white),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive layout: SingleChildScrollView handles overflow
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Face ID (Large) + Column (Time Stats & Clock)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Face ID Card
                    Expanded(
                      flex: 4,
                      child: _buildFaceIdCard(),
                    ),
                    const SizedBox(width: 12),
                    // Right Column: Stats & Clock
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildAvgTimeCard(),
                          const SizedBox(height: 12),
                          Expanded(child: _buildClockCard()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Middle Row: Map & Navigation
              Row(
                children: [
                  Expanded(child: _buildMapCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNavCard()),
                ],
              ),
              const SizedBox(height: 12),
              
              // Bottom Section: Car Stats & Music
              // Stacking vertically for mobile width
              _buildCarStatsCard(),
              const SizedBox(height: 12),
              _buildMusicPlayerCard(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Components ---

  Widget _buildAvgTimeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 16),
              children: [
                TextSpan(text: "23.6 ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextSpan(text: "minutes", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text("Average time in the car.", style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: CustomPaint(
              size: const Size(double.infinity, 40),
              painter: ChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceIdCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // Gradient simulates the image aesthetic
        gradient: const LinearGradient(
          colors: [Color(0xFFD49C44), Color(0xFF6E4F23)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Simulate the blurry face image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Opacity(
                opacity: 0.3,
                child: Image.network(
                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(color: Colors.black26),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                  ),
                  child: const Icon(Icons.lock, color: Colors.white, size: 20),
                ),
                const Spacer(),
                const Text("Face Recognized", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("All doors locked.", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClockCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Clock Face ticks
          CustomPaint(
            size: const Size(80, 80),
            painter: ClockDialPainter(),
          ),
          // Hands (Simulated)
          Transform.rotate(
            angle: -0.5,
            child: Container(width: 4, height: 35, color: Colors.orange, margin: const EdgeInsets.only(bottom: 30)),
          ),
          Transform.rotate(
            angle: 2.0,
            child: Container(width: 4, height: 25, color: Colors.white, margin: const EdgeInsets.only(bottom: 20)),
          ),
          Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          const Positioned(
            bottom: 12,
            child: Text("07:23", style: TextStyle(color: Colors.white, fontSize: 14)),
          )
        ],
      ),
    );
  }

  Widget _buildNavCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 140, // Fixed height for alignment
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.turn_right, size: 32, color: Colors.white),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("240m", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Turn to right.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.grey[800], shape: BoxShape.circle),
                child: const Icon(Icons.location_on_outlined, size: 14, color: Colors.orange),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Manta St, 176W.", style: TextStyle(color: Colors.orange, fontSize: 12)),
                    Text("23 minutes without traffic.", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          // Using a subtle pattern to mimic the dot map
          image: NetworkImage("https://www.transparenttextures.com/patterns/dark-matter.png"),
          opacity: 0.2,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              child: const Icon(Icons.swap_calls, color: Colors.black, size: 16),
            ),
          ),
          const Spacer(),
          // Radar ripple effect simulation
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text("Hutchinson, Kansas, US", style: TextStyle(color: Colors.orange, fontSize: 12)),
          const Text("Scheduled Trip", style: TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildCarStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // Car Image placeholder
          Expanded(
            flex: 2,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // Placeholder for top-down car view
                  image: NetworkImage("https://cdn-icons-png.flaticon.com/512/3202/3202926.png"),
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  fit: BoxFit.contain
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Stats Column
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow("62.7", "km/h", "Average speed"),
                const SizedBox(height: 12),
                _buildStatRow("13.9", "HP", "Engine brth power", color: Colors.orange),
                const SizedBox(height: 12),
                _buildStatRow("20.4", "N.m", "Torque ratio", color: Colors.orange),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatRow(String val, String unit, String label, {Color color = Colors.white}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "$val ", style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
              TextSpan(text: unit, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildMusicPlayerCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2C2C), Color(0xFF8B4513)], // Dark to Brown/Orange
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: const NetworkImage("https://upload.wikimedia.org/wikipedia/en/e/e6/The_Weeknd_-_Blinding_Lights.png"),
              backgroundColor: Colors.black,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Blinding Lights", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("The Weeknd", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.skip_previous, color: Colors.white70),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.white), shape: BoxShape.circle),
                      child: const Icon(Icons.bar_chart, size: 16),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.skip_next, color: Colors.white70),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: const Color(0xFF151515),
      borderRadius: BorderRadius.circular(24),
    );
  }
}

// --- Custom Painters for Charts and Clock ---

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.8, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.2, size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width, 0);

    // Gradient fill below chart
    Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.orange.withOpacity(0.3), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ClockDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint tickPaint = Paint()..color = Colors.grey.withOpacity(0.5)..strokeWidth = 2;
    Paint highlightPaint = Paint()..color = Colors.white..strokeWidth = 2;
    
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    for (int i = 0; i < 60; i+=2) { // 30 ticks
      double angle = (i * 6) * math.pi / 180;
      double outerR = radius;
      double innerR = radius - 5;
      
      bool isHour = i % 5 == 0;
      Paint p = isHour ? highlightPaint : tickPaint;
      if(isHour) innerR -= 4;

      double x1 = centerX + innerR * math.cos(angle);
      double y1 = centerY + innerR * math.sin(angle);
      double x2 = centerX + outerR * math.cos(angle);
      double y2 = centerY + outerR * math.sin(angle);
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}