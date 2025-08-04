import 'package:flutter/material.dart';
import 'package:peatdashboard/screens/dashboard_screen.dart';
import 'package:peatdashboard/screens/peat_work_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF20B86F);
    const Color highlightColor = Color(0xFFFFE8C7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;

          return Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 10,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/gato_esquerda.png',
                    height: screenHeight * 0.18,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/gato_direita.png',
                    height: screenHeight * 0.22,
                  ),
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                      child: Column(
                        children: [
                          Text(
                            'Bem-vindo ao Peat!',
                            style: TextStyle(
                              fontSize: screenHeight * 0.045,
                              fontWeight: FontWeight.bold,
                              color: highlightColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(flex: 1),
                          Image.asset(
                            'assets/PeatDeviceLight.png',
                            height: screenHeight * 0.32,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Uma solução tecnológica para o cuidado de gatos em situação de abandono, unindo bem-estar animal e saúde pública.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenHeight * 0.022,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          _buildFeatureHighlight(
                            icon: Icons.pets_outlined,
                            text: 'Alimentação automatizada e controlada',
                            screenHeight: screenHeight,
                            highlightColor: highlightColor,
                          ),
                          _buildFeatureHighlight(
                            icon: Icons.health_and_safety_outlined,
                            text: 'Controle de qualidade da ração',
                            screenHeight: screenHeight,
                            highlightColor: highlightColor,
                          ),
                          _buildFeatureHighlight(
                            icon: Icons.cloud_sync_outlined,
                            text: 'Monitoramento remoto e colaborativo',
                            screenHeight: screenHeight,
                            highlightColor: highlightColor,
                          ),
                          const Spacer(flex: 2),
                          _buildBottomNavigation(
                            context,
                            pageIndex: 0,
                            screenHeight: screenHeight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureHighlight({
    required IconData icon,
    required String text,
    required double screenHeight,
    required Color highlightColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: highlightColor, size: 22),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenHeight * 0.02,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context, {
    required int pageIndex,
    required double screenHeight,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      index <= pageIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          SizedBox(
            height: screenHeight * 0.08,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      'Pular',
                      style: TextStyle(
                        fontSize: screenHeight * 0.021,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PeatWorksScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_circle_right_rounded,
                    color: Colors.white,
                    size: screenHeight * 0.08,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
