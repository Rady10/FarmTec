class UserModel {
  final String username;
  final String email;
  final String? phoneNumber;

  UserModel({
    required this.username,
    required this.email,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}
