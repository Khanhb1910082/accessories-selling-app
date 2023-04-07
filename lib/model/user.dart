class Users {
  final String email;
  final String address;
  final String phone;

  Users({
    required this.email,
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'address': address,
      'phone': phone,
    };
  }

  static Users fromMap(Map<String, dynamic> map) {
    return Users(
      email: map['email'],
      address: map['address'],
      phone: map['phone'],
    );
  }

  Users copyWith({
    String? email,
    String? address,
    String? phone,
  }) {
    return Users(
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }
}
