import 'package:flutter/material.dart';

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

    // We use a specific Theme for this screen to match the Neon/Dark look
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF030810),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF030810),
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
                            // Ensure you have this image in your assets folder
                            SizedBox(
                              height: 400,
                              width: size.width * 0.8,
                              child: Image.asset(
                                'assets/car_top_view.png', // Make sure this file exists!
                                fit: BoxFit.contain,
                                // Removed color tint so original image shows
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
                              icon: Icons.directions_car,
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
              // Note: I removed the custom bottom container here because
              // we are using the main app's real BottomNavigationBar now.
            ],
          ),
        ),
      ),
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
