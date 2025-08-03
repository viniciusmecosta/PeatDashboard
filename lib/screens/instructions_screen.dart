import 'package:flutter/material.dart';
import 'package:peatdashboard/screens/dashboard_screen.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFFFE8C7);
    const Color backgroundColor = Color(0xFF20B86F);
    const Color primaryTextColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: primaryTextColor, size: 30),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final double screenWidth = constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Stack(
                children: [
                  Positioned(
                    left: -screenWidth * 0.3,
                    top: screenHeight * 0.15,
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/gato_esquerda.png',
                        height: screenHeight * 0.35,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Instruções para utilizar o Peat corretamente',
                                    style: TextStyle(
                                      color: highlightColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.038,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  Text(
                                    'O Peat foi projetado neste primeiro momento como um alimentador a base de ração para gatos, portanto:',
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: screenHeight * 0.022,
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: screenHeight * 0.032,
                                        height: 1.4,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Só deve ser reabastecido com ',
                                        ),
                                        TextSpan(
                                          text: 'ração',
                                          style: TextStyle(
                                            color: highlightColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(text: ', e para '),
                                        TextSpan(
                                          text: 'felinos!',
                                          style: TextStyle(
                                            color: highlightColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text(
                                    'Apenas rações dos tipos secas podem ser utilizadas, descartando assim possibilidade de abastecimento com sachês a base de molhos ou outros derivados úmidos.',
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: screenHeight * 0.022,
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Image(
                                        image: const AssetImage(
                                          'assets/gato_esquerda.png',
                                        ),
                                        height: screenHeight * 0.08,
                                      ),
                                      const SizedBox(width: 16),
                                      Image(
                                        image: const AssetImage(
                                          'assets/gato_direita.png',
                                        ),
                                        height: screenHeight * 0.16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildBottomNavigation(
                            context,
                            pageIndex: 2,
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

  Widget _buildBottomNavigation(
    BuildContext context, {
    required int pageIndex,
    required double screenHeight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(
                  Icons.arrow_circle_right_rounded,
                  color: Colors.white,
                  size: screenHeight * 0.08,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
