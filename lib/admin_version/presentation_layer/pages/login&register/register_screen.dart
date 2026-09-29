// ignore_for_file: unused_element

import 'dart:io';

import 'login_screen.dart';
import '../../state_management/auth/login/login_bloc.dart';
import '../../state_management/auth/login/login_event.dart';
import '../../state_management/auth/login/login_state.dart';
import '../../widgets/componants.dart';
import '../../widgets/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core_layer/helpers/app_localization.dart';
import '../../../data_layer/admin_models/profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 1;
  final PageController _pageController = PageController();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  // Controllers for Step 1
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var nationalIdController = TextEditingController();

  // Controllers for Step 2
  var businessNameController = TextEditingController();
  var businessAddressController = TextEditingController();
  var storeLocationController = TextEditingController();

  // File Paths
  String? profileImagePath;
  String? commercialRegisterPath;
  String? taxCardPath;
  final ImagePicker _picker = ImagePicker();

  // Controllers for Step 3
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool isPassword = true;
  bool isConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
    nationalIdController.addListener(() => setState(() {}));
    businessNameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25, // Compress image to reduce size below 5MB
    );
    if (image != null) {
      setState(() {
        if (type == 'profile') profileImagePath = image.path;
        if (type == 'commercial') commercialRegisterPath = image.path;
        if (type == 'tax') taxCardPath = image.path;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
    storeLocationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isStep1Complete() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        nationalIdController.text.isNotEmpty;
  }

  bool isStep2Complete() {
    return businessNameController.text.isNotEmpty;
  }

  bool isStep3Complete() {
    return passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
  }

  void nextStep() {
    bool isValid = false;
    if (currentStep == 1) isValid = formKey1.currentState!.validate();
    if (currentStep == 2) isValid = formKey2.currentState!.validate();
    if (currentStep == 3) isValid = formKey3.currentState!.validate();

    if (isValid && currentStep < 3) {
      setState(() {
        currentStep++;
        _pageController.animateToPage(
          currentStep - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
        _pageController.animateToPage(
          currentStep - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          showToast(
            context: context,
            text: l10n?.translate('success') ?? 'Account Created Successfully',
            state: ToastStates.SUCCESS,
          );
          // NEW FLOW: After registration, go to Login Screen
          navigateAndFinish(context, const LoginScreen());
        }
        if (state is AuthError) {
          showToast(
            context: context,
            text: state.message,
            state: ToastStates.ERROR,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: defaultAppBar(
            context: context,
            title: l10n?.translate('register') ?? 'Create Account',
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          body: Column(
            children: [
              if (state is AuthLoading) const LinearProgressIndicator(),
              const Gap(10),
              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    _buildProgressSegment(1),
                    const Gap(8),
                    _buildProgressSegment(2),
                    const Gap(8),
                    _buildProgressSegment(3),
                  ],
                ),
              ),
              const Gap(20),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPersonalInfoStep(),
                    _buildBusinessInfoStep(),
                    _buildSecurityStep(state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSegment(int step) {
    bool isActive = step <= currentStep;
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? HexColor('F5821F') : Colors.grey[200],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // --- Step 1: Personal Information ---
  Widget _buildPersonalInfoStep() {
    var l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n?.translate('step') ?? 'Step'} $currentStep ${l10n?.translate('of') ?? 'of'} 3',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const Gap(5),
              Text(
                l10n?.translate('personal_information') ??
                    'Personal Information',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(30),
              _buildFieldLabel(l10n?.translate('full_name') ?? 'Full Name'),
              nameTextFormField(
                context: context,
                controller: nameController,
                type: TextInputType.name,
                hint: 'Ahmed Khalil',
                label: '',
                validate: (value) {
                  if (value!.isEmpty) {
                    return l10n?.translate('name_required') ??
                        'Enter your name';
                  }
                  if (RegExp(r'[0-9]').hasMatch(value)) {
                    return l10n?.translate('name_no_numbers') ??
                        'Name should not contain numbers';
                  }
                  return null;
                },
              ),
              const Gap(20),
              _buildFieldLabel(l10n?.translate('email') ?? 'Email'),
              emailTextFormField(
                context: context,
                controller: emailController,
                type: TextInputType.emailAddress,
                hint: 'ahmed@business.com',
                label: '',
                validate: (value) {
                  if (value!.isEmpty) {
                    return l10n?.translate('email_required') ?? 'Enter email';
                  }
                  if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value)) {
                    return l10n?.translate('invalid_email') ??
                        'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const Gap(20),
              _buildFieldLabel(l10n?.translate('phone') ?? 'Phone Number'),
              defaultTextFormField(
                context: context,
                controller: phoneController,
                type: TextInputType.phone,
                hint: '+20 100 000 0000',
                label: '',
                validate: (value) {
                  if (value!.isEmpty) {
                    return l10n?.translate('phone_required') ?? 'Enter phone';
                  }
                  if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
                    return l10n?.translate('phone_invalid_format') ??
                        'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const Gap(20),
              _buildFieldLabel(l10n?.translate('national_id') ?? 'National ID'),
              defaultTextFormField(
                context: context,
                controller: nationalIdController,
                type: TextInputType.number,
                hint: '14-digit national ID',
                label: '',
                validate: (value) {
                  if (value!.isEmpty) {
                    return l10n?.translate('id_required') ?? 'Enter ID';
                  }
                  if (value.length < 14) {
                    return l10n?.translate('id_too_short') ??
                        'ID must be at least 14 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return l10n?.translate('id_digits_only') ??
                        'ID must be digits only';
                  }
                  return null;
                },
              ),
              const Gap(40),
              defaultButton(
                context: context,
                function: nextStep,
                text: l10n?.translate('confirm') ?? 'Continue',
                background: isStep1Complete()
                    ? HexColor('F5821F')
                    : const Color(0xFFFFCC99),
                radius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Step 2: Business Information ---
  Widget _buildBusinessInfoStep() {
    var l10n = AppLocalizations.of(context);
    String optionalStr = '(${l10n?.translate('optional') ?? 'Optional'})';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n?.translate('step') ?? 'Step'} $currentStep ${l10n?.translate('of') ?? 'of'} 3',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  TextButton(
                    onPressed: previousStep,
                    child: Text(
                      l10n?.translate('back') ?? 'Back',
                      style: TextStyle(color: HexColor('F5821F')),
                    ),
                  ),
                ],
              ),
              const Gap(5),
              Text(
                l10n?.translate('business_information') ??
                    'Business Information',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(30),
              _buildFieldLabel(
                l10n?.translate('business_name') ?? 'Business Name',
              ),
              defaultTextFormField(
                context: context,
                controller: businessNameController,
                type: TextInputType.text,
                hint: 'My Digital Store',
                label: '',
                validate: (value) => value!.isEmpty
                    ? l10n?.translate('business_name_required') ??
                          'Enter business name'
                    : null,
              ),
              const Gap(20),
              _buildFieldLabel(
                '${l10n?.translate('business_address') ?? 'Business Address'} $optionalStr',
              ),
              defaultTextFormField(
                context: context,
                controller: businessAddressController,
                type: TextInputType.text,
                hint: l10n?.translate('optional') ?? 'Optional',
                label: '',
                validate: (value) => null,
              ),
              const Gap(20),
              _buildFieldLabel(
                l10n?.translate('store_location') ?? 'Store Location',
              ),
              defaultTextFormField(
                context: context,
                controller: storeLocationController,
                type: TextInputType.text,
                hint: 'Cairo, Egypt',
                label: '',
                onTab: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPickerScreen(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      storeLocationController.text = result;
                    });
                  }
                },
                validate: (value) => value!.isEmpty
                    ? l10n?.translate('location_required') ??
                          'Enter store location'
                    : null,
              ),
              const Gap(20),
              _buildFieldLabel(
                '${l10n?.translate('commercial_register') ?? 'Commercial Register'} $optionalStr',
              ),
              _buildUploadField(
                text: commercialRegisterPath == null
                    ? l10n?.translate('pick_file') ??
                          'Upload Commercial Register'
                    : l10n?.translate('uploaded') ?? 'File Selected',
                icon: Icons.file_upload_outlined,
                onTap: () => _pickImage('commercial'),
              ),
              const Gap(20),
              _buildFieldLabel(
                '${l10n?.translate('tax_card') ?? 'Tax Card'} $optionalStr',
              ),
              _buildUploadField(
                text: taxCardPath == null
                    ? l10n?.translate('pick_file') ?? 'Upload Tax Card'
                    : l10n?.translate('uploaded') ?? 'File Selected',
                icon: Icons.file_upload_outlined,
                onTap: () => _pickImage('tax'),
              ),
              const Gap(40),
              defaultButton(
                context: context,
                function: nextStep,
                text: l10n?.translate('confirm') ?? 'Continue',
                background: isStep2Complete()
                    ? HexColor('F5821F')
                    : const Color(0xFFFFCC99),
                radius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Step 3: Security ---
  Widget _buildSecurityStep(AuthState state) {
    var l10n = AppLocalizations.of(context);
    String optionalStr = '(${l10n?.translate('optional') ?? 'Optional'})';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n?.translate('step') ?? 'Step'} $currentStep ${l10n?.translate('of') ?? 'of'} 3',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  TextButton(
                    onPressed: previousStep,
                    child: Text(
                      l10n?.translate('back') ?? 'Back',
                      style: TextStyle(color: HexColor('F5821F')),
                    ),
                  ),
                ],
              ),
              const Gap(5),
              Text(
                l10n?.translate('security') ?? 'Security',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(30),
              _buildFieldLabel(
                '${l10n?.translate('profile_image') ?? 'Profile Picture'} $optionalStr',
              ),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      image: profileImagePath != null
                          ? DecorationImage(
                              image: FileImage(File(profileImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: profileImagePath == null
                        ? const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const Gap(15),
                  TextButton.icon(
                    onPressed: () => _pickImage('profile'),
                    icon: Icon(
                      Icons.file_upload_outlined,
                      color: HexColor('F5821F'),
                      size: 18,
                    ),
                    label: Text(
                      l10n?.translate('pick_image') ?? 'Upload photo',
                      style: TextStyle(
                        color: HexColor('F5821F'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              _buildFieldLabel(l10n?.translate('password') ?? 'Password'),
              passwordTextFormField(
                context: context,
                controller: passwordController,
                type: TextInputType.visiblePassword,
                hint: l10n?.translate('password') ?? 'Create a strong password',
                label: '',
                isPassword: isPassword,
                suffixPressed: () => setState(() => isPassword = !isPassword),
                validate: (value) {
                  if (value!.isEmpty) {
                    return l10n?.translate('password_required') ??
                        'Enter password';
                  }
                  if (value.length < 8) {
                    return l10n?.translate('password_too_short') ??
                        'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const Gap(20),
              _buildFieldLabel(
                l10n?.translate('confirm_password') ?? 'Confirm Password',
              ),
              passwordTextFormField(
                context: context,
                controller: confirmPasswordController,
                type: TextInputType.visiblePassword,
                hint:
                    l10n?.translate('confirm_password') ??
                    'Repeat your password',
                label: '',
                isPassword: isConfirmPassword,
                suffixPressed: () =>
                    setState(() => isConfirmPassword = !isConfirmPassword),
                validate: (value) {
                  if (value!.isEmpty) {
                    return l10n?.translate('password_required') ??
                        'Confirm your password';
                  }
                  if (value != passwordController.text) {
                    return l10n?.translate('passwords_not_match') ??
                        'Passwords do not match';
                  }
                  return null;
                },
              ),
              const Gap(40),
              defaultButton(
                context: context,
                function: () {
                  if (formKey3.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                      RegisterRequested(
                        profile: UserProfile(
                          fullName: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          nationalId: nationalIdController.text,
                          businessName: businessNameController.text,
                          businessAddress: businessAddressController.text,
                          storeLocation: storeLocationController.text,
                        ),
                        password: passwordController.text,
                        profileImagePath: profileImagePath,
                        commercialRegisterPath: commercialRegisterPath,
                        taxCardPath: taxCardPath,
                      ),
                    );
                    navigateAndFinish(context, LoginScreen());
                  }
                },
                text: l10n?.translate('register') ?? 'Create Account',
                background: isStep3Complete() && state is! AuthLoading
                    ? HexColor('F5821F')
                    : const Color(0xFFFFCC99),
                radius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildUploadField({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const Gap(10),
            Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableField({
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const Gap(10),
            Text(hint, style: TextStyle(color: Colors.grey[500], fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
