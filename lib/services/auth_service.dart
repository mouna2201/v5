import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const _kUsersKey = 'agropiquet_users';

  // récupère tous les utilisateurs
  static Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kUsersKey);
    if (s == null || s.isEmpty) return [];
    final List decoded = jsonDecode(s) as List;
    return decoded.map((e) => UserModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // sauvegarde tous les utilisateurs
  static Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_kUsersKey, encoded);
  }

  // Vérifie si un email existe déjà
  static Future<bool> emailExists(String email) async {
    final users = await _getUsers();
    return users.any((u) => u.email.toLowerCase() == email.toLowerCase());
  }

  // Enregistre un utilisateur
  static Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    if (name.trim().isEmpty) return 'Le nom est requis';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) return 'Email invalide';
    if (password.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
    if (await emailExists(email)) return 'Un compte avec cet email existe déjà';

    final users = await _getUsers();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final user = UserModel(
      id: id,
      name: name.trim(),
      email: email.trim(),
      password: password,
      role: role,
    );
    users.add(user);
    await _saveUsers(users);
    return null;
  }

  // Connexion simple
  static Future<UserModel?> login(String email, String password) async {
    final users = await _getUsers();
    try {
      return users.firstWhere(
          (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password);
    } catch (e) {
      return null;
    }
  }

  // Récupérer tous les utilisateurs
  static Future<List<UserModel>> getAllUsers() async {
    return await _getUsers();
  }

  // Générateur de mot de passe aléatoire
  static String generatePassword({int length = 8}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  // Supprimer tous les utilisateurs (dev)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUsersKey);
  }
}
