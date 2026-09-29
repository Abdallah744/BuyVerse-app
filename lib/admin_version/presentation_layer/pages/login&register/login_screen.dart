import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core_layer/helpers/app_localization.dart';
import '../../../core_layer/helpers/cache_helper.dart';
import '../../../../role_acsess.dart';
import '../../state_management/auth/login/login_bloc.dart';
import '../../state_management/auth/login/login_event.dart';
import '../../state_management/auth/login/login_state.dart';
import '../../state_management/category/category_bloc.dart';
import '../../state_management/notification/notification_bloc.dart';
import '../../state_management/order/order_bloc.dart';
import '../../state_management/product/product_bloc.dart';
import '../../state_management/profile/profile_bloc.dart';
import '../../widgets/componants.dart';
import '../admin_HomeScreen.dart';
import 'register_screen.dart';
import 'verification_page.dart';

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
    var l10n = AppLocalizations.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          showToast(
            context: context,
            text: l10n?.translate('success') ?? 'Welcome Back!',
            state: ToastStates.SUCCESS,
          );

          // Check if account is verified specifically for this email
          bool isVerified = CacheHelper.getData(key: 'isVerified') ?? false;
          bool isEmailVerified =
              CacheHelper.getData(key: 'verified_${emailController.text}') ??
              false;

          if (!isVerified && !isEmailVerified) {
            // NEW FLOW: Redirect to Verification Page if not verified locally
            navigateAndFinish(
              context,
              VerificationPage(email: emailController.text),
            );
          } else {
            // Success: Trigger all data fetching for the registered account
            context.read<ProfileBloc>().add(GetProfile());
            context.read<ProductBloc>().add(GetProducts());
            context.read<CategoryBloc>().add(GetCategories());
            context.read<OrderBloc>().add(GetOrders());
            context.read<NotificationBloc>().add(GetNotifications());

            navigateAndFinish(context, const AdminHomeScreen());
          }
        }
        if (state is AuthError) {
          if (state.message == 'VERIFICATION_REQUIRED') {
            navigateAndFinish(
              context,
              VerificationPage(email: emailController.text),
            );
          } else if (ModalRoute.of(context)?.isCurrent ?? false) {
            showToast(
              context: context,
              text: state.message,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                // Navigate back to role selection
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const RoleAccessRestriction(),
                  ),
                );
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 20.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state is AuthLoading) const LinearProgressIndicator(),
                      const Gap(20),
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7F0),
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
                              child: Text(
                                l10n?.translate('app_title') ?? 'Easy Shop',
                                style: const TextStyle(
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
                      Text(
                        l10n?.translate('login') ?? 'Welcome back',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        l10n?.translate('sign_in_manage') ??
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
                          l10n?.translate('for_business') ?? 'FOR BUSINESS',
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
                          Text(
                            l10n?.translate('email') ?? 'Email',
                            style: const TextStyle(
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
                              if (value!.isEmpty) {
                                return l10n?.translate('email_required') ??
                                    'Please enter email';
                              }
                              return null;
                            },
                          ),
                          const Gap(25),
                          Text(
                            l10n?.translate('password') ?? 'Password',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(10),
                          passwordTextFormField(
                            context: context,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            hint:
                                l10n?.translate('password') ??
                                'Enter your password',
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
                              if (value!.isEmpty) {
                                return l10n?.translate('password_required') ??
                                    'Please enter password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const Gap(40),
                      defaultButton(
                        context: context,
                        width: double.infinity,
                        height: 55,
                        function: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              LoginRequested(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                          }
                        },
                        text: l10n?.translate('login') ?? 'Sign In',
                        background: state is AuthLoading
                            ? const Color(0xFFFFCC99)
                            : HexColor('F5821F'),
                        radius: 15,
                      ),
                      const Gap(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${l10n?.translate('dont_have_account') ?? 'New merchant? '} ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, const RegisterScreen());
                            },
                            child: Text(
                              l10n?.translate('register') ??
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
      },
    );
  }
}
