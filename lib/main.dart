import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const TeslaSuperchargerApp());
}

class TeslaSuperchargerApp extends StatelessWidget {
  const TeslaSuperchargerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tesla Supercharger',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F4F8), // Soft grey/blue background
        primaryColor: const Color(0xFF1E2128),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section
              const HeaderSection(),
              const SizedBox(height: 25),

              // 2. Custom Icon Navigation Bar
              const CustomNavBar(),
              const SizedBox(height: 25),

              // 3. Main Info Cards (Horizontal Scroll for small screens)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    const InfoCard(
                      title: "CAR MODEL",
                      mainValue: "TESLA X3",
                      subValue: "S5 Series",
                      extra: "Next Model",
                      icon: Icons.directions_car_filled,
                      isPrimary: true,
                    ),
                    const SizedBox(width: 15),
                    InfoCard(
                      title: "ELECTRICITY (kWh)",
                      mainValue: "0.5 kWh",
                      subValue: "1 kWh",
                      extra: "Next Power",
                      customContent: Icon(Icons.electric_bolt, size: 40, color: Colors.blue[300]),
                    ),
                    const SizedBox(width: 15),
                    const InfoCard(
                      title: "CHARGING LEVEL",
                      mainValue: "LEVEL 3",
                      subValue: "Level 4",
                      extra: "Next Level",
                      customContent: Column(
                        children: [
                          SizedBox(height: 20),
                          LinearProgressIndicator(value: 0.7, color: Colors.cyanAccent),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 4. Payment Section
              const PaymentSection(),
              const SizedBox(height: 25),

              // 5. Dark Control Panel
              const ClimateControlPanel(),
              const SizedBox(height: 25),
              
              // 6. Map / Music Section (Stacked for mobile)
              const MapMusicSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Tesla Logo Placeholder
            Icon(Icons.change_history, size: 28, color: Colors.grey[800]),
            const SizedBox(width: 8),
            Text(
              "SUPER CHARGER",
              style: GoogleFonts.orbitron(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E2128),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Flag
            Container(width: 20, height: 14, color: Colors.indigo),
            Container(width: 20, height: 14, color: Colors.white),
            Container(width: 20, height: 14, color: Colors.red),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'), // Avatar
            ),
            const SizedBox(width: 10),
            const Text("26°", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 20),
          ],
        )
      ],
    );
  }
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(Icons.settings_outlined, false),
          _navIcon(Icons.link, false),
          _navIcon(Icons.location_on_outlined, false),
          _navIcon(Icons.power, true), // Active
          _navIcon(Icons.mic_none, false),
          _navIcon(Icons.wifi, false),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: isActive
          ? const BoxDecoration(
              color: Color(0xFF2C3038), // Dark active color
              shape: BoxShape.circle,
            )
          : null,
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey[400],
        size: 22,
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String mainValue;
  final String subValue;
  final String extra;
  final IconData? icon;
  final bool isPrimary;
  final Widget? customContent;

  const InfoCard({
    super.key,
    required this.title,
    required this.mainValue,
    required this.subValue,
    required this.extra,
    this.icon,
    this.isPrimary = false,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          Expanded(
            child: Center(
              child: customContent ??
                  Icon(icon, size: 50, color: Colors.blueGrey[800]),
            ),
          ),
          Text(
            mainValue,
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2128),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subValue,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            extra,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          _rowItem("Charging", "0.5 kWh"),
          const SizedBox(height: 8),
          _rowItem("Discount", "- %5"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Divider(color: Colors.black12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Text("€ 79.00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2128),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Text("VISA", style: GoogleFonts.rubik(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 20),
                const Text("Pay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 16),
                const SizedBox(width: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ClimateControlPanel extends StatelessWidget {
  const ClimateControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF23262F), // Dark panel
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ELECTRIC CAR", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16)),
              Row(
                children: [
                  const Icon(Icons.ac_unit, color: Colors.cyanAccent, size: 18),
                  const SizedBox(width: 5),
                  const Text("17°", style: TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          Text("HEY NICKY, WELCOME! Sun, 8:20pm", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          const SizedBox(height: 25),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _controlButton(Icons.air, false),
              _controlButton(Icons.ac_unit, true), // Active
              _controlButton(Icons.toys_outlined, false),
              _controlButton(Icons.airline_seat_recline_extra, false),
              _controlButton(Icons.person, false),
            ],
          )
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon, bool isActive) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.black : Colors.grey,
        size: 20,
      ),
    );
  }
}

class MapMusicSection extends StatelessWidget {
  const MapMusicSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Music Player Replica
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.music_note, color: Colors.amber),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Part of the Band", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("The 1975", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.skip_previous, size: 20),
              const SizedBox(width: 10),
              const Icon(Icons.play_arrow, size: 20),
              const SizedBox(width: 10),
              const Icon(Icons.skip_next, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 15),
        
        // Map Placeholder
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey[300],
            image: const DecorationImage(
              image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/ec/Map_of_New_York_City.png"), 
              fit: BoxFit.cover,
              opacity: 0.8,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    CircleAvatar(backgroundColor: const Color(0xFF23262F), child: Icon(Icons.search, color: Colors.grey[400])),
                    const SizedBox(height: 10),
                    const CircleAvatar(backgroundColor: Color(0xFF23262F), child: Icon(Icons.my_location, color: Colors.cyanAccent)),
                  ],
                ),
              ),
              const Center(
                child: Chip(
                  backgroundColor: Color(0xFF23262F),
                  label: Text("1h 20m Next Station", style: TextStyle(color: Colors.white)),
                  avatar: Icon(Icons.location_on, color: Colors.cyanAccent, size: 16),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}