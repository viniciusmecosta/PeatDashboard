import 'package:flutter/material.dart';
import 'package:peatdashboard/screens/dashboard_screen.dart';
import 'package:peatdashboard/screens/instructions_screen.dart';

class PeatWorksScreen extends StatelessWidget {
  const PeatWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFFFE8C7);
    const Color backgroundColor = Color(0xFF20B86F);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Stack(
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Como o Peat Funciona?',
                                    style: TextStyle(
                                      color: highlightColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.038,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text(
                                    'O PEAT integra hardware e software para criar um ecossistema de cuidado animal.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenHeight * 0.022,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  Image.asset(
                                    'assets/PeatDeviceLight.png',
                                    height: screenHeight * 0.22,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  _buildComponentInfo(
                                    icon: Icons.memory,
                                    title: 'Microcontrolador ESP32',
                                    subtitle:
                                        'O cérebro do sistema, que gerencia os sensores e a conectividade Wi-Fi.',
                                    screenHeight: screenHeight,
                                  ),
                                  _buildComponentInfo(
                                    icon: Icons.sensors,
                                    title: 'Sensores de Monitoramento',
                                    subtitle:
                                        'Sensores de proximidade (SR501), ultrassônico (SR04) e de temperatura e umidade (DHT11).',
                                    screenHeight: screenHeight,
                                  ),
                                  _buildComponentInfo(
                                    icon:
                                        Icons.precision_manufacturing_outlined,
                                    title: 'Atuadores Inteligentes',
                                    subtitle:
                                        'Servomotor para liberação precisa do alimento e um sistema de controle de temperatura.',
                                    screenHeight: screenHeight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildBottomNavigation(
                            context,
                            pageIndex: 1,
                            screenHeight: screenHeight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildComponentInfo({
    required IconData icon,
    required String title,
    required String subtitle,
    required double screenHeight,
  }) {
    const Color highlightColor = Color(0xFFFFE8C7);

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: highlightColor, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: highlightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.022,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.019,
                    height: 1.3,
                  ),
                ),
              ],
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
                        builder: (context) => const InstructionsScreen(),
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
