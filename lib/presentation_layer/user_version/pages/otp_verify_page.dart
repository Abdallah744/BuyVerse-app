import 'dart:async';

import 'package:buy_verse_app/presentation_layer/user_version/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core_layer/user/core/params/otp_resend_params.dart';
import '../../../core_layer/user/core/params/otp_verify_params.dart';
import '../state_management/auth/auth_cubit.dart';

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key, this.email});

  final String? email;

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  Timer? _resendTimer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? '';
    _startResendTimer();
  }

  void _startResendTimer() {
    _secondsRemaining = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        return;
      }
      setState(() => _secondsRemaining--);
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF9F5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1B2334),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) async {
                  if (state is AuthSuccess) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP verified successfully'),
                      ),
                    );

                    final token = state.user.token;
                    if (token != null && token.isNotEmpty) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => HomePage(authToken: token),
                        ),
                        (route) => false,
                      );
                    }
                  } else if (state is AuthError) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return Card(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFE8D0),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                size: 30,
                                color: Color(0xFFFF6900),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1B2334),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Enter the code sent to your email',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 22),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFFFF7A00),
                                ),
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return 'OTP code is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(
                                  Icons.numbers_rounded,
                                  color: Color(0xFFFF7A00),
                                ),
                                hintText: 'OTP code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        final currentState = _formKey.currentState;
                                        if (currentState != null && currentState.validate()) {
                                          context.read<AuthCubit>().verifyOtp(
                                            params: OtpVerifyParams(
                                              email: _emailController.text
                                                  .trim(),
                                              otpCode: _otpController.text
                                                  .trim(),
                                            ),
                                          );
                                        }
                                      },
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF7A00),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Verify OTP'),
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextButton(
                              onPressed: isLoading || _secondsRemaining > 0
                                  ? null
                                  : () {
                                      final email = _emailController.text
                                          .trim();
                                      if (email.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Email is required to resend OTP',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      context.read<AuthCubit>().resendOtp(
                                        params: OtpResendParams(email: email),
                                      );
                                      _startResendTimer();
                                    },
                              child: Text(
                                _secondsRemaining > 0
                                    ? 'Resend OTP in $_secondsRemaining s'
                                    : 'Resend OTP',
                                style: TextStyle(
                                  color: _secondsRemaining > 0
                                      ? Colors.grey
                                      : const Color(0xFFFF7A00),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
