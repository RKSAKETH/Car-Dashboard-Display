import 'package:flutter/material.dart';
import 'dart:math';

class ControlsScreen extends StatefulWidget {
  const ControlsScreen({super.key});

  @override
  State<ControlsScreen> createState() => _ControlsScreenState();
}

class _ControlsScreenState extends State<ControlsScreen> with SingleTickerProviderStateMixin {
  bool isEngineOn = true;
  bool isClimateOn = false;
  bool isTrunkOpen = false;
  bool isDoorsOpen = true;
  bool isDarkMode = true;
  bool showRain = false;

  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    setState(() => showRain = true);
    // Simulate logout after rain effect
    Future.delayed(const Duration(seconds: 5), () {
      // Add your actual logout logic here
      setState(() => showRain = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Color backgroundColor = isDarkMode ? const Color(0xFF030810) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color tileInactiveColor = isDarkMode ? const Color(0xFF1E2430) : Colors.grey.shade200;

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Controls", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() => isDarkMode = !isDarkMode),
                                    icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: textColor),
                                  ),
                                  IconButton(
                                    onPressed: _handleLogout,
                                    icon: Icon(Icons.logout, color: textColor),
                                    tooltip: 'Logout',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _glowController,
                                  builder: (context, child) {
                                    return Container(
                                      width: size.width * 0.7,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF00F0FF).withOpacity(isEngineOn ? (0.1 + (_glowController.value * 0.15)) : 0.05),
                                            blurRadius: isEngineOn ? 100 + (_glowController.value * 40) : 60,
                                            spreadRadius: isEngineOn ? 10 + (_glowController.value * 10) : 5,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                AnimatedScale(
                                  scale: isEngineOn ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.elasticOut,
                                  child: AnimatedOpacity(
                                    opacity: isDoorsOpen ? 0.8 : 1.0,
                                    duration: const Duration(milliseconds: 500),
                                    child: SizedBox(
                                      height: 400,
                                      width: size.width * 0.8,
                                      child: Image.asset(
                                        'assets/car_top_view.png',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, e, s) => Icon(Icons.directions_car, size: 200, color: textColor.withOpacity(0.2)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ControlTile(
                                  label: "Engine", status: isEngineOn ? "started" : "off", isOn: isEngineOn,
                                  inactiveColor: tileInactiveColor, textColor: textColor, icon: Icons.power_settings_new,
                                  onTap: () => setState(() => isEngineOn = !isEngineOn),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ControlTile(
                                  label: "Climate", status: isClimateOn ? "on" : "off", isOn: isClimateOn,
                                  inactiveColor: tileInactiveColor, textColor: textColor, icon: Icons.thermostat,
                                  onTap: () => setState(() => isClimateOn = !isClimateOn),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ControlTile(
                                  label: "Trunk", status: isTrunkOpen ? "opened" : "closed", isOn: isTrunkOpen,
                                  inactiveColor: tileInactiveColor, textColor: textColor, icon: Icons.directions_car,
                                  onTap: () => setState(() => isTrunkOpen = !isTrunkOpen),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ControlTile(
                                  label: "Doors", status: isDoorsOpen ? "opened" : "closed", isOn: isDoorsOpen,
                                  inactiveColor: tileInactiveColor, textColor: textColor, icon: Icons.lock_open,
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
            if (showRain) RainEffect(),
          ],
        ),
      ),
    );
  }
}

class ControlTile extends StatefulWidget {
  final String label, status;
  final bool isOn;
  final IconData icon;
  final Color inactiveColor, textColor;
  final VoidCallback onTap;

  const ControlTile({super.key, required this.label, required this.status, required this.isOn, required this.icon, required this.inactiveColor, required this.textColor, required this.onTap});

  @override
  State<ControlTile> createState() => _ControlTileState();
}

class _ControlTileState extends State<ControlTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF00F0FF);
    final Color glowColor = widget.isOn ? activeColor : widget.textColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            height: 110,
            decoration: BoxDecoration(
              color: widget.isOn ? activeColor : widget.inactiveColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered ? glowColor.withOpacity(0.8) : Colors.transparent,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(_isHovered ? 0.4 : 0.0),
                  blurRadius: 20,
                  spreadRadius: _isHovered ? 4 : 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.label, style: TextStyle(color: widget.isOn ? Colors.black : widget.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    _buildSwitch(),
                  ],
                ),
                Text(widget.status, style: TextStyle(color: widget.isOn ? Colors.black.withOpacity(0.7) : Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    return Container(
      width: 24, height: 44,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.isOn ? Colors.black.withOpacity(0.2) : widget.textColor.withOpacity(0.2)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: widget.isOn ? 22 : 2,
            child: Container(width: 18, height: 18, decoration: BoxDecoration(color: widget.isOn ? Colors.black : Colors.grey, shape: BoxShape.circle)),
          ),
        ],
      ),
    );
  }
}

// Rain Effect Widget
class RainEffect extends StatefulWidget {
  const RainEffect({super.key});

  @override
  State<RainEffect> createState() => _RainEffectState();
}

class _RainEffectState extends State<RainEffect> with TickerProviderStateMixin {
  late AnimationController _rainController;
  late AnimationController _lightningController;
  final List<Raindrop> _raindrops = [];
  final Random _random = Random();
  bool _showLightning = false;

  @override
  void initState() {
    super.initState();
    
    // Rain animation controller
    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();

    // Lightning animation controller
    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Initialize raindrops
    _initializeRain();

    // Trigger lightning periodically
    _triggerLightningPeriodically();
  }

  void _initializeRain() {
    final size = MediaQuery.of(context).size;
    for (int i = 0; i < 150; i++) {
      _raindrops.add(Raindrop(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        speed: 5 + _random.nextDouble() * 10,
        length: 15 + _random.nextDouble() * 25,
        opacity: 0.3 + _random.nextDouble() * 0.4,
      ));
    }
  }

  void _triggerLightningPeriodically() {
    Future.delayed(Duration(milliseconds: 1500 + _random.nextInt(2000)), () {
      if (mounted) {
        setState(() => _showLightning = true);
        _lightningController.forward(from: 0).then((_) {
          if (mounted) {
            setState(() => _showLightning = false);
            _triggerLightningPeriodically();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _rainController.dispose();
    _lightningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Dark overlay
        AnimatedOpacity(
          opacity: 0.7,
          duration: const Duration(milliseconds: 500),
          child: Container(
            color: Colors.black,
          ),
        ),
        
        // Lightning flash
        if (_showLightning)
          AnimatedBuilder(
            animation: _lightningController,
            builder: (context, child) {
              return Opacity(
                opacity: (1 - _lightningController.value) * 0.6,
                child: Container(
                  color: Colors.white,
                ),
              );
            },
          ),

        // Rain
        AnimatedBuilder(
          animation: _rainController,
          builder: (context, child) {
            // Update raindrop positions
            for (var drop in _raindrops) {
              drop.y += drop.speed;
              if (drop.y > size.height) {
                drop.y = -drop.length;
                drop.x = _random.nextDouble() * size.width;
              }
            }

            return CustomPaint(
              painter: RainPainter(_raindrops),
              size: Size(size.width, size.height),
            );
          },
        ),

        // Sad message
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied,
                size: 80,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 20),
              Text(
                "We're sad to see you go...",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Come back soon! 🌧️",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Raindrop {
  double x;
  double y;
  double speed;
  double length;
  double opacity;

  Raindrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.opacity,
  });
}

class RainPainter extends CustomPainter {
  final List<Raindrop> raindrops;

  RainPainter(this.raindrops);

  @override
  void paint(Canvas canvas, Size size) {
    for (var drop in raindrops) {
      final paint = Paint()
        ..color = Colors.lightBlueAccent.withOpacity(drop.opacity)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(drop.x, drop.y + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}