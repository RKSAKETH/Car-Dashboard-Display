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

  // New state variable for Theme Mode
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final size = MediaQuery.of(context).size;
    final double padding = 24.0;

    // Define colors based on mode
    final Color backgroundColor = isDarkMode ? const Color(0xFF030810) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color tileInactiveColor = isDarkMode ? const Color(0xFF1E2430) : Colors.grey.shade200;

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: backgroundColor,
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
                      // Header with Theme Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Controls",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          // Theme Toggle Button
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isDarkMode = !isDarkMode;
                              });
                            },
                            icon: Icon(
                              isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              color: textColor,
                            ),
                          ),
                        ],
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
                                    color: const Color(0xFF00F0FF).withOpacity(0.15),
                                    blurRadius: 100,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            // 2. Car Image
                            SizedBox(
                              height: 400,
                              width: size.width * 0.8,
                              child: Image.asset(
                                'assets/car_top_view.png',
                                fit: BoxFit.contain,
                                // Add logic to invert color if the image is a silhouette,
                                // remove color param if it's a real photo.
                                // color: isDarkMode ? null : Colors.black, 
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
                              inactiveColor: tileInactiveColor,
                              textColor: textColor,
                              icon: Icons.power_settings_new,
                              onTap: () => setState(() => isEngineOn = !isEngineOn),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ControlTile(
                              label: "Climate",
                              status: isClimateOn ? "on" : "off",
                              isOn: isClimateOn,
                              inactiveColor: tileInactiveColor,
                              textColor: textColor,
                              icon: Icons.thermostat,
                              onTap: () => setState(() => isClimateOn = !isClimateOn),
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
                              inactiveColor: tileInactiveColor,
                              textColor: textColor,
                              icon: Icons.directions_car,
                              onTap: () => setState(() => isTrunkOpen = !isTrunkOpen),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ControlTile(
                              label: "Doors",
                              status: isDoorsOpen ? "opened" : "closed",
                              isOn: isDoorsOpen,
                              inactiveColor: tileInactiveColor,
                              textColor: textColor,
                              icon: Icons.lock_open,
                              onTap: () => setState(() => isDoorsOpen = !isDoorsOpen),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
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
  final Color inactiveColor;
  final Color textColor;
  final VoidCallback onTap;

  const ControlTile({
    super.key,
    required this.label,
    required this.status,
    required this.isOn,
    required this.icon,
    required this.inactiveColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        height: 110,
        decoration: BoxDecoration(
          // Cyan if ON, Dynamic Inactive Color if OFF
          color: isOn ? const Color(0xFF00F0FF) : inactiveColor,
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
                    // If ON, text is black. If OFF, text adapts to theme.
                    color: isOn ? Colors.black : textColor,
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
                        : Colors.black.withOpacity(0.1), // Adjusted for visibility
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOn
                          ? Colors.black.withOpacity(0.2)
                          : textColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        top: isOn ? 22 : 2,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            // Circle color logic
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