import 'package:flutter/material.dart';
import 'irrigation_plan_screen.dart';
import '../../widgets/custom_button.dart';

class FarmerFormScreen extends StatefulWidget {
  final Map<String, dynamic>? fieldData;
  final Function(Map<String, dynamic>)? onSave;

  const FarmerFormScreen({super.key, this.fieldData, this.onSave});

  @override
  State<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends State<FarmerFormScreen> {
  String soil = "Sableux";
  final TextEditingController location = TextEditingController();
  final TextEditingController crop = TextEditingController();
  final TextEditingController hectares = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.fieldData != null) {
      location.text = widget.fieldData!['location'] ?? '';
      crop.text = widget.fieldData!['crop'] ?? '';
      hectares.text = widget.fieldData!['hectares'] ?? '';
      soil = widget.fieldData!['soil'] ?? 'Sableux';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0), // Vert bébé très clair
      appBar: AppBar(
        title: const Text("Détails de la parcelle",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF90EE90), // Vert bébé
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildLabel("📍 Localisation"),
              const SizedBox(height: 5),
              _buildTextField(controller: location, label: "Ex: Bizerte, Tunisie"),
              const SizedBox(height: 20),
              _buildLabel("🌾 Type de sol"),
              const SizedBox(height: 5),
              DropdownButtonFormField(
                initialValue: soil,
                dropdownColor: const Color(0xFFF5FFF5),
                style: const TextStyle(color: Colors.black87),
                items: ["Sableux", "Argileux", "Calcaire", "Limoneux"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 16)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => soil = v!),
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),
              _buildLabel("🌱 Types de cultures"),
              const SizedBox(height: 5),
              _buildTextField(controller: crop, label: "Ex: tomate, maïs, olive..."),
              const SizedBox(height: 20),
              _buildLabel("📏 Superficie (hectares)"),
              const SizedBox(height: 5),
              _buildTextField(
                  controller: hectares, label: "Ex: 2.5", type: TextInputType.number),
              const SizedBox(height: 30),
              if (widget.onSave != null) ...[
                CustomButton(
                  text: "💾 Enregistrer le champ",
                  onTap: () {
                    if (location.text.isEmpty || crop.text.isEmpty || hectares.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Veuillez remplir tous les champs."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    final fieldData = {
                      'location': location.text,
                      'soil': soil,
                      'crop': crop.text,
                      'hectares': hectares.text,
                    };

                    widget.onSave!(fieldData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Champ enregistré avec succès!"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
              CustomButton(
                text: "Générer le plan IA 🌱",
                onTap: () {
                  if (location.text.isEmpty || crop.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Veuillez remplir tous les champs."),
                        behavior: SnackBarBehavior.floating,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16),
      );

  Widget _buildTextField(
          {required TextEditingController controller,
          required String label,
          TextInputType? type}) =>
      TextField(
        controller: controller,
        keyboardType: type,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: _inputDecoration(hint: label),
      );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFFF5FFF5), // Vert bébé très clair pour les champs
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF90EE90)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF90EE90), width: 2),
        ),
      );
}
