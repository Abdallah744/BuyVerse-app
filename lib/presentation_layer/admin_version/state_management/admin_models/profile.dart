import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String nationalId;
  final String businessName;
  final String businessAddress;
  final String storeLocation;
  final bool commercialRegisterUploaded;
  final bool taxCardUploaded;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.businessName,
    required this.businessAddress,
    required this.storeLocation,
    this.commercialRegisterUploaded = false,
    this.taxCardUploaded = false,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    nationalId,
    businessName,
    businessAddress,
    storeLocation,
    commercialRegisterUploaded,
    taxCardUploaded,
  ];
}
