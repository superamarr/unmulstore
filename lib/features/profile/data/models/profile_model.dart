class ProfileModel {
  final String id;
  final String? fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? address;

  ProfileModel({
    required this.id,
    this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.address,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      fullName: map['full_name'],
      phoneNumber: map['phone_number'],
      avatarUrl: map['avatar_url'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'address': address,
    };
  }
}
