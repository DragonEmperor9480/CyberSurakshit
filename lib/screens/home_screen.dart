import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_scanner_screen.dart';
import 'privacy_checker_screen.dart';
import 'network_security_screen.dart';
import 'phone_doctor_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _backgroundController;
  late Animation<double> _pulseAnimation;
  final List<ParticleModel> particles = [];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Initialize particles
    for (int i = 0; i < 50; i++) {
      particles.add(ParticleModel());
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: particles,
                  animation: _backgroundController.value,
                  isDark: false,
                ),
                size: Size.infinite,
              );
            },
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildSecurityStatus(),
                  _buildFeatureGrid(),
                  _buildSecurityTips(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                ).createShader(bounds),
                child: const Text(
                  'CYBER SURAKSHIT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your Digital Companion',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _rotationController,
            builder: (_, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue[200]!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shield,
                    color: Colors.blue[700],
                    size: 22,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityStatus() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Stack(
        children: [
          // Animated background for the card
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.blue[100]!,
                    width: 1,
                  ),
                ),
                child: CustomPaint(
                  painter: SecurityCardPainter(
                    animation: _backgroundController.value,
                  ),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Row(
                  children: [
                    // Animated shield icon
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.9 + (value * 0.1),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: value * 2,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _rotationController,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _rotationController.value * 2 * math.pi,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.green.withOpacity(0.2),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const Icon(
                                  Icons.security,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'System Protected',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.green[700]!,
                                Colors.green[400]!,
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'All security features are active',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Animated progress indicator
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 1),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Stack(
                      children: [
                        // Background progress
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: 1.0,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green.withOpacity(0.2),
                            ),
                            minHeight: 4,
                          ),
                        ),
                        // Animated progress overlay
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.95,
        children: [
          _buildFeatureCard(
            title: 'App Scanner',
            subtitle: 'Check installed apps',
            icon: Icons.app_settings_alt_rounded,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppScannerScreen()),
            ),
          ),
          _buildFeatureCard(
            title: 'Privacy Check',
            subtitle: 'Check permissions',
            icon: Icons.security_rounded,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyCheckerScreen()),
            ),
          ),
          _buildFeatureCard(
            title: 'Network Security',
            subtitle: 'Check connection',
            icon: Icons.wifi_protected_setup_rounded,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NetworkSecurityScreen()),
            ),
          ),
          _buildFeatureCard(
            title: 'Phone Doctor',
            subtitle: 'Check components',
            icon: Icons.phonelink_setup_rounded,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PhoneDoctorScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background animation
              Positioned.fill(
                child: CustomPaint(
                  painter: FeatureCardPainter(
                    color: color,
                    animation: _backgroundController.value,
                  ),
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: value * 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 28,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityTips() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SECURITY TIPS',
            style: TextStyle(
              color: Color(0xFF2D3142),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tips_and_updates,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Security Tip',
                        style: TextStyle(
                          color: Color(0xFF2D3142),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Regularly check app permissions to maintain privacy',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ParticleModel {
  double x = math.Random().nextDouble() * 1.0;
  double y = math.Random().nextDouble() * 1.0;
  double speed = math.Random().nextDouble() * 0.2 + 0.1;
  double theta = math.Random().nextDouble() * 2 * math.pi;

  void move() {
    x += math.cos(theta) * speed * 0.01;
    y += math.sin(theta) * speed * 0.01;

    if (x < 0 || x > 1) {
      theta = math.pi - theta;
    }
    if (y < 0 || y > 1) {
      theta = -theta;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;
  final double animation;
  final bool isDark;

  ParticlePainter({
    required this.particles,
    required this.animation,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[100]!.withOpacity(0.3)
      ..strokeWidth = 1.0;

    for (var particle in particles) {
      particle.move();
      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      // Draw particle with subtle shadow
      canvas.drawCircle(
        position,
        2,
        Paint()
          ..color = Colors.blue[300]!.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );

      // Draw connections with gradient
      for (var other in particles) {
        final distance = (particle.x - other.x).abs() + (particle.y - other.y).abs();
        if (distance < 0.15) {
          final gradient = LinearGradient(
            colors: [
              Colors.blue[200]!.withOpacity(0.1),
              Colors.blue[100]!.withOpacity(0.05),
            ],
          );

          canvas.drawLine(
            position,
            Offset(other.x * size.width, other.y * size.height),
            Paint()
              ..shader = gradient.createShader(Rect.fromPoints(
                position,
                Offset(other.x * size.width, other.y * size.height),
              ))
              ..strokeWidth = 1,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class SecurityCardPainter extends CustomPainter {
  final double animation;

  SecurityCardPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw hexagon grid
    final gridPaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final hexSize = size.width / 8;
    for (double i = 0; i < size.width; i += hexSize) {
      for (double j = 0; j < size.height; j += hexSize) {
        final path = Path();
        for (var k = 0; k < 6; k++) {
          final angle = (k * 60 + animation * 360) * math.pi / 180;
          final x = i + hexSize / 2 + math.cos(angle) * hexSize / 3;
          final y = j + hexSize / 2 + math.sin(angle) * hexSize / 3;
          k == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
        }
        path.close();
        gridPaint.color = Colors.blue[100]!.withOpacity(0.1);
        canvas.drawPath(path, gridPaint);
      }
    }

    // Draw scanning line
    final scanHeight = size.height * 0.1; // Height of the scanning effect
    final scanY = (animation * (size.height + scanHeight)) - scanHeight;

    // Create gradient for scanning effect
    final scanGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue[300]!.withOpacity(0.0),
        Colors.blue[300]!.withOpacity(0.2),
        Colors.blue[300]!.withOpacity(0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    // Draw scanning line with gradient
    final scanRect = Rect.fromLTWH(0, scanY, size.width, scanHeight);
    final scanPaint = Paint()
      ..shader = scanGradient.createShader(scanRect);
    canvas.drawRect(scanRect, scanPaint);

    // Draw scan lines
    final linePaint = Paint()
      ..color = Colors.blue[200]!.withOpacity(0.3)
      ..strokeWidth = 1;

    final lineCount = 5;
    final lineSpacing = size.width / (lineCount - 1);
    for (var i = 0; i < lineCount; i++) {
      final x = i * lineSpacing;
      final startY = scanY;
      final endY = scanY + scanHeight;
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        linePaint,
      );
    }

    // Draw edge glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue[300]!.withOpacity(0.2),
          Colors.blue[300]!.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, scanY, size.width, scanHeight));

    canvas.drawRect(
      Rect.fromLTWH(0, scanY - 5, size.width, scanHeight + 10),
      glowPaint,
    );

    // Draw data points
    final random = math.Random(animation.toInt() * 1000);
    final pointPaint = Paint()
      ..color = Colors.blue[400]!.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 10; i++) {
      final x = random.nextDouble() * size.width;
      final y = scanY + random.nextDouble() * scanHeight;
      canvas.drawCircle(Offset(x, y), 1.5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(SecurityCardPainter oldDelegate) => true;
}

// Update the FeatureCardPainter for a more subtle animation
class FeatureCardPainter extends CustomPainter {
  final Color color;
  final double animation;

  FeatureCardPainter({
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw subtle corner accents
    final cornerSize = size.width * 0.2;
    
    // Top left corner
    canvas.drawLine(
      Offset(0, cornerSize),
      Offset(0, 0),
      paint,
    );
    canvas.drawLine(
      Offset(0, 0),
      Offset(cornerSize, 0),
      paint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(size.width - cornerSize, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerSize),
      paint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(0, size.height - cornerSize),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerSize, size.height),
      paint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(size.width - cornerSize, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerSize),
      Offset(size.width, size.height),
      paint,
    );

    // Draw animated accent
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.1),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final accentPath = Path()
      ..moveTo(0, size.height * animation)
      ..lineTo(size.width * animation, 0);

    canvas.drawPath(accentPath, gradientPaint..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(FeatureCardPainter oldDelegate) => true;
}