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
          final bool isTallScreen = constraints.maxHeight > 700;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Stack(
                children: [
                  Positioned(
                    left: -constraints.maxWidth * 0.3,
                    top: constraints.maxHeight * 0.15,
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/gato_esquerda.png',
                        height: constraints.maxHeight * 0.4,
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
                                      fontSize: isTallScreen ? 38 : 34,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'O Peat foi projetado neste primeiro momento como um alimentador a base de ração para gatos, portanto:',
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: isTallScreen ? 20 : 18,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: isTallScreen ? 32 : 28,
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
                                  const SizedBox(height: 20),
                                  Text(
                                    'Apenas rações dos tipos secas podem ser utilizadas, descartando assim possibilidade de abastecimento com sachês a base de molhos ou outros derivados úmidos.',
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: isTallScreen ? 20 : 18,
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: isTallScreen ? 40 : 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Image(
                                        image: const AssetImage(
                                          'assets/gato_esquerda.png',
                                        ),
                                        height: constraints.maxHeight * 0.09,
                                      ),
                                      const SizedBox(width: 16),
                                      Image(
                                        image: const AssetImage(
                                          'assets/gato_direita.png',
                                        ),
                                        height: constraints.maxHeight * 0.18,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildBottomNavigation(context, pageIndex: 2),
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
                icon: const Icon(
                  Icons.arrow_circle_right_rounded,
                  color: Colors.white,
                  size: 70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
