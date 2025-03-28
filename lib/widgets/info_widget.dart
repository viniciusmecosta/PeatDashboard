import 'package:flutter/material.dart';
import 'package:peatdashboard/utils/app_colors.dart';
import 'package:peatdashboard/screens/welcome_screen.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Container(
      width: isLargeScreen ? MediaQuery.of(context).size.width * 1 : double.infinity,
      height: isLargeScreen ? 90 : 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.infoWidgetGradientStart,
            AppColors.infoWidgetGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APRENDENDO A USAR O PEAT',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightBackgroundColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Siga as instruções para utilizar o comedouro da maneira correta.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            child: Row(
              children: [
                Image.asset('assets/comedouro_icon.png', width: 60, height: 75),
                const Icon(
                  Icons.arrow_circle_right_rounded,
                  color: AppColors.lightBackgroundColor,
                  size: 36,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}