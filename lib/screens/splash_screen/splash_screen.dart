import 'package:flutter/material.dart';
import 'package:taskify/service/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    goto();
  }

  Future<void> goto() async {
    await Future.delayed(const Duration(seconds: 3));
    await _authService.checkLogedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Taskify.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}