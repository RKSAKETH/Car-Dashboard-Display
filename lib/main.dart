import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF030810),
      ),
      home: const ControlsScreen(),
    );
  }
}

class ControlsScreen extends StatefulWidget {
  const ControlsScreen({super.key});

  @override
  State<ControlsScreen> createState() => _ControlsScreenState();
}

class _ControlsScreenState extends State<ControlsScreen> {
  // State variables for the toggles
  bool isEngineOn = true;
  bool isClimateOn = false;
  bool isTrunkOpen = false;
  bool isDoorsOpen = true;

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final size = MediaQuery.of(context).size;
    final double padding = 24.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- SCROLLABLE CONTENT (Title + Car + Controls) ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Header
                    const Text(
                      "Controls",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- CAR GRAPHIC SECTION ---
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Background Glow
                          Container(
                            width: size.width * 0.7,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00F0FF,
                                  ).withOpacity(0.15),
                                  blurRadius: 100,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          // 2. Car Image
                          // NOTE: Replace NetworkImage with Image.asset('assets/car_top_view.png')
                          // I am using a placeholder icon here for demonstration.
                          SizedBox(
                            height: 400,
                            width: size.width * 0.8,
                            child: Image.asset(
                              'assets/car_top_view.png', // Make sure this filename matches exactly what is in your folder
                              fit: BoxFit.contain,
                              //color: const Color(0xFF00F0FF),
                              //colorBlendMode: BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- CONTROLS GRID ---
                    // Row 1
                    Row(
                      children: [
                        Expanded(
                          child: ControlTile(
                            label: "Engine",
                            status: isEngineOn ? "started" : "off",
                            isOn: isEngineOn,
                            icon: Icons.power_settings_new,
                            onTap: () =>
                                setState(() => isEngineOn = !isEngineOn),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ControlTile(
                            label: "Climate",
                            status: isClimateOn ? "on" : "off",
                            isOn: isClimateOn,
                            icon: Icons.thermostat,
                            onTap: () =>
                                setState(() => isClimateOn = !isClimateOn),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Row 2
                    Row(
                      children: [
                        Expanded(
                          child: ControlTile(
                            label: "Trunk",
                            status: isTrunkOpen ? "opened" : "closed",
                            isOn: isTrunkOpen,
                            icon: Icons
                                .directions_car, // Use specific trunk icon if available
                            onTap: () =>
                                setState(() => isTrunkOpen = !isTrunkOpen),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ControlTile(
                            label: "Doors",
                            status: isDoorsOpen ? "opened" : "closed",
                            isOn: isDoorsOpen,
                            icon: Icons.lock_open,
                            onTap: () =>
                                setState(() => isDoorsOpen = !isDoorsOpen),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40), // Spacing at bottom
                  ],
                ),
              ),
            ),

            // --- BOTTOM NAVIGATION BAR ---
            // Fixed at bottom
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF030810).withOpacity(0.0),
                    const Color(0xFF030810),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(Icons.directions_car, true),
                  _buildNavItem(Icons.map_outlined, false),
                  _buildNavItem(Icons.person_outline, false),
                  _buildNavItem(Icons.menu, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      size: 28,
      color: isActive ? const Color(0xFF00F0FF) : Colors.grey.withOpacity(0.5),
    );
  }
}

// --- REUSABLE CONTROL BUTTON WIDGET ---
class ControlTile extends StatelessWidget {
  final String label;
  final String status;
  final bool isOn;
  final IconData icon;
  final VoidCallback onTap;

  const ControlTile({
    super.key,
    required this.label,
    required this.status,
    required this.isOn,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 110, // Fixed height for uniformity
        decoration: BoxDecoration(
          // Logic: Cyan if ON, Dark Grey if OFF
          color: isOn ? const Color(0xFF00F0FF) : const Color(0xFF1E2430),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Label and Toggle Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon (Optional - added for clarity since plain text can be boring)
                // If you want EXACTLY like image (no icon, just text), remove this Icon widget
                // and just keep the text.
                // However, the image shows a Switch widget.
                Text(
                  label,
                  style: TextStyle(
                    color: isOn ? Colors.black : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Custom Toggle Switch Visual
                Container(
                  width: 24,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isOn
                        ? Colors.black.withOpacity(0.1)
                        : Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOn
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        top: isOn ? 22 : 2, // Move circle up/down
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isOn ? Colors.black : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Row: Status Text
            Text(
              status,
              style: TextStyle(
                color: isOn ? Colors.black.withOpacity(0.7) : Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
