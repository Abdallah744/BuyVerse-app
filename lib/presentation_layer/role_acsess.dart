import 'package:buy_verse_app/core_layer/admin/helpers/cache_helper.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/login&register/login_screen.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class RoleAccessRestriction extends StatefulWidget {
  const RoleAccessRestriction({super.key});

  @override
  State<RoleAccessRestriction> createState() => _RoleAccessRestrictionState();
}

class _RoleAccessRestrictionState extends State<RoleAccessRestriction> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const Gap(60),
              _RoleItem(
                title: 'Seller Account',
                imagePath: 'assets/images/businessman.png',
                activeColor: Colors.amber,
                isSelected: selectedRole == 'Seller',
                onTap: () {
                  setState(() {
                    selectedRole = 'Seller';
                  });
                },
              ),
              const Gap(30),
              _RoleItem(
                title: 'Customer Account',
                imagePath: 'assets/images/woman.png',
                activeColor: Colors.blueAccent,
                isSelected: selectedRole == 'Customer',
                onTap: () {
                  setState(() {
                    selectedRole = 'Customer';
                  });
                },
              ),
              const Gap(40),
              defaultButton(
                width: 300,
                context: context,
                function: () {
                  if (selectedRole == 'Seller') {
                    CacheHelper.saveData(key: 'role', value: 'admin');
                    navigateTo(context, const LoginScreen());
                  } else if (selectedRole == 'Customer') {
                    CacheHelper.saveData(key: 'role', value: 'customer');
                    showToast(
                      context: context,
                      text: 'Customer interface is under development',
                      state: ToastStates.WARNING,
                    );
                  }
                },
                text: 'Continue',
                background: selectedRole != null
                    ? HexColor('F5821F')
                    : Colors.grey[400]!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleItem extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color activeColor;
  final VoidCallback onTap;
  final bool isSelected;

  const _RoleItem({
    required this.title,
    required this.imagePath,
    required this.activeColor,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<_RoleItem> createState() => _RoleItemState();
}

class _RoleItemState extends State<_RoleItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isHighlighted = isHovered || widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isHighlighted
                      ? widget.activeColor
                      : Colors.transparent,
                  width: 4,
                ),
                boxShadow: isHighlighted
                    ? [
                        BoxShadow(
                          color: widget.activeColor.withValues(alpha: 0.4),
                          blurRadius: 25,
                          spreadRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage(widget.imagePath),
              ),
            ),
            const Gap(15),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 18,
                fontWeight: isHighlighted ? FontWeight.w900 : FontWeight.bold,
                color: isHighlighted ? widget.activeColor : Colors.black87,
              ),
              child: Text(widget.title),
            ),
          ],
        ),
      ),
    );
  }
}
