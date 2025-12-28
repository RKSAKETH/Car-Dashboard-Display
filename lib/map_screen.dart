import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Scaffold(
      body: Stack(
        children: [
          // ================= MAP BACKGROUND (FIXED) =================
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/map_mock.png"), // ✅ FIXED
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ================= SEARCH BAR =================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 10),
                    Text(
                      "Search destination",
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= MAP ACTION BUTTONS =================
          Positioned(
            right: 16,
            top: 120,
            child: Column(
              children: const [
                _MapAction(icon: Icons.my_location),
                SizedBox(height: 12),
                _MapAction(icon: Icons.ev_station),
                SizedBox(height: 12),
                _MapAction(icon: Icons.traffic),
              ],
            ),
          ),

          // ================= BOTTOM INFO PANEL =================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _InfoTile(
                        icon: Icons.route,
                        title: "Distance",
                        value: "12.4 km",
                      ),
                      _InfoTile(
                        icon: Icons.timer,
                        title: "ETA",
                        value: "18 min",
                      ),
                      _InfoTile(
                        icon: Icons.battery_charging_full,
                        title: "Battery",
                        value: "62%",
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.navigation),
                      label: const Text("Navigate to Charger"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E4AFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= SOS BUTTON =================
          Positioned(
            bottom: 150,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {},
              child: const Icon(Icons.sos),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MAP ACTION BUTTON =================
class _MapAction extends StatelessWidget {
  final IconData icon;
  const _MapAction({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

// ================= INFO TILE =================
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF6E4AFF)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 10)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
