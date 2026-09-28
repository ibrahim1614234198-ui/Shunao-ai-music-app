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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF080808),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
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
  String result = '';

  Future<void> generateSong() async {
    final prompt = promptController.text.trim();

    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('আগে গানের description লিখুন'),
        ),
      );
      return;
    }

    setState(() {
      generating = true;
      result = '';
    });

    try {
      final response = await api.generateSong(prompt);

      if (!mounted) return;

      setState(() {
        result = response;
        generating = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        generating = false;
        result = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Shunao AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
