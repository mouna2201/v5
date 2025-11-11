class UserModel {
  final String id;       // simple id
  final String name;
  final String email;
  final String password; // stocké en clair ici (demo). Pour prod -> hasher.
  final String role;     // "farmer" or "enterprise" or "enterprise_farmer"

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        role: json['role'] as String,
      );
}
