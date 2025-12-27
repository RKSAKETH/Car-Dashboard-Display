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
      title: 'Mini Electric App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // Or 'Montserrat' if you add it to pubspec
        scaffoldBackgroundColor: const Color(0xFFE8EAEF), // Matches the grey bg
      ),
      home: const MiniElectricPage(),
    );
  }
}

class MiniElectricPage extends StatelessWidget {
  const MiniElectricPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EAEF),
      // Custom AppBar to match the minimal header
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            "MINI",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2),
          ),
        ),
        actions: [
          const Center(
              child: Text("Build",
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold))),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CAR IMAGE (Centerpiece)
              // On mobile, image looks best at the top or middle. 
              Center(
                child: SizedBox(
                  height: 350,
                  // REPLACING with a placeholder that mimics the top-down view
                  // In a real app, use: Image.asset('assets/car_top_view.png')
                  child: Image.network(
                    'https://pngimg.com/d/mini_cooper_PNG13.png', 
                    fit: BoxFit.contain,
                    errorBuilder: (c, o, s) => Container(
                      height: 200, color: Colors.grey[300], 
                      child: const Center(child: Text("Car Image Asset")),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. HEADER TEXT & TAGS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Electric Car",
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "MINI\nELECTRIC",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Iconic styling, fun-loving personality, a plethora of options for you to personalize your Mini with.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              
              // 3. PRICE
              RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  children: [
                    TextSpan(text: "From* "),
                    TextSpan(
                      text: "£ 29,000",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F5BFF), // The specific blue
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF2F5BFF).withOpacity(0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tune, size: 20),
                          SizedBox(width: 8),
                          Text("BUILD YOUR MINI", 
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.link, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 5. STATS GRID
              // Using GridView inside Column requires shrinkWrap: true
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.1, // Makes cards slightly square/tall
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildStatCard(Icons.speed, "200mph", "Top Speed", Colors.blueAccent),
                  _buildStatCard(Icons.directions_car, "4,561 lbs", "Weight", Colors.purpleAccent),
                  _buildStatCard(Icons.map_outlined, "396mi", "Range (EPA est.)", Colors.green),
                  _buildStatCard(Icons.timer, "1.99s", "0-60 mph", Colors.orangeAccent),
                ],
              ),

              const SizedBox(height: 16),

              // 6. VIDEO THUMBNAIL (Bottom Right in original, Bottom in Mobile)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    // Placeholder for car rear view
                    image: NetworkImage("https://images.unsplash.com/photo-1617788138017-80ad40651399?auto=format&fit=crop&q=80&w=1000"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
                      ]
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String subtitle, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5), // Neumorphic light grey
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                 BoxShadow(color: iconColor.withOpacity(0.2), blurRadius: 10),
              ]
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}