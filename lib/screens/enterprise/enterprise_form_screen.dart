import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class EnterpriseFormScreen extends StatelessWidget {
  const EnterpriseFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController locationController = TextEditingController();
    TextEditingController soilController = TextEditingController();
    TextEditingController cropController = TextEditingController();
    TextEditingController hectaresController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Formulaire Fermier Entreprise")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: locationController, decoration: const InputDecoration(labelText: "Localisation")),
            const SizedBox(height: 15),
            TextField(controller: soilController, decoration: const InputDecoration(labelText: "Type de sol")),
            const SizedBox(height: 15),
            TextField(controller: cropController, decoration: const InputDecoration(labelText: "Type de culture / plante")),
            const SizedBox(height: 15),
            TextField(controller: hectaresController, decoration: const InputDecoration(labelText: "Nombre d'hectares")),
            const SizedBox(height: 25),
            CustomButton(
              text: "Générer calendrier d'arrosage",
              onTap: () {
                // Ici tu appelleras ton IA ou API météo pour le calendrier
              },
            ),
          ],
        ),
      ),
    );
  }
}
