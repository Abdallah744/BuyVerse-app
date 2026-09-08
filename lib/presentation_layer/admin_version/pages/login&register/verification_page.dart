import 'dart:async';

import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core_layer/admin/helpers/app_localization.dart';
import '../../../../core_layer/admin/helpers/cache_helper.dart';
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

  EmailOTP myauth = EmailOTP();
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    // Use a slight delay to ensure context is available for translations in showToast
    WidgetsBinding.instance.addPostFrameCallback((_) => sendOtp());
    startTimer();
    for (var controller in _controllers) {
      controller.addListener(() => setState(() {}));
    }
  }

  void sendOtp() async {
    var l10n = AppLocalizations.of(context);

    myauth.setConfig(
      appEmail: "support@buyverse.com",
      appName: "BuyVerse Admin",
      userEmail: widget.email,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );

    if (await myauth.sendOTP()) {
      if (mounted) {
        showToast(
          context: context,
          text:
              l10n?.translate('otp_sent_msg') ??
              "OTP has been sent to your email",
          state: ToastStates.SUCCESS,
        );
      }
    } else {
      if (mounted) {
        showToast(
          context: context,
          text: l10n?.translate('otp_failed_msg') ?? "Oops, OTP send failed",
          state: ToastStates.ERROR,
        );
      }
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar(
        context: context,
        title: l10n?.translate('verify_email') ?? 'Verify Email',
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                  const Gap(8),
                  Text(
                    l10n?.translate('code_expires_in') ?? 'Code expires in ',
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
                function: () async {
                  if (isOtpComplete()) {
                    String otp = _controllers.map((e) => e.text).join();
                    if (await myauth.verifyOTP(otp: otp)) {
                      if (context.mounted) {
                        showToast(
                          context: context,
                          text:
                              l10n?.translate('otp_success_msg') ??
                              "OTP Verified Successfully",
                          state: ToastStates.SUCCESS,
                        );
                        // Save verification status
                        CacheHelper.saveData(
                          key: 'isVerified',
                          value: true,
                        ).then((value) {
                          if (context.mounted) {
                            // NEW FLOW: After verification, go back to Login Screen
                            navigateAndFinish(context, const LoginScreen());
                          }
                        });
                      }
                    } else {
                      if (context.mounted) {
                        showToast(
                          context: context,
                          text:
                              l10n?.translate('invalid_otp_msg') ??
                              "Invalid OTP, please try again",
                          state: ToastStates.ERROR,
                        );
                      }
                    }
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
                    sendOtp();
                    startTimer();
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
                icon: Icon(Icons.refresh, color: HexColor('F5821F'), size: 20),
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
