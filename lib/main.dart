import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'presentation/providers/language_provider.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/farmer/farmer_dashboard_screen.dart';
import 'screens/enterprise/enterprise_dashboard_screen.dart';
import 'services/auth_service.dart';
import 'services/mqtt_service.dart';

void main() {
  runApp(
    const ProviderScope(child: AgroApp()),
  );
}

class AgroApp extends ConsumerWidget {
  const AgroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    // Démarre MQTT après le premier rendu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupMQTT(ref); // doit exister dans mqtt_service.dart
    });

    return MaterialApp(
      title: "AgroPiquet",
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [
        Locale('fr', ''),
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AppInitializer(),
    );
  }
}

/// SplashScreen + redirection automatique
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
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = await AuthService().getCurrentUser();

    if (user != null) {
      if (user.role == "admin") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => EnterpriseDashboardScreen()),
        );
      } else if (user.role == "farmer") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => FarmerDashboardScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) => const SplashScreen();
}

/// Splash animé
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.eco, size: 80, color: Colors.white),
            SizedBox(height: 24),
            Text(
              "AgroPiquet",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
