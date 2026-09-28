import 'package:flutter/material.dart';
import 'services/api.dart';

void main() {
  runApp(const ShunaoApp());
}

class ShunaoApp extends StatelessWidget {
  const ShunaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shunao AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController promptController = TextEditingController();
  final Api api = Api();

  bool generating = false;

  Future<void> generateSong() async {
    if (promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('আগে একটি song description লিখুন'),
        ),
      );
      return;
    }

    setState(() {
      generating = true;
    });

    try {
      final result = await api.generateSong(
        promptController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    } catch (e) {
      if (!mounted) return;
