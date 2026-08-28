import 'package:buy_verse_app/presentation_layer/admin_version/pages/login&register/register_screen.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 40.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(20),
                  Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7F0), // Very light cream/orange
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket_rounded,
                          size: 40,
                          color: HexColor('F5821F'),
                        ),
                        const Gap(2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor('F5821F'),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            'Easy Shop',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(30),
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Sign in to manage your store',
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                  const Gap(20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'FOR BUSINESS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: HexColor('F5821F'),
                      ),
                    ),
                  ),
                  const Gap(40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(10),
                      emailTextFormField(
                        context: context,
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        hint: 'your@business.com',
                        label: '',
                        validate: (value) {
                          if (value!.isEmpty) return 'Please enter email';
                          return null;
                        },
                      ),
                      const Gap(25),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(10),
                      passwordTextFormField(
                        context: context,
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        hint: 'Enter your password',
                        label: '',
                        isPassword: isPassword,
                        suffix: Icon(
                          isPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        suffixPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        validate: (value) {
                          if (value!.isEmpty) return 'Please enter password';
                          return null;
                        },
                      ),
                    ],
                  ),
                  const Gap(40),
                  // Sign In Button
                  defaultButton(
                    context: context,
                    width: double.infinity,
                    height: 55,
                    function: () {
                      if (formKey.currentState!.validate()) {
                        print('Signing in: ${emailController.text}');
                      }
                    },
                    text: 'Sign In',
                    background: const Color(0xFFFFCC99),
                    radius: 15,
                  ),
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New merchant? ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateTo(context, RegisterScreen());
                        },
                        child: Text(
                          'Create merchant account',
                          style: TextStyle(
                            color: HexColor('F5821F'),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
