import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:peatdashboard/screens/dashboard_screen.dart';
import 'package:peatdashboard/utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SFProDisplay',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.darkSurface,
          background: AppColors.darkSurface,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
        cardColor: AppColors.darkCardColor,
        useMaterial3: true,
        fontFamily: 'SFProDisplay',
      ),
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
    );
  }
}
