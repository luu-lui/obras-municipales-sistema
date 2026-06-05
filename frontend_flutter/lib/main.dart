import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ObrasApp());
}

class ObrasApp extends StatelessWidget {
  const ObrasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obras Municipales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: LoginScreen(),
    );
  }
}