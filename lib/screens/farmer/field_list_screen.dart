import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_button.dart';
import 'farmer_form_screen.dart';
import '../../presentation/providers/language_provider.dart';

class FieldListScreen extends ConsumerStatefulWidget {
  const FieldListScreen({super.key});

  @override
  ConsumerState<FieldListScreen> createState() => _FieldListScreenState();
}

class _FieldListScreenState extends ConsumerState<FieldListScreen> {
  List<Map<String, dynamic>> fields = [];

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final currentLang = locale.languageCode;

    final title = {
      'fr': "Mes Champs 🌾",
      'en': "My Fields 🌾", 
      'ar': "مزارعي 🌾"
    }[currentLang]!;

    final addFieldText = {
      'fr': "Ajouter un champ",
      'en': "Add Field",
      'ar': "إضافة حقل"
    }[currentLang]!;

    final noFieldsText = {
      'fr': "Aucun champ enregistré",
      'en': "No fields registered",
      'ar': "لا توجد حقول مسجلة"
    }[currentLang]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0), // Vert bébé très clair
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF90EE90), // Vert bébé
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: fields.isEmpty
            ? Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.agriculture,
                          size: 80,
                          color: const Color(0xFF90EE90), // Vert bébé
                        ),
                        const SizedBox(height: 20),
                        Text(
                          noFieldsText,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          text: addFieldText,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FarmerFormScreen(
                                  onSave: (newField) {
                                    setState(() {
                                      fields.add(newField);
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Champ ajouté avec succès!"),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: fields.length + 1,
                      itemBuilder: (context, index) {
                        if (index == fields.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: CustomButton(
                              text: addFieldText,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FarmerFormScreen(
                                      onSave: (newField) {
                                        setState(() {
                                          fields.add(newField);
                                        });
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Champ ajouté avec succès!"),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        final field = fields[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: const Color(0xFFF5FFF5), // Vert bébé très clair pour les cartes
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF90EE90), // Vert bébé
                              child: const Icon(Icons.eco, color: Colors.white),
                            ),
                            title: Text(
                              field['crop'] ?? 'Culture inconnue',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '📍 ${field['location'] ?? 'Location inconnue'}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                Text(
                                  '🌱 ${field['soil'] ?? 'Sol inconnu'}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                Text(
                                  '📏 ${field['hectares'] ?? '0'} hectares',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: const Color(0xFF90EE90), // Vert bébé
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FarmerFormScreen(
                                    fieldData: field,
                                    onSave: (updatedField) {
                                      setState(() {
                                        fields[index] = updatedField;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
