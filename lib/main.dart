import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const GhostTalkApp());
}

class GhostTalkApp extends StatelessWidget {
  const GhostTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GhostTalk',
      theme: ThemeData.dark(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
