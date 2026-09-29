import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? uId;
  final String fullName;
  final String email;
  final String phone;
  final String nationalId;
  final String businessName;
  final String businessAddress;
  final String storeLocation;
  final String profileImage;
  final String commercialRegisterUrl;
  final String taxCardUrl;

  const UserProfile({
    this.uId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.nationalId,
    required this.businessName,
    required this.businessAddress,
    required this.storeLocation,
    this.profileImage = '',
    this.commercialRegisterUrl = '',
    this.taxCardUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'personalInfo': {
        'uId': uId,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'nationalId': nationalId,
      },
      'businessInfo': {
        'businessName': businessName,
        'businessAddress': businessAddress,
        'storeLocation': storeLocation,
        'profileImage': profileImage,
        'commercialRegisterUrl': commercialRegisterUrl,
        'taxCardUrl': taxCardUrl,
        // Sections for products and orders
        'products': [],
        'orders': [],
      },
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final personal = map['personalInfo'] ?? {};
    final business = map['businessInfo'] ?? {};

    return UserProfile(
      uId: personal['uId']?.toString() ?? '',
      fullName: personal['fullName']?.toString() ?? '',
      email: personal['email']?.toString() ?? '',
      phone: personal['phone']?.toString() ?? '',
      nationalId: personal['nationalId']?.toString() ?? '',
      businessName: business['businessName']?.toString() ?? '',
      businessAddress: business['businessAddress']?.toString() ?? '',
      storeLocation: business['storeLocation']?.toString() ?? '',
      profileImage: (business['profileImage']?.toString() ?? '').replaceAll(
        'null',
        '',
      ),
      commercialRegisterUrl:
          (business['commercialRegisterUrl']?.toString() ?? '').replaceAll(
            'null',
            '',
          ),
      taxCardUrl: (business['taxCardUrl']?.toString() ?? '').replaceAll(
        'null',
        '',
      ),
    );
  }

  @override
  List<Object?> get props => [
    uId,
    fullName,
    email,
    phone,
    nationalId,
    businessName,
    businessAddress,
    storeLocation,
    profileImage,
    commercialRegisterUrl,
    taxCardUrl,
  ];
}
