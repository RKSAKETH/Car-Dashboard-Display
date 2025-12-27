import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const ElechargeApp());
}

class ElechargeApp extends StatelessWidget {
  const ElechargeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elecharge Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F3F7),
        primaryColor: const Color(0xFF6E4AFF),
        useMaterial3: true,
        fontFamily: 'SansSerif', // Uses default system font
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
      // Top Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.bolt, color: Colors.black, size: 30),
        title: const Text(
          "elecharge\ndashboard",
          style: TextStyle(color: Colors.black, fontSize: 16, height: 1.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          Switch(value: false, onChanged: (v) {}),
          const CircleAvatar(
            backgroundColor: Color(0xFF6E4AFF),
            radius: 16,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      // Sidebar icons represented as a Drawer for mobile
      drawer: const SideMenuDrawer(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Section
            VehicleTypeSelector(),
            SizedBox(height: 20),

            // Main Car Image Section
            CarImageCard(),
            SizedBox(height: 20),

            // Routine & Voltage Row
            Row(
              children: [
                Expanded(child: ChargingRoutineCard()),
                SizedBox(width: 16),
                Expanded(child: VoltageDialCard()),
              ],
            ),
            SizedBox(height: 20),

            // Quick Stats Row
            QuickStatsRow(),
            SizedBox(height: 20),

            // Charge History Graph
            ChargeHistoryCard(),
            SizedBox(height: 20),

            // "Right Panel" Content moved to bottom for Mobile
            ChargingPowerSection(),
            SizedBox(height: 20),
            
            // Bottom Analytics
            PowerAnalyticsCard(),
            SizedBox(height: 20),
            
            // Footer Car Selector
            FooterCarSelector(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Center(child: Icon(Icons.bolt, size: 50))),
          ListTile(leading: Icon(Icons.recycling), title: Text("Recycle")),
          ListTile(leading: Icon(Icons.electric_bolt), title: Text("Energy")),
          ListTile(leading: Icon(Icons.threed_rotation), title: Text("360 View")),
          ListTile(leading: Icon(Icons.near_me), title: Text("Navigation")),
          ListTile(leading: Icon(Icons.refresh), title: Text("Sync")),
        ],
      ),
    );
  }
}

class VehicleTypeSelector extends StatelessWidget {
  const VehicleTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]
            ),
            child: const Text("electric vehicle", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Hybrid vehicle", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class CarImageCard extends StatelessWidget {
  const CarImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black,
        image: const DecorationImage(
          // Using a placeholder that looks like an EV charger port
          image: NetworkImage('https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'), 
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.purpleAccent, BlendMode.overlay),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 20, left: 20,
            child: Text("3.3 kW\nto 19.2 kW", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          Positioned(
            bottom: 16, right: 16,
            child: Row(
              children: [
                _circleBtn(Icons.remove),
                const SizedBox(width: 8),
                _circleBtn(Icons.add),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon) {
    return Container(
      width: 32, height: 32,
      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}

class ChargingRoutineCard extends StatelessWidget {
  const ChargingRoutineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Charging\nRoutine", style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.menu, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          _statRow("Average CD", "45 min"),
          _statRow("Peak CP", "10.5 kW"),
          _statRow("Energy", "350 kWh"),
          const SizedBox(height: 12),
          // Simple visual representation of the donut charts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               _miniDonut(Colors.blue, "+69"),
               _miniDonut(Colors.purpleAccent, "+58"),
            ],
          )
        ],
      ),
    );
  }

  Widget _statRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(val, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _miniDonut(Color color, String text) {
    return SizedBox(
      width: 30, height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: 0.7, color: color, strokeWidth: 3, backgroundColor: color.withOpacity(0.2)),
          Text(text, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class VoltageDialCard extends StatelessWidget {
  const VoltageDialCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerRight, child: Icon(Icons.more_horiz, size: 16)),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90, height: 90,
                child: CircularProgressIndicator(
                  value: 0.6, 
                  strokeWidth: 8, 
                  color: const Color(0xFF6E4AFF),
                  backgroundColor: Colors.grey.shade200,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: const [
                  Text("VOLTAGE", style: TextStyle(fontSize: 8, color: Colors.grey)),
                  Text("250\u1D5B", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text("240V", style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statItem(Icons.check, Colors.purpleAccent, "-120v", "Less than last week"),
        _statItem(Icons.battery_charging_full, Colors.blue, "16 times", "This month"),
        _statItem(Icons.text_fields, Colors.purple, "+17%", "Last week"),
      ],
    );
  }

  Widget _statItem(IconData icon, Color color, String bigText, String subText) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
               padding: const EdgeInsets.all(4),
               decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
               child: Icon(icon, color: Colors.white, size: 14),
             ),
             const SizedBox(height: 8),
             Text(bigText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
             Text(subText, style: const TextStyle(fontSize: 9, color: Colors.grey, overflow: TextOverflow.ellipsis), maxLines: 1),
          ],
        ),
      ),
    );
  }
}

class ChargeHistoryCard extends StatelessWidget {
  const ChargeHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 180,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Charge\nHistory", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("insights", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text("\$42.75", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: SimpleWavePainter(),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sun", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Mon", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Tue", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Wed", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}

class SimpleWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
    
    // Draw the dot
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.28), 4, Paint()..color = Colors.blue);
    
    // Text for KWh
    TextPainter tp = TextPainter(
      text: const TextSpan(text: "+350 kWh", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr
    );
    tp.layout();
    tp.paint(canvas, Offset(size.width * 0.65, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChargingPowerSection extends StatelessWidget {
  const ChargingPowerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFEBEBF0), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Charging\nPower »", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
              Text("J1772\nL.1-2", textAlign: TextAlign.right, style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 5),
          const Text("Power Output 19.2 kW", style: TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140, height: 140,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 12,
                    color: const Color(0xFF6E4AFF),
                    backgroundColor: Colors.white,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Level 2", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text("10 to 20 miles", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text("240V", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Decorative icons around
                 Positioned(top: 10, child: Icon(Icons.bolt, size: 16, color: Colors.grey)),
                 Positioned(left: 10, child: Icon(Icons.ev_station, size: 16, color: Colors.grey)),
                 Positioned(right: 10, child: Icon(Icons.electrical_services, size: 16, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "include J1772 (for Level 1 and 2), CHAdeMO, CCS Combo, and Supercharger.",
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_outward, color: Colors.white, size: 16),
            ),
          )
        ],
      ),
    );
  }
}

class PowerAnalyticsCard extends StatelessWidget {
  const PowerAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Power Analytics", style: TextStyle(fontSize: 12)),
        const SizedBox(height: 5),
        const Text("480V DC", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text("● 60 to 80 miles", style: TextStyle(color: Colors.purple, fontSize: 12)),
        const SizedBox(height: 15),
        Stack(
          children: [
            Container(height: 10, color: Colors.grey.shade300),
            Container(height: 10, width: 250, color: Colors.purple),
            Container(height: 10, width: 120, color: Colors.cyanAccent.withOpacity(0.5)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("read more", style: TextStyle(color: Colors.white)),
              Icon(Icons.double_arrow, color: Colors.white, size: 16)
            ],
          ),
        )
      ],
    );
  }
}

class FooterCarSelector extends StatelessWidget {
  const FooterCarSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Park ev\nautomatically\nvol.1", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _carIcon(Icons.directions_car, true),
            const SizedBox(width: 10),
            _carIcon(Icons.local_shipping, false),
            const SizedBox(width: 10),
            _carIcon(Icons.time_to_leave, false),
          ],
        )
      ],
    );
  }

  Widget _carIcon(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: isSelected ? Border.all(color: Colors.purple, width: 2) : null,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Icon(icon, color: Colors.black),
    );
  }
}