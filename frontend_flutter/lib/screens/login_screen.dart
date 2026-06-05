import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usuarioCtrl = TextEditingController(text: 'admin');
  final passCtrl = TextEditingController(text: '123456');
  final api = ApiService();
  bool loading = false;

  Future<void> ingresar() async {
    setState(() => loading = true);

    try {
      final ok = await api.login(usuarioCtrl.text, passCtrl.text);

      if (!mounted) return;

      if (ok) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance, size: 70, color: Colors.blue),
                  const SizedBox(height: 10),
                  const Text(
                    'Control de Obras Municipales',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: usuarioCtrl,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                  ),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: loading ? null : ingresar,
                      child: Text(loading ? 'Ingresando...' : 'Ingresar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}