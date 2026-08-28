import 'package:buy_verse_app/presentation_layer/admin_version/pages/login&register/verification_page.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

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

  // Controllers for Step 3
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool isPassword = true;
  bool isConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Add listeners to rebuild when text changes for button color update
    nameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
    nationalIdController.addListener(() => setState(() {}));
    businessNameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar(
        context: context,
        title: 'Create Account',
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
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
                _buildSecurityStep(),
              ],
            ),
          ),
        ],
      ),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 1 of 3 — Personal',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const Gap(5),
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Gap(30),
              _buildFieldLabel('Full Name'),
              nameTextFormField(
                context: context,
                controller: nameController,
                type: TextInputType.name,
                hint: 'Ahmed Khalil',
                label: '',
                validate: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              const Gap(20),
              _buildFieldLabel('Email'),
              emailTextFormField(
                context: context,
                controller: emailController,
                type: TextInputType.emailAddress,
                hint: 'ahmed@business.com',
                label: '',
                validate: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              const Gap(20),
              _buildFieldLabel('Phone Number'),
              defaultTextFormField(
                context: context,
                controller: phoneController,
                type: TextInputType.phone,
                hint: '+20 100 000 0000',
                label: '',
                validate: (value) => value!.isEmpty ? 'Enter phone' : null,
              ),
              const Gap(20),
              _buildFieldLabel('National ID'),
              defaultTextFormField(
                context: context,
                controller: nationalIdController,
                type: TextInputType.number,
                hint: '14-digit national ID',
                label: '',
                validate: (value) => value!.isEmpty ? 'Enter ID' : null,
              ),
              const Gap(40),
              defaultButton(
                context: context,
                function: nextStep,
                text: 'Continue',
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 2 of 3 — Business',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const Gap(5),
              const Text(
                'Business Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Gap(30),
              _buildFieldLabel('Business Name'),
              defaultTextFormField(
                context: context,
                controller: businessNameController,
                type: TextInputType.text,
                hint: 'My Digital Store',
                label: '',
                validate: (value) =>
                    value!.isEmpty ? 'Enter business name' : null,
              ),
              const Gap(20),
              _buildFieldLabel('Business Address (Optional)'),
              defaultTextFormField(
                context: context,
                controller: businessAddressController,
                type: TextInputType.text,
                hint: 'Optional',
                label: '',
                validate: (value) => null,
              ),
              const Gap(20),
              _buildFieldLabel('Store Location (Optional)'),
              _buildSelectableField(
                hint: 'Tap to set store location',
                icon: Icons.location_on_outlined,
                onTap: () {},
              ),
              const Gap(20),
              _buildFieldLabel('Commercial Register (Optional)'),
              _buildUploadField(
                text: 'Upload Commercial Register',
                icon: Icons.file_upload_outlined,
                onTap: () {},
              ),
              const Gap(20),
              _buildFieldLabel('Tax Card (Optional)'),
              _buildUploadField(
                text: 'Upload Tax Card',
                icon: Icons.file_upload_outlined,
                onTap: () {},
              ),
              const Gap(40),
              defaultButton(
                context: context,
                function: nextStep,
                text: 'Continue',
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
  Widget _buildSecurityStep() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: formKey3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 3 of 3 — Security',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const Gap(5),
              const Text(
                'Security',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Gap(30),
              _buildFieldLabel('Profile Picture (Optional)'),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  const Gap(15),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.file_upload_outlined,
                      color: HexColor('F5821F'),
                      size: 18,
                    ),
                    label: Text(
                      'Upload photo',
                      style: TextStyle(
                        color: HexColor('F5821F'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              _buildFieldLabel('Password'),
              passwordTextFormField(
                context: context,
                controller: passwordController,
                type: TextInputType.visiblePassword,
                hint: 'Create a strong password',
                label: '',
                isPassword: isPassword,
                suffixPressed: () => setState(() => isPassword = !isPassword),
                validate: (value) => value!.isEmpty ? 'Enter password' : null,
              ),
              const Gap(20),
              _buildFieldLabel('Confirm Password'),
              passwordTextFormField(
                context: context,
                controller: confirmPasswordController,
                type: TextInputType.visiblePassword,
                hint: 'Repeat your password',
                label: '',
                isPassword: isConfirmPassword,
                suffixPressed: () =>
                    setState(() => isConfirmPassword = !isConfirmPassword),
                validate: (value) {
                  if (value!.isEmpty) return 'Confirm your password';
                  if (value != passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),
              const Gap(40),
              defaultButton(
                context: context,
                function: () {
                  if (formKey3.currentState!.validate()) {
                    navigateTo(context, VerificationPage());
                  }
                },
                text: 'Create Account',
                background: isStep3Complete()
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

  // --- Helper Widgets ---

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
