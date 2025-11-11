// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:riverpod/src/framework.dart';

import 'theme/app_theme.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/providers/sensor_provider.dart';
import 'services/mqtt_service.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/farmer/farmer_dashboard_screen.dart';

/// Point d'entrée de l'application
void main() {
  runApp(
    const ProviderScope(
      child: AgroApp(),
    ),
  );
}

class AgroApp extends ConsumerWidget {
  const AgroApp({super.key});

  ProviderListenable get mqttServiceProvider => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    // Démarre MQTT au lancement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMQTT(ref);
    });

    return MaterialApp(
      title: "AgroPiquet",
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [
        Locale('fr', ''), // Français
        Locale('en', ''), // Anglais
        Locale('ar', ''), // Arabe
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // ou .dark / .light
      home: const AppInitializer(), // Écran de démarrage
    );
  }

  /// Initialise MQTT une seule fois
  Future<void> _initializeMQTT(WidgetRef ref) async {
    final mqtt = ref.read(mqttServiceProvider);
    await mqtt.connect();

    // Écoute l'état de connexion
    mqtt.connectionState.listen((state) {
      final connected = state == MqttConnectionState.connected;
      ref.read(sensorProvider.notifier).setConnected(connected);
    });

    // Réception des données capteurs
    mqtt.onDataReceived = (data) {
      ref.read(sensorProvider.notifier).addSensor(data);
    };
  }
}

/// Écran de démarrage (Splash) → redirige après init
class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Simule un délai (ou vérifie auth Firebase, etc.)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // TODO: Vérifier si l'utilisateur est connecté
    // final user = await AuthService.getCurrentUser();
    // if (user != null) → FarmerDashboardScreen()

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.eco,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              "AgroPiquet",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}