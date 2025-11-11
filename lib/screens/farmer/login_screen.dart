import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../services/auth_service.dart';
import 'farmer_form_screen.dart';
import 'register_screen.dart';

class FarmerLoginScreen extends StatefulWidget {
  const FarmerLoginScreen({super.key});

  @override
  State<FarmerLoginScreen> createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  void _showSnackbar(String text, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), backgroundColor: error ? Colors.red : Colors.green));
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    final user = await AuthService.login(_email.text, _password.text);
    setState(() => _loading = false);
    if (user == null) {
      _showSnackbar('Email ou mot de passe incorrect', error: true);
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => FarmerFormScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Fermier')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe')),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : CustomButton(text: 'Se connecter', onTap: _login),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FarmerRegisterScreen())),
              child: const Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}
