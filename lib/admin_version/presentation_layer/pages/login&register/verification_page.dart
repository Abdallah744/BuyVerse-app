import 'dart:async';

import '../admin_HomeScreen.dart';
import '../../state_management/auth/login/login_bloc.dart';
import '../../state_management/auth/login/login_event.dart';
import '../../state_management/auth/login/login_state.dart';
import '../../state_management/category/category_bloc.dart';
import '../../state_management/notification/notification_bloc.dart';
import '../../state_management/order/order_bloc.dart';
import '../../state_management/product/product_bloc.dart';
import '../../state_management/profile/profile_bloc.dart';
import '../../widgets/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core_layer/helpers/app_localization.dart';
import 'login_screen.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _timer;
  int _start = 598; // 09:58 in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
    for (var controller in _controllers) {
      controller.addListener(() => setState(() {}));
    }
  }

  void startTimer() {
    _timer?.cancel();
    _start = 598;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool isOtpComplete() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          showToast(
            context: context,
            text:
                l10n?.translate('otp_success_msg') ??
                "OTP Verified Successfully",
            state: ToastStates.SUCCESS,
          );

          // Fetch data for the newly verified account
          context.read<ProfileBloc>().add(GetProfile());
          context.read<ProductBloc>().add(GetProducts());
          context.read<CategoryBloc>().add(GetCategories());
          context.read<OrderBloc>().add(GetOrders());
          context.read<NotificationBloc>().add(GetNotifications());

          navigateAndFinish(context, const AdminHomeScreen());
        }
        if (state is OtpResent) {
          showToast(
            context: context,
            text: l10n?.translate('otp_sent_msg') ?? "OTP Resent Successfully",
            state: ToastStates.SUCCESS,
          );
          startTimer();
        }
        if (state is AuthError && state.message != 'VERIFICATION_REQUIRED') {
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                navigateAndFinish(context, const LoginScreen());
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
            title: Text(
              l10n?.translate('verify_email') ?? 'Verify Email',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (state is AuthLoading) const LinearProgressIndicator(),
                  const Gap(20),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.mail_outline_rounded,
                      size: 40,
                      color: HexColor('F5821F'),
                    ),
                  ),
                  const Gap(30),
                  Text(
                    l10n?.translate('check_your_email') ?? 'Check your email',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    '${l10n?.translate('otp_sent_to') ?? 'We sent a 6-digit verification code to'}\n${widget.email}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                  ),
                  const Gap(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => _buildOtpBox(index)),
                  ),
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const Gap(8),
                      Text(
                        l10n?.translate('code_expires_in') ??
                            'Code expires in ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                      Text(
                        timerText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Gap(40),
                  defaultButton(
                    context: context,
                    function: () {
                      if (isOtpComplete()) {
                        String otp = _controllers.map((e) => e.text).join();
                        context.read<AuthBloc>().add(
                          VerifyOtpRequested(email: widget.email, otp: otp),
                        );
                      }
                    },
                    text: l10n?.translate('verify') ?? 'Verify',
                    background: isOtpComplete()
                        ? HexColor('F5821F')
                        : const Color(0xFFFFCC99),
                    radius: 15,
                  ),
                  const Gap(25),
                  TextButton.icon(
                    onPressed: () {
                      if (_start == 0) {
                        for (var c in _controllers) {
                          c.clear();
                        }
                        context.read<AuthBloc>().add(
                          ResendOtpRequested(widget.email),
                        );
                      } else {
                        showToast(
                          context: context,
                          text:
                              l10n?.translate('wait_timer_msg') ??
                              "Please wait until the timer expires",
                          state: ToastStates.WARNING,
                        );
                      }
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: HexColor('F5821F'),
                      size: 20,
                    ),
                    label: Text(
                      l10n?.translate('resend_code') ?? 'Resend Code',
                      style: TextStyle(
                        color: HexColor('F5821F'),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpBox(int index) {
    bool hasValue = _controllers[index].text.isNotEmpty;
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: hasValue ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: hasValue ? HexColor('F5821F') : Colors.transparent,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: HexColor('F5821F'),
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}
