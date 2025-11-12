import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_button.dart';
import 'field_list_screen.dart';
import 'irrigation_plan_screen.dart';
import '../../presentation/providers/language_provider.dart';

class FarmerDashboardScreen extends ConsumerWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final currentLang = locale.languageCode;

    final welcomeText = {
      'fr': "Tableau de Bord Fermier 🌾",
      'en': "Farmer Dashboard 🌾",
      'ar': "لوحة تحكم الفلاح 🌾"
    }[currentLang]!;

    final fieldsText = {
      'fr': "📍 Mes Champs",
      'en': "📍 My Fields",
      'ar': "📍 مزارعي"
    }[currentLang]!;

    final irrigationText = {
      'fr': "💧 Plan d'Irrigation",
      'en': "💧 Irrigation Plan",
      'ar': "💧 خطة الري"
    }[currentLang]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0), // Vert bébé très clair
      appBar: AppBar(
        title: Text(welcomeText, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF90EE90), // Vert bébé
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF90EE90), const Color(0xFF98FB98)], // Vert bébé dégradé
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.agriculture,
                      size: 50, // Taille réduite pour mobile
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      welcomeText,
                      style: const TextStyle(
                        fontSize: 20, // Taille réduite pour mobile
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: fieldsText,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FieldListScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: irrigationText,
                outlined: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IrrigationPlanScreen(
                        location: "Ex: Bizerte, Tunisie",
                        soilType: "Sableux",
                        cropTypes: ["tomate", "maïs"],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                "© 2024 AgroPiquet",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
