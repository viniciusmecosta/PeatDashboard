import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:peatdashboard/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
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
          seedColor: const Color(0xFF298F5E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SFProDisplay',
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF298F5E),
          brightness: Brightness.dark,
          surface: const Color(0xFF09090B),
          background: const Color(0xFF09090B),
          primary: const Color(0xFF298F5E),
        ),
        scaffoldBackgroundColor: const Color(0xFF090909),
        cardColor: const Color(0xFF18181B),
        useMaterial3: true,
        fontFamily: 'SFProDisplay',
      ),
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
    );
  }
}
