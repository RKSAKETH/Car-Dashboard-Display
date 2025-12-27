import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      title: 'Car Dashboard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primaryColor: const Color(0xFFC6FF00), // Neon Lime
        cardColor: const Color(0xFF1C1C1E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC6FF00),
          secondary: Color(0xFFC6FF00),
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header (Weather & Profile)
              _buildHeader(),
              const SizedBox(height: 20),

              // 2. Emergency Bar
              _buildEmergencyBar(),
              const SizedBox(height: 20),

              // 3. Car Visuals & Lock Controls
              _buildCarControlSection(),
              const SizedBox(height: 20),

              // 4. Speedometer & Gauges
              _buildGaugeSection(),
              const SizedBox(height: 20),

              // 5. Climate Control Slider
              _buildClimateControl(),
              const SizedBox(height: 20),

              // 6. Map Section
              _buildMapSection(context),
              const SizedBox(height: 20),

              // 7. Calendar
              _buildCalendarSection(),
              const SizedBox(height: 20),

              // 8. Grid Controls (AC, Music, etc.)
              _buildControlGrid(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Climate", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Row(
              children: const [
                Text("23°C", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 8),
                Icon(CupertinoIcons.thermometer, color: Color(0xFFC6FF00), size: 18),
              ],
            ),
            const Text("Window Closed", style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text("25° C", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Rainy", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'), // Placeholder
              radius: 18,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildEmergencyBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Emergency", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Switch On only in emergency case", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          CupertinoSwitch(
            value: false,
            onChanged: (v) {},
            activeColor: Colors.red,
          )
        ],
      ),
    );
  }

  Widget _buildCarControlSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Glow
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [const Color(0xFFC6FF00).withOpacity(0.15), Colors.transparent],
              radius: 0.7,
            ),
          ),
        ),
        // Car Image (Placeholder icon used for portability)
        const Icon(CupertinoIcons.car_detailed, size: 140, color: Colors.grey),
        
        // Controls around the car
        Positioned(
          left: 10,
          child: _buildCircleBtn(Icons.lock_outline),
        ),
        Positioned(
          right: 10,
          child: _buildCircleBtn(Icons.lock_open, active: true),
        ),
        Positioned(
          top: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_left, color: Color(0xFFC6FF00)),
              SizedBox(width: 80),
              Icon(Icons.arrow_right, color: Color(0xFFC6FF00)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildGaugeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSmallGauge("Petrol", "65%", 0.65, Icons.local_gas_station),
        // Main Speedometer
        SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: SpeedometerPainter(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("57", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Km/h", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
        _buildSmallGauge("Battery", "60%", 0.6, Icons.battery_charging_full),
      ],
    );
  }

  Widget _buildSmallGauge(String label, String value, double percent, IconData icon) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: percent,
                strokeWidth: 6,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC6FF00)),
              ),
              Center(child: Icon(icon, size: 20, color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildClimateControl() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("10°C", style: TextStyle(color: Colors.grey)),
              Text("Climate Control", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("40°C", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              activeTrackColor: const Color(0xFFC6FF00),
              inactiveTrackColor: Colors.grey[800],
              thumbColor: const Color(0xFFC6FF00),
              overlayColor: const Color(0xFFC6FF00).withOpacity(0.2),
            ),
            child: Slider(
              value: 0.5,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          // Using a dark map placeholder pattern
          image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/ec/World_map_blank_without_borders.png"), // Placeholder
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          // Simulated Route Line
          Center(
            child: Container(
              width: 4,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey, const Color(0xFFC6FF00)],
                ),
              ),
            ),
          ),
          Center(
            child: Icon(Icons.navigation, color: const Color(0xFFC6FF00), size: 30),
          ),
          
          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.white70),
                  SizedBox(width: 10),
                  Text("Search Destination", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),

          // Bottom Info
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Club Town Gardens", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("NYC, 3 min away", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text("GO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("My Calendar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 5),
          const Text("5 Aug - 2022", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                color: const Color(0xFFC6FF00),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Meeting with clients", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("5:00 - 6:20", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControlGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildGridBtn(Icons.ac_unit, "Air Conditioner"),
        _buildGridBtn(Icons.music_note, "Music"),
        _buildGridBtn(Icons.bluetooth, "Bluetooth"),
        _buildGridBtn(CupertinoIcons.chat_bubble_text_fill, "Message"),
        _buildGridBtn(Icons.chair, "Seat Temp: 20°"),
        _buildGridBtn(Icons.settings, "Settings"),
      ],
    );
  }

  Widget _buildGridBtn(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFFC6FF00) : const Color(0xFF2C2C2E),
        boxShadow: active
            ? [BoxShadow(color: const Color(0xFFC6FF00).withOpacity(0.5), blurRadius: 10)]
            : [],
      ),
      child: Icon(
        icon,
        color: active ? Colors.black : Colors.grey,
        size: 20,
      ),
    );
  }
}

// Custom Painter for the Speedometer Arcs
class SpeedometerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey[800]!;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Draw Ticks
    for (int i = 0; i < 40; i++) {
      double angle = (i * 9) * (math.pi / 180); // Full circle
      // Only draw bottom 2/3rds roughly
      if (angle > math.pi / 4 && angle < math.pi * 2.75) { 
        // Skip bottom area
      }
      
       double startLength = radius - 5;
       if(i % 5 == 0) startLength = radius - 10;

       double x1 = center.dx + radius * math.cos(angle);
       double y1 = center.dy + radius * math.sin(angle);
       double x2 = center.dx + startLength * math.cos(angle);
       double y2 = center.dy + startLength * math.sin(angle);
       
       canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
    
    // Active Arc
    Paint activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = const Color(0xFFC6FF00)
      ..strokeCap = StrokeCap.round;
      
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20), 
      math.pi - 0.5, 
      2.5, 
      false, 
      activePaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}