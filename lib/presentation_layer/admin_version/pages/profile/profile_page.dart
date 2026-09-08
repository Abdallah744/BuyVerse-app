import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/login&register/login_screen.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/profile/edit_profile.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/auth/login/login_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/auth/login/login_event.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/auth/login/login_state.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/localization/localization_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/profile/profile_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          navigateAndFinish(context, const LoginScreen());
        }
      },
      builder: (context, authState) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileLoaded) {
              final profile = state.profile;
              return Scaffold(
                backgroundColor: HexColor('F7F8FA'),
                appBar: AppBar(
                  backgroundColor: HexColor('F5821F'),
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    l10n?.translate('profile') ?? 'Profile',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(context, state),
                      Padding(
                        padding: EdgeInsets.all(context.setWidth(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLanguageSwitcher(context),
                            Gap(context.setHeight(20)),
                            _buildSection(
                              context,
                              title:
                                  l10n?.translate('personal_information') ??
                                  'PERSONAL INFORMATION',
                              items: [
                                _buildInfoItem(
                                  context,
                                  icon: Icons.person_outline,
                                  label:
                                      l10n?.translate('full_name') ??
                                      'Full Name',
                                  value: profile.fullName,
                                ),
                                _buildInfoItem(
                                  context,
                                  icon: Icons.email_outlined,
                                  label: l10n?.translate('email') ?? 'Email',
                                  value: profile.email,
                                ),
                                _buildInfoItem(
                                  context,
                                  icon: Icons.phone_outlined,
                                  label: l10n?.translate('phone') ?? 'Phone',
                                  value: profile.phone,
                                ),
                                _buildInfoItem(
                                  context,
                                  icon: Icons.badge_outlined,
                                  label:
                                      l10n?.translate('national_id') ??
                                      'National ID',
                                  value: profile.nationalId,
                                ),
                              ],
                            ),
                            Gap(context.setHeight(20)),
                            _buildSection(
                              context,
                              title:
                                  l10n?.translate('business_information') ??
                                  'BUSINESS INFORMATION',
                              items: [
                                _buildInfoItem(
                                  context,
                                  icon: Icons.storefront_outlined,
                                  label:
                                      l10n?.translate('business_name') ??
                                      'Business Name',
                                  value: profile.businessName,
                                ),
                                _buildInfoItem(
                                  context,
                                  icon: Icons.location_on_outlined,
                                  label:
                                      l10n?.translate('business_address') ??
                                      'Business Address',
                                  value: profile.businessAddress,
                                ),
                                _buildInfoItem(
                                  context,
                                  icon: Icons.map_outlined,
                                  label:
                                      l10n?.translate('store_location') ??
                                      'Store Location',
                                  value: profile.storeLocation,
                                ),
                              ],
                            ),
                            Gap(context.setHeight(30)),
                            defaultButton(
                              context: context,
                              function: () {
                                navigateTo(context, const EditProfilePage());
                              },
                              text:
                                  l10n?.translate('edit_profile') ??
                                  'Edit Profile',
                              background: HexColor('F5821F'),
                              radius: 20,
                            ),
                            Gap(context.setHeight(20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        );
      },
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    var currentLocale = BlocProvider.of<LocalizationBloc>(context).state.locale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.translate('settings') ?? 'SETTINGS',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: context.setSp(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Gap(context.setHeight(10)),
        InkWell(
          onTap: () => _showLanguageDialog(context),
          borderRadius: BorderRadius.circular(context.setWidth(20)),
          child: Container(
            padding: EdgeInsets.all(context.setWidth(15)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(context.setWidth(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.setWidth(8)),
                  decoration: BoxDecoration(
                    color: HexColor('F5821F').withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language,
                    color: HexColor('F5821F'),
                    size: context.setWidth(20),
                  ),
                ),
                Gap(context.setWidth(15)),
                Text(
                  l10n?.translate('language') ?? 'Language',
                  style: TextStyle(
                    fontSize: context.setSp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  currentLocale.languageCode == 'ar'
                      ? l10n?.translate('arabic') ?? 'Arabic'
                      : l10n?.translate('english') ?? 'English',
                  style: TextStyle(
                    color: HexColor('F5821F'),
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(14),
                  ),
                ),
                Gap(context.setWidth(5)),
                Icon(
                  Icons.arrow_forward_ios,
                  size: context.setWidth(14),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(context.setWidth(25)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.setWidth(50),
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Gap(context.setHeight(20)),
            Text(
              l10n?.translate('select_language') ?? 'Select Language',
              style: TextStyle(
                fontSize: context.setSp(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(context.setHeight(20)),
            _buildLanguageOption(
              context,
              title: l10n?.translate('arabic') ?? 'Arabic',
              icon: '🇪🇬',
              isSelected:
                  BlocProvider.of<LocalizationBloc>(
                    context,
                  ).state.locale.languageCode ==
                  'ar',
              onTap: () {
                context.read<LocalizationBloc>().add(
                  ChangeLanguage(const Locale('ar')),
                );
                Navigator.pop(context);
              },
            ),
            Gap(context.setHeight(10)),
            _buildLanguageOption(
              context,
              title: l10n?.translate('english') ?? 'English',
              icon: '🇺🇸',
              isSelected:
                  BlocProvider.of<LocalizationBloc>(
                    context,
                  ).state.locale.languageCode ==
                  'en',
              onTap: () {
                context.read<LocalizationBloc>().add(
                  ChangeLanguage(const Locale('en')),
                );
                Navigator.pop(context);
              },
            ),
            Gap(context.setHeight(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.setWidth(20),
          vertical: context.setHeight(15),
        ),
        decoration: BoxDecoration(
          color: isSelected ? HexColor('F5821F').withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? HexColor('F5821F')
                : Colors.grey[200] ?? Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: TextStyle(fontSize: context.setSp(20))),
            Gap(context.setWidth(15)),
            Text(
              title,
              style: TextStyle(
                fontSize: context.setSp(16),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? HexColor('F5821F') : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: HexColor('F5821F'), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileLoaded state) {
    final profile = state.profile;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        context.setWidth(20),
        context.topPadding + context.setHeight(20),
        context.setWidth(20),
        context.setHeight(40),
      ),
      decoration: BoxDecoration(
        color: HexColor('F5821F'),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.setWidth(30)),
          bottomRight: Radius.circular(context.setWidth(30)),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: context.setWidth(50),
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            backgroundImage: profile.profileImage.isNotEmpty
                ? CachedNetworkImageProvider(profile.profileImage)
                      as ImageProvider
                : const AssetImage('assets/images/businessman.png')
                      as ImageProvider,
          ),
          Gap(context.setWidth(15)),
          Text(
            profile.fullName,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.setSp(22),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            profile.email,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: context.setSp(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: context.setSp(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Gap(context.setHeight(10)),
        Container(
          padding: EdgeInsets.all(context.setWidth(15)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.setWidth(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: items.map((item) {
              int index = items.indexOf(item);
              return Column(
                children: [
                  item,
                  if (index != items.length - 1)
                    Divider(
                      color: Colors.grey[100],
                      height: context.setHeight(20),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: context.setWidth(20)),
        Gap(context.setWidth(10)),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: context.setSp(14),
          ),
        ),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.setSp(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(
    BuildContext context, {
    required String label,
    required bool isUploaded,
  }) {
    var l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.setSp(14),
          ),
        ),
        const Spacer(),
        if (isUploaded)
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: context.setWidth(16),
              ),
              Gap(context.setWidth(5)),
              Text(
                l10n?.translate('uploaded') ?? 'Uploaded',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: context.setSp(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: context.setWidth(16),
              ),
              Gap(context.setWidth(5)),
              Text(
                l10n?.translate('not_uploaded') ?? 'Not uploaded',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: context.setSp(12),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
