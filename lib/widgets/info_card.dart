import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Container(
      width: isLargeScreen ? MediaQuery.of(context).size.width * 1 : double.infinity, // Responsivo
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7CDBAD), Color(0xFF20B86F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center
        children: [
          // Column with text
          Expanded(
            child: Column(
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
          // No space between text and image
          Image.asset(
            'assets/comedouro_icon.png',
            width: 80, // Adjust the width for better alignment
            height: 80, // Adjust the height for better alignment
          ),
          const SizedBox(width: 16), // Space between the image and the icon
          // Increased size of the icon button
          IconButton(
            onPressed: () {
              // Action when clicked
            },
            icon: const Icon(
              Icons.arrow_circle_right_rounded,
              color: Colors.white,
              size: 40, // Increased size of the icon button
            ),
          ),
        ],
      ),
    );
  }
}
