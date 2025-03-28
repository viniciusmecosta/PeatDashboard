import 'package:flutter/material.dart';
import 'package:peatdashboard/screens/peat_work_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20B86F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF20B86F),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,  // Tamanho padronizado do ícone
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isLargeScreen = constraints.maxWidth > 900;
          final double imageSize = isLargeScreen ? 150 : 150;
          final double textSize = isLargeScreen ? 24 : 18;
          final double iconSize = isLargeScreen ? 70 : 55;
          final double indicatorSize = isLargeScreen ? 16 : 12;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 48 : 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Bem-vindo ao Peat!',
                      style: TextStyle(
                        fontSize: isLargeScreen ? 32 : 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/PeatDeviceLight.png',
                      width: imageSize,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                            (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: indicatorSize,
                          height: indicatorSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Alimentador inteligente e automatizado\npara pets: uma inovação que otimiza a\nforma como cuidamos dos animais.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Pular',
                              style: TextStyle(
                                fontSize: textSize,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HowPeatWorksScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.arrow_circle_right_rounded,
                              color: Colors.white,
                              size: iconSize,
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
        },
      ),
    );
  }
}
