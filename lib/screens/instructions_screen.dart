import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:peatdashboard/screens/dashboard_screen.dart';
import 'package:peatdashboard/screens/notification_form_screen.dart';

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

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 10,
                    child: Opacity(
                      opacity: 0.15,
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
                      opacity: 0.15,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Utilizando o Peat corretamente',
                                    style: TextStyle(
                                      color: highlightColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.038,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  _buildInstructionItem(
                                    icon: Icons.pets,
                                    title: 'Ração Seca para Felinos',
                                    descriptionWidget: Text(
                                      'O comedouro foi projetado para operar exclusivamente com ração seca para gatos. Não utilize sachês ou alimentos úmidos.',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: screenHeight * 0.02,
                                        height: 1.4,
                                      ),
                                    ),
                                    screenHeight: screenHeight,
                                  ),
                                  _buildInstructionItem(
                                    icon: Icons.autorenew,
                                    title: 'Como Reabastecer',
                                    descriptionWidget: Text(
                                      'Para reabastecer, utilize a tampa articulada na parte superior do dispositivo. Ela dá acesso direto ao silo de armazenamento de forma rápida e higiênica.',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: screenHeight * 0.02,
                                        height: 1.4,
                                      ),
                                    ),
                                    screenHeight: screenHeight,
                                  ),
                                  _buildInstructionItem(
                                    icon: Icons.timer_outlined,
                                    title: 'Alimentação Controlada',
                                    descriptionWidget: Text(
                                      'O PEAT libera porções controladas de ração (~15g) e possui um intervalo de 10 minutos entre as ativações para garantir o bem-estar animal.',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: screenHeight * 0.02,
                                        height: 1.4,
                                      ),
                                    ),
                                    screenHeight: screenHeight,
                                  ),
                                  _buildInstructionItem(
                                    icon: Icons.notifications_active_outlined,
                                    title: 'Alertas Automáticos',
                                    descriptionWidget: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: primaryTextColor,
                                          fontSize: screenHeight * 0.02,
                                          height: 1.4,
                                          fontFamily:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.fontFamily,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text:
                                                'O sistema envia alertas quando o silo atinge um nível crítico. Para ser notificado, ',
                                          ),
                                          TextSpan(
                                            text: 'cadastre-se aqui.',
                                            style: const TextStyle(
                                              color: highlightColor,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer:
                                                TapGestureRecognizer()
                                                  ..onTap = () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                const NotificationFormScreen(),
                                                      ),
                                                    );
                                                  },
                                          ),
                                        ],
                                      ),
                                    ),
                                    screenHeight: screenHeight,
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
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

  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required Widget descriptionWidget,
    required double screenHeight,
  }) {
    const Color highlightColor = Color(0xFFFFE8C7);

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.035),
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
                    fontSize: screenHeight * 0.024,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                descriptionWidget,
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
                IconButton(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
