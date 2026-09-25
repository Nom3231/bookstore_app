class UserModel {
  final int? id;
  final String email;
  final String fullName;
  final String role; // 'CUSTOMER' or 'ADMIN'
  final String? token;
  final String? phoneNumber;
  final String? address;
  final String? avatarUrl;

  UserModel({
    this.id,
    required this.email,
    required this.fullName,
    this.role = 'CUSTOMER',
    this.token,
    this.phoneNumber,
    this.address,
    this.avatarUrl,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  UserModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? role,
    String? token,
    String? phoneNumber,
    String? address,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? json['name'] as String? ?? '',
      role: (json['role'] as String? ?? 'CUSTOMER').toUpperCase(),
      token: json['token'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['profileImageUrl'] as String?,
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
      'avatarUrl': avatarUrl,
    };
  }
}
