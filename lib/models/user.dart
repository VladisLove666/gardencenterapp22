import 'role.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String phone;
  String email;
  Role role;
  bool isBanned;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.role,
    this.isBanned = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      role: Role.fromJson(json['roles']),
      isBanned: json['is_banned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'roles': role.toJson(),
      'is_banned': isBanned,
    };
  }
}