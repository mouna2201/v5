import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'login_screen.dart'; // login_screen.dart dans le même dossier (entreprise)

class EnterpriseRoleScreen extends StatelessWidget {
  const EnterpriseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        title: const Text("Choisir votre rôle"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Accès à l'Entreprise Agricole",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // 🧑‍💼 Admin
            CustomButton(
              text: "Je suis Admin 🧑‍💼",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(role: "admin"),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 👨‍🌾 Superviseur
            CustomButton(
              text: "Je suis Superviseur 👨‍🌾",
              outlined: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(role: "superviseur"),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
