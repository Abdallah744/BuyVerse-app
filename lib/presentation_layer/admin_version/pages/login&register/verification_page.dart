import 'dart:async';

import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

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
    // Add listeners to check if all fields are filled
    for (var controller in _controllers) {
      controller.addListener(() => setState(() {}));
    }
  }

  void startTimer() {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar(
        context: context,
        title: 'Verify Email',
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
              // Email Icon Box
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
              const Text(
                'Check your email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(10),
              Text(
                'We sent a 6-digit verification code to your\nregistered email address.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
              ),
              const Gap(40),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              const Gap(30),
              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                  const Gap(8),
                  Text(
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
              // Verify Button
              defaultButton(
                context: context,
                function: () {
                  if (isOtpComplete()) {
                    print(
                      'Verifying OTP: ${_controllers.map((e) => e.text).join()}',
                    );
                  }
                },
                text: 'Verify',
                background: isOtpComplete()
                    ? HexColor('F5821F')
                    : const Color(0xFFFFCC99),
                radius: 15,
              ),
              const Gap(25),
              // Resend Code
              TextButton.icon(
                onPressed: () {
                  // Reset timer and clear OTP
                },
                icon: Icon(Icons.refresh, color: HexColor('F5821F'), size: 20),
                label: Text(
                  'Resend Code',
                  style: TextStyle(
                    color: HexColor('F5821F'),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Gap(40),
              // Demo Hint
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Demo hint: enter ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      children: [
                        TextSpan(
                          text: '123456',
                          style: TextStyle(
                            color: HexColor('F5821F'),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' to verify'),
                      ],
                    ),
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
