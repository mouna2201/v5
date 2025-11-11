import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'irrigation_plan_screen.dart';

class FarmerFormScreen extends StatefulWidget {
  const FarmerFormScreen({super.key});

  @override
  State<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends State<FarmerFormScreen> {
  String soil = "Sableux";
  final TextEditingController location = TextEditingController();
  final TextEditingController crop = TextEditingController();
  final TextEditingController hectares = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018), // 🌑 fond sombre amélioré
      appBar: AppBar(
        title: const Text(
          "Détails de la parcelle",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1B5E20), // Vert foncé
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLabel("📍 Localisation"),
            const SizedBox(height: 5),
            _buildTextField(
              controller: location,
              label: "Ex: Bizerte, Tunisie",
            ),
            const SizedBox(height: 20),

            _buildLabel("🌾 Type de sol"),
            const SizedBox(height: 5),
            DropdownButtonFormField(
              value: soil,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: ["Sableux", "Argileux", "Calcaire", "Limoneux"]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => soil = v!),
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 20),

            _buildLabel("🌱 Types de cultures"),
            const SizedBox(height: 5),
            _buildTextField(
              controller: crop,
              label: "Ex: tomate, maïs, olive...",
            ),
            const SizedBox(height: 20),

            _buildLabel("📏 Superficie (hectares)"),
            const SizedBox(height: 5),
            _buildTextField(
              controller: hectares,
              label: "Ex: 2.5",
              type: TextInputType.number,
            ),
            const SizedBox(height: 30),

            CustomButton(
              text: "Générer le plan IA 🌱",
              onTap: () {
                if (location.text.isEmpty || crop.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Veuillez remplir tous les champs."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                final cropList = crop.text
                    .split(',')
                    .map((c) => c.trim())
                    .where((c) => c.isNotEmpty)
                    .toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IrrigationPlanScreen(
                      location: location.text,
                      soilType: soil,
                      cropTypes: cropList,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🌸 Label stylé
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.3,
      ),
    );
  }

  // 🧩 Champ de texte avec style unifié
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? type,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: _inputDecoration(hint: label),
    );
  }

  // 🎨 Style global des champs
  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white10,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.greenAccent, width: 1.5),
      ),
    );
  }
}
