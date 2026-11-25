import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const PlayWaveApp());
}

class PlayWaveApp extends StatelessWidget {
  const PlayWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayWave',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1519),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
