import 'package:flutter/material.dart';

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
      body: Stack(
        children: [
          Positioned(
            left: -120,
            top: MediaQuery.of(context).size.height * 0.2,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/gato_direita.png',
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Instruções para utilizar o Peat corretamente',
                    style: TextStyle(
                      color: highlightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'O Peat foi projetado neste primeiro momento como um alimentador a base de ração para gatos, portanto:',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 28,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'só deve ser reabastecido com '),
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
                  const Text(
                    'Apenas rações dos tipos secas podem ser utilizadas, descartando assim possibilidade de abastecimento com sachês a base de molhos ou outros derivados úmidos.',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage('assets/gato_esquerda.png'),
                        width: 100,
                      ),
                      SizedBox(width: 16),
                      Image(
                        image: AssetImage('assets/gato_direita.png'),
                        width: 150,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildBottomNavigation(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              6,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      index <= 5 ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_circle_right_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
