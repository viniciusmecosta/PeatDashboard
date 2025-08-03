import 'package:flutter/material.dart';
import 'package:peatdashboard/screens/dashboard_screen.dart';
import 'package:peatdashboard/screens/peat_work_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF20B86F);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isTallScreen = constraints.maxHeight > 700;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        'Bem-vindo ao Peat!',
                        style: TextStyle(
                          fontSize: isTallScreen ? 36 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/PeatDeviceLight.png',
                        height:
                            constraints.maxHeight * (isTallScreen ? 0.35 : 0.3),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Alimentador inteligente e automatizado para pets: uma inovação que otimiza a forma como cuidamos dos animais.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTallScreen ? 20 : 18,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(flex: 2),
                      _buildBottomNavigation(context, pageIndex: 0),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context, {
    required int pageIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 12,
                height: 12,
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
          const SizedBox(height: 40),
          SizedBox(
            height: 70,
            child: Stack(
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
                    child: const Text(
                      'Pular',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PeatWorksScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_circle_right_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
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
