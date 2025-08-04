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
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
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
                                  fontSize: screenHeight * 0.036,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Text(
                                'O Peat conta com uma gama de tecnologias para garantir a automatização e qualidade do alimento para os animais.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.022,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                            fontSize: screenHeight * 0.021,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                        _buildSensorInfo(
                                          'Identificar a presença do animal',
                                          screenHeight,
                                        ),
                                        _buildSensorInfo(
                                          'Aferir temperatura',
                                          screenHeight,
                                        ),
                                        _buildSensorInfo(
                                          'Aferir umidade relativa do ar',
                                          screenHeight,
                                        ),
                                        _buildSensorInfo(
                                          'Aferir quantidade de ração',
                                          screenHeight,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                      'assets/PeatDeviceLight.png',
                                      height: screenHeight * 0.28,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildSensorInfo(String text, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.015),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: screenHeight * 0.02,
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
