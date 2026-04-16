class ProfileEntity {
  final String id;
  final String email;
  final String password;
  final String address;
  final String city;
  final String country;
  final String pincode;
  final String bankAccountNumber;
  final String accountHolderName;
  final String ifscCode;
  final DateTime createdAt;

  ProfileEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.address,
    required this.city,
    required this.country,
    required this.pincode,
    required this.bankAccountNumber,
    required this.accountHolderName,
    required this.ifscCode,
    required this.createdAt,
  });
}