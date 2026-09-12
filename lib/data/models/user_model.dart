class UserModel {
  final int? id;
  final String email;
  final String fullName;
  final String role; // 'CUSTOMER' or 'ADMIN'
  final String? token;
  final String? phoneNumber;
  final String? address;

  UserModel({
    this.id,
    required this.email,
    required this.fullName,
    this.role = 'CUSTOMER',
    this.token,
    this.phoneNumber,
    this.address,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? json['name'] as String? ?? '',
      role: (json['role'] as String? ?? 'CUSTOMER').toUpperCase(),
      token: json['token'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'token': token,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
