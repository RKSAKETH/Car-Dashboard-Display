import 'package:flutter/material.dart';
import 'controls_screen.dart'; // Import the file we created above
import 'map_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const ElechargeApp());
}

class ElechargeApp extends StatefulWidget {
  const ElechargeApp({super.key});

  @override
  State<ElechargeApp> createState() => _ElechargeAppState();
}

class _ElechargeAppState extends State<ElechargeApp> {
  // 1. State variable to track the theme
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elecharge Dashboard',
      // 2. Define the Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F3F7),
        cardColor: Colors.white,
        canvasColor: Colors.black,
        primaryColor: const Color(0xFF6E4AFF),
        useMaterial3: true,
        fontFamily: 'SansSerif',
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      // 3. Define the Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        canvasColor: Colors.white,
        primaryColor: const Color(0xFF6E4AFF),
        useMaterial3: true,
        fontFamily: 'SansSerif',
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      // 4. Bind the state to the themeMode
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: MainNavigationScaffold(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

// Wrapper for Bottom Navigation Logic
class MainNavigationScaffold extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const MainNavigationScaffold({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of screens for navigation
    final List<Widget> pages = [
      // Index 0: The Dashboard
      DashboardContent(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
      // Index 1: The Controls Screen (Imported from controls_screen.dart)
      const ControlsScreen(),
      // Index 2: Placeholders for other tabs
      const MapScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Needed for 4+ items
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: const Color(0xFF6E4AFF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Controls',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Refactored Dashboard to be a component
class DashboardContent extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const DashboardContent({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  // State to track vehicle type
  bool isElectric = true;

  void toggleVehicleType(bool electric) {
    setState(() {
      isElectric = electric;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;
    final iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.bolt, color: iconColor, size: 30),
        title: Text(
          "Car Dashboard Display",
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            height: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
            activeColor: const Color(0xFF6E4AFF),
          ),
          const CircleAvatar(
            backgroundColor: Color(0xFF6E4AFF),
            radius: 16,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: SideMenuDrawer(iconColor: iconColor!),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Updated Selector with callback
            VehicleTypeSelector(
              isElectric: isElectric,
              onTypeChanged: toggleVehicleType,
            ),
            const SizedBox(height: 20),

            // Conditionally render content based on Vehicle Type
            if (isElectric) ...[
              // --- ELECTRIC COMPONENTS ---
              const CarImageCard(imageParams: "3.3 kW\nto 19.2 kW"),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: ChargingRoutineCard()),
                  SizedBox(width: 16),
                  Expanded(child: VoltageDialCard()),
                ],
              ),
              const SizedBox(height: 20),
              const QuickStatsRow(),
              const SizedBox(height: 20),
              const ChargeHistoryCard(),
              const SizedBox(height: 20),
              const ChargingPowerSection(),
              const SizedBox(height: 20),
              const PowerAnalyticsCard(),
            ] else ...[
              // --- HYBRID COMPONENTS ---
              const CarImageCard(imageParams: "45 MPG\nHybrid Drive"),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: HybridFuelCard()),
                  SizedBox(width: 16),
                  Expanded(child: FuelGaugeCard()),
                ],
              ),
              const SizedBox(height: 20),
              const HybridQuickStatsRow(),
              const SizedBox(height: 20),
              const FuelHistoryCard(),
              const SizedBox(height: 20),
              const EnginePowerSection(),
              const SizedBox(height: 20),
              const HybridAnalyticsCard(),
            ],

            // REMOVED: FooterCarSelector and "Park ev" text as requested.
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// --- SHARED & NAVIGATION WIDGETS ---

class SideMenuDrawer extends StatelessWidget {
  final Color iconColor;
  const SideMenuDrawer({super.key, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(child: Icon(Icons.bolt, size: 50, color: iconColor)),
          ),
          ListTile(
            leading: Icon(Icons.recycling, color: iconColor),
            title: Text("Recycle", style: TextStyle(color: iconColor)),
          ),
          ListTile(
            leading: Icon(Icons.electric_bolt, color: iconColor),
            title: Text("Energy", style: TextStyle(color: iconColor)),
          ),
          ListTile(
            leading: Icon(Icons.threed_rotation, color: iconColor),
            title: Text("360 View", style: TextStyle(color: iconColor)),
          ),
          ListTile(
            leading: Icon(Icons.near_me, color: iconColor),
            title: Text("Navigation", style: TextStyle(color: iconColor)),
          ),
          ListTile(
            leading: Icon(Icons.refresh, color: iconColor),
            title: Text("Sync", style: TextStyle(color: iconColor)),
          ),
        ],
      ),
    );
  }
}

class VehicleTypeSelector extends StatelessWidget {
  final bool isElectric;
  final Function(bool) onTypeChanged;

  const VehicleTypeSelector({
    super.key,
    required this.isElectric,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Electric Button
          GestureDetector(
            onTap: () => onTypeChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isElectric ? cardColor : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isElectric
                    ? [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                "Electric vehicle",
                style: TextStyle(
                  fontWeight: isElectric ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                  color: isElectric ? textColor : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Hybrid Button
          GestureDetector(
            onTap: () => onTypeChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: !isElectric ? cardColor : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                boxShadow: !isElectric
                    ? [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                "Hybrid vehicle",
                style: TextStyle(
                  fontWeight: !isElectric ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                  color: !isElectric ? textColor : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarImageCard extends StatelessWidget {
  final String imageParams;
  const CarImageCard({super.key, required this.imageParams});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black,
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.purpleAccent, BlendMode.overlay),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              imageParams,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: [
                _circleBtn(Icons.remove),
                const SizedBox(width: 8),
                _circleBtn(Icons.add),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}

// --- ELECTRIC VEHICLE WIDGETS ---

class ChargingRoutineCard extends StatelessWidget {
  const ChargingRoutineCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Charging\nRoutine",
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              const Icon(Icons.menu, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          _statRow("Average CD", "45 min", textColor!),
          _statRow("Peak CP", "10.5 kW", textColor),
          _statRow("Energy", "350 kWh", textColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _miniDonut(Colors.blue, "+69", textColor),
              _miniDonut(Colors.purpleAccent, "+58", textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String val, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
            val,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniDonut(Color color, String text, Color textColor) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 0.7,
            color: color,
            strokeWidth: 3,
            backgroundColor: color.withOpacity(0.2),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class VoltageDialCard extends StatelessWidget {
  const VoltageDialCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.more_horiz, size: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: 0.6,
                  strokeWidth: 8,
                  color: const Color(0xFF6E4AFF),
                  backgroundColor: Colors.grey.shade200,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  const Text(
                    "VOLTAGE",
                    style: TextStyle(fontSize: 8, color: Colors.grey),
                  ),
                  Text(
                    "250\u1D5B",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "240V",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
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
        _statItem(
          context,
          Icons.check,
          Colors.purpleAccent,
          "-120v",
          "Less than last week",
        ),
        _statItem(
          context,
          Icons.battery_charging_full,
          Colors.blue,
          "16 times",
          "This month",
        ),
        _statItem(
          context,
          Icons.text_fields,
          Colors.purple,
          "+17%",
          "Last week",
        ),
      ],
    );
  }

  Widget _statItem(
    BuildContext context,
    IconData icon,
    Color color,
    String bigText,
    String subText,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            const SizedBox(height: 8),
            Text(
              bigText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            Text(
              subText,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
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
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Charge\nHistory",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "insights",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    "\$42.75",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(painter: SimpleWavePainter(color: textColor!)),
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
          ),
        ],
      ),
    );
  }
}

class SimpleWavePainter extends CustomPainter {
  final Color color;
  SimpleWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height * 0.4);

    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.28),
      4,
      Paint()..color = Colors.blue,
    );

    TextPainter tp = TextPainter(
      text: TextSpan(
        text: "+350 kWh",
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(size.width * 0.65, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ChargingPowerSection extends StatelessWidget {
  const ChargingPowerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2C2C2E)
        : const Color(0xFFEBEBF0);
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;
    final circleTextColor = Theme.of(context).canvasColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Charging\nPower »",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
              const Text(
                "J1772\nL.1-2",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Power Output 19.2 kW",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 12,
                    color: const Color(0xFF6E4AFF),
                    backgroundColor: Theme.of(context).cardColor,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Level 2",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const Text(
                      "10 to 20 miles",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      "240V",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  top: 10,
                  child: Icon(Icons.bolt, size: 16, color: Colors.grey),
                ),
                const Positioned(
                  left: 10,
                  child: Icon(Icons.ev_station, size: 16, color: Colors.grey),
                ),
                const Positioned(
                  right: 10,
                  child: Icon(
                    Icons.electrical_services,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
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
              decoration: BoxDecoration(
                color: circleTextColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_outward,
                color: Theme.of(context).cardColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PowerAnalyticsCard extends StatelessWidget {
  const PowerAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;
    // Removed Button Color as button is removed

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Power Analytics",
          style: TextStyle(fontSize: 12, color: textColor),
        ),
        const SizedBox(height: 5),
        Text(
          "480V DC",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const Text(
          "● 60 to 80 miles",
          style: TextStyle(color: Colors.purple, fontSize: 12),
        ),
        const SizedBox(height: 15),
        Stack(
          children: [
            Container(height: 10, color: Colors.grey.shade300),
            Container(height: 10, width: 250, color: Colors.purple),
            Container(
              height: 10,
              width: 120,
              color: Colors.cyanAccent.withOpacity(0.5),
            ),
          ],
        ),
        // REMOVED "Read More" button here
      ],
    );
  }
}

// --- HYBRID VEHICLE WIDGETS ---

class HybridFuelCard extends StatelessWidget {
  const HybridFuelCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fuel & \nBattery",
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              const Icon(Icons.local_gas_station, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          _statRow("Avg MPG", "48 mpg", textColor!),
          _statRow("Range", "520 mi", textColor),
          _statRow("EV Mode", "45 mi", textColor),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Fuel Icon
              Icon(Icons.water_drop, color: Colors.amber, size: 24),
              // Battery Icon
              Icon(Icons.battery_charging_full, color: Colors.green, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String val, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(
            val,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class FuelGaugeCard extends StatelessWidget {
  const FuelGaugeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.more_horiz, size: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: 0.8,
                  strokeWidth: 8,
                  color: Colors.amber,
                  backgroundColor: Colors.grey.shade200,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  const Text(
                    "FUEL",
                    style: TextStyle(fontSize: 8, color: Colors.grey),
                  ),
                  Text(
                    "80%",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Regular Unleaded",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class HybridQuickStatsRow extends StatelessWidget {
  const HybridQuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statItem(context, Icons.oil_barrel, Colors.amber, "20%", "Oil Life"),
        _statItem(
          context,
          Icons.speed,
          Colors.redAccent,
          "42psi",
          "Tire Pressure",
        ),
        _statItem(context, Icons.eco, Colors.green, "96", "Eco Score"),
      ],
    );
  }

  Widget _statItem(
    BuildContext context,
    IconData icon,
    Color color,
    String bigText,
    String subText,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            const SizedBox(height: 8),
            Text(
              bigText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            Text(
              subText,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class FuelHistoryCard extends StatelessWidget {
  const FuelHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fuel\nExpenses",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "This Month",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    "\$85.50",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Reusing wave painter but with different color
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(painter: SimpleWavePainter(color: Colors.amber)),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Wk 1", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Wk 2", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Wk 3", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Wk 4", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class EnginePowerSection extends StatelessWidget {
  const EnginePowerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2C2C2E)
        : const Color(0xFFEBEBF0);
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;
    final circleTextColor = Theme.of(context).canvasColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Engine\nOutput »",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
              ),
              const Text(
                "2.0L\n4-Cyl",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Combined 204 hp",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: 0.4,
                    strokeWidth: 12,
                    color: Colors.redAccent,
                    backgroundColor: Theme.of(context).cardColor,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "RPM",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const Text(
                      "Driving",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      "2.4k",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Internal Combustion Engine active. Regenerative braking enabled.",
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: circleTextColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_outward,
                color: Theme.of(context).cardColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HybridAnalyticsCard extends StatelessWidget {
  const HybridAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Drive Analytics",
          style: TextStyle(fontSize: 12, color: textColor),
        ),
        const SizedBox(height: 5),
        Text(
          "Hybrid Mode",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const Text(
          "● Efficiency 48 MPG",
          style: TextStyle(color: Colors.green, fontSize: 12),
        ),
        const SizedBox(height: 15),
        Stack(
          children: [
            Container(height: 10, color: Colors.grey.shade300),
            Container(height: 10, width: 280, color: Colors.green),
            Container(
              height: 10,
              width: 100,
              color: Colors.amber.withOpacity(0.5),
            ),
          ],
        ),
        // REMOVED "Full Report" button here
      ],
    );
  }
}