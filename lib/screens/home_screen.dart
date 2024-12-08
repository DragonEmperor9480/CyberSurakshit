import 'package:flutter/material.dart';
import 'package:cyber_surakshit/screens/app_scanner_screen.dart';
import 'package:cyber_surakshit/widgets/scanning_animation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                const ScanningAnimation(
                  size: 200,
                  color: Color(0xFF6C63FF),
                ),
                const SizedBox(height: 30),
                _buildSecurityTools(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'CyberSurakshit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Your Digital Guardian',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: const Icon(Icons.security, color: Color(0xFF6C63FF)),
        ),
      ],
    );
  }

  Widget _buildSecurityTools(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2;
    
    final tools = [
      {
        'icon': Icons.app_settings_alt,
        'title': 'App Scanner',
        'subtitle': 'Scan installed apps',
        'color': const Color(0xFF6C63FF),
      },
      {
        'icon': Icons.folder_open,
        'title': 'Files Scanner',
        'subtitle': 'Scan files & docs',
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': Icons.security_update_warning,
        'title': 'Malware Scanner',
        'subtitle': 'Detect threats',
        'color': const Color(0xFFE53935),
      },
      {
        'icon': Icons.privacy_tip,
        'title': 'Privacy Check',
        'subtitle': 'Check permissions',
        'color': const Color(0xFFFFA726),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            return _buildToolCard(
              icon: tools[index]['icon'] as IconData,
              title: tools[index]['title'] as String,
              subtitle: tools[index]['subtitle'] as String,
              color: tools[index]['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Builder(
      builder: (BuildContext context) => InkWell(
        onTap: () {
          if (title == 'App Scanner') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppScannerScreen(),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 