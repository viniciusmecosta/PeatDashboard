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
          final bool isTallScreen = constraints.maxHeight > 700;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Como o Alimentador Peat Funciona?',
                                style: TextStyle(
                                  color: highlightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTallScreen ? 32 : 28,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                'O Peat conta com uma gama de tecnologias para garantir a automatização e qualidade do alimento para os animais.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTallScreen ? 20 : 18,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ele é composto por uma série de sensores para:',
                                          style: TextStyle(
                                            color: highlightColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: isTallScreen ? 19 : 17,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        _buildSensorInfo(
                                          'Identificar a presença do animal',
                                        ),
                                        _buildSensorInfo('Aferir temperatura'),
                                        _buildSensorInfo(
                                          'Aferir umidade relativa do ar',
                                        ),
                                        _buildSensorInfo(
                                          'Aferir quantidade de ração',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                      'assets/PeatDeviceLight.png',
                                      height:
                                          constraints.maxHeight *
                                          (isTallScreen ? 0.35 : 0.3),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomNavigation(context, pageIndex: 1),
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

  Widget _buildSensorInfo(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(Icons.check_circle, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context, {
    required int pageIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                          builder: (context) => const InstructionsScreen(),
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
