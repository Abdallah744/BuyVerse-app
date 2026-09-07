class RegisterParam {
  const RegisterParam({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.confirmPassword,
    this.address,
    this.pic,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final String? confirmPassword;
  final String? address;
  final String? pic;
}
