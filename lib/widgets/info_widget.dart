import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Container(
      width: isLargeScreen ? MediaQuery.of(context).size.width * 1 : double.infinity,
      height: isLargeScreen ? 120 : 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7CDBAD), Color(0xFF20B86F)],
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Siga as instruções para utilizar o comedouro da maneira correta.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Image.asset('assets/comedouro_icon.png', width: 60, height: 75),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_circle_right_rounded, color: Colors.white, size: 36),
              ),
            ],
          ),
        ],
      ),
    );
  }
}