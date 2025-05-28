class User {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String password; // Не храните пароль в модели!
  final double balance;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      password: json['password'], // Не храните пароль в модели!
      balance: json['balance']?.toDouble() ?? 0.0,
    );
  }
}