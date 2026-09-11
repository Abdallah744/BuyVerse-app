import 'dart:io';

import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/profile/profile_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/map_picker.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data_layer/admin/admin_models/profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final storeLocationController = TextEditingController();

  String? profileImagePath;
  String? commercialRegisterPath;
  String? taxCardPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      final profile = profileState.profile;
      nameController.text = profile.fullName;
      emailController.text = profile.email;
      phoneController.text = profile.phone;
      idController.text = profile.nationalId;
      businessNameController.text = profile.businessName;
      businessAddressController.text = profile.businessAddress;
      storeLocationController.text = profile.storeLocation;
    }
  }

  Future<void> _pickDocument(String type) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (image != null) {
      setState(() {
        if (type == 'commercial') commercialRegisterPath = image.path;
        if (type == 'tax') taxCardPath = image.path;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (image != null) {
      setState(() {
        profileImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          showToast(
            context: context,
            text: l10n?.translate('success') ?? 'Profile Updated',
            state: ToastStates.SUCCESS,
          );
          Navigator.pop(context);
        }
        if (state is ProfileError) {
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
            title: l10n?.translate('edit_profile') ?? 'Edit Profile',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(context.setWidth(20.0)),
              child: Column(
                children: [
                  if (state is ProfileLoading) const LinearProgressIndicator(),
                  _buildAvatarSection(context, state),
                  Gap(context.setWidth(30)),
                  _buildFields(context),
                  Gap(context.setWidth(30)),
                  defaultButton(
                    context: context,
                    function: () {
                      if (state is ProfileLoaded) {
                        context.read<ProfileBloc>().add(
                          UpdateProfile(
                            profile: UserProfile(
                              uId: state.profile.uId,
                              fullName: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              nationalId: idController.text,
                              businessName: businessNameController.text,
                              businessAddress: businessAddressController.text,
                              storeLocation: storeLocationController.text,
                              profileImage: state.profile.profileImage,
                              commercialRegisterUrl:
                                  state.profile.commercialRegisterUrl,
                              taxCardUrl: state.profile.taxCardUrl,
                            ),
                            profileImagePath: profileImagePath,
                            commercialRegisterPath: commercialRegisterPath,
                            taxCardPath: taxCardPath,
                          ),
                        );
                      }
                    },
                    text: '',
                    widget: state is ProfileLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            l10n?.translate('save') ?? 'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.setSp(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    background: HexColor('F5821F'),
                    radius: 20,
                  ),
                  Gap(context.setWidth(20)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarSection(BuildContext context, ProfileState state) {
    var l10n = AppLocalizations.of(context);
    String? currentImageUrl;
    if (state is ProfileLoaded) {
      currentImageUrl = state.profile.profileImage;
    }

    ImageProvider? imageProvider;
    if (profileImagePath != null) {
      imageProvider = FileImage(File(profileImagePath!));
    } else if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
      imageProvider = CachedNetworkImageProvider(currentImageUrl);
    } else {
      imageProvider = const AssetImage('assets/images/businessman.png');
    }

    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: context.setWidth(50),
                backgroundImage: imageProvider,
              ),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(context.setWidth(2)),
                  child: CircleAvatar(
                    radius: context.setWidth(15),
                    backgroundColor: HexColor('F5821F'),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: context.setWidth(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(context.setWidth(10)),
          TextButton(
            onPressed: _pickImage,
            child: Text(
              l10n?.translate('pick_image') ?? 'Change Photo',
              style: TextStyle(
                color: HexColor('F5821F'),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFields(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    String optionalStr = '(${l10n?.translate('optional') ?? 'Optional'})';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(l10n?.translate('full_name') ?? 'Full Name', context),
        defaultTextFormField(
          context: context,
          controller: nameController,
          type: TextInputType.name,
          validate: (value) {
            if (value!.isEmpty) {
              return l10n?.translate('name_required') ??
                  'Name must not be empty';
            }
            return null;
          },
          label: '',
          hint: l10n?.translate('full_name') ?? 'Enter your full name',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(l10n?.translate('email') ?? 'Email', context),
        emailTextFormField(
          context: context,
          controller: emailController,
          type: TextInputType.emailAddress,
          validate: (value) {
            if (value!.isEmpty) {
              return l10n?.translate('email_required') ??
                  'Email must not be empty';
            }
            return null;
          },
          label: '',
          hint: l10n?.translate('email') ?? 'Enter your email',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(l10n?.translate('phone') ?? 'Phone', context),
        defaultTextFormField(
          context: context,
          controller: phoneController,
          type: TextInputType.phone,
          validate: (value) {
            if (value!.isEmpty) {
              return l10n?.translate('phone_required') ??
                  'Phone must not be empty';
            }
            return null;
          },
          label: '',
          hint: l10n?.translate('phone') ?? 'Enter your phone number',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(
          l10n?.translate('national_id') ?? 'National ID',
          context,
        ),
        defaultTextFormField(
          context: context,
          controller: idController,
          type: TextInputType.number,
          validate: (value) {
            if (value!.isEmpty) {
              return l10n?.translate('id_required') ?? 'ID must not be empty';
            }
            return null;
          },
          label: '',
          hint: l10n?.translate('national_id') ?? 'Enter your national ID',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(
          l10n?.translate('business_name') ?? 'Business Name',
          context,
        ),
        defaultTextFormField(
          context: context,
          controller: businessNameController,
          type: TextInputType.text,
          validate: (value) {
            if (value!.isEmpty) {
              return l10n?.translate('business_name_required') ??
                  'Business name must not be empty';
            }
            return null;
          },
          label: '',
          hint: l10n?.translate('business_name') ?? 'Enter your business name',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(
          '${l10n?.translate('business_address') ?? 'Business Address'} $optionalStr',
          context,
        ),
        defaultTextFormField(
          context: context,
          controller: businessAddressController,
          type: TextInputType.streetAddress,
          validate: (value) => null,
          label: '',
          hint:
              l10n?.translate('business_address') ??
              'Enter your business address',
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(
          '${l10n?.translate('store_location') ?? 'Store Location'} $optionalStr',
          context,
        ),
        _buildClickableField(
          context: context,
          icon: Icons.location_on_outlined,
          text: storeLocationController.text.isEmpty
              ? l10n?.translate('location_required') ??
                    'Tap to set store location'
              : storeLocationController.text,
          color: HexColor('F5821F').withValues(alpha: 0.1),
          textColor: HexColor('F5821F'),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapPickerScreen()),
            );
            if (result != null) {
              setState(() {
                storeLocationController.text = result;
              });
            }
          },
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(
          '${l10n?.translate('commercial_register') ?? 'Commercial Register'} $optionalStr',
          context,
        ),
        _buildFileField(
          context: context,
          text: commercialRegisterPath != null
              ? l10n?.translate('uploaded') ?? 'New file selected'
              : (context.read<ProfileBloc>().state is ProfileLoaded &&
                    (context.read<ProfileBloc>().state as ProfileLoaded)
                        .profile
                        .commercialRegisterUrl
                        .isNotEmpty &&
                    (context.read<ProfileBloc>().state as ProfileLoaded)
                            .profile
                            .commercialRegisterUrl !=
                        'null')
              ? l10n?.translate('uploaded') ?? 'Commercial Register uploaded'
              : l10n?.translate('pick_file') ?? 'Upload Commercial Register',
          isUploaded:
              commercialRegisterPath != null ||
              (context.read<ProfileBloc>().state is ProfileLoaded &&
                  (context.read<ProfileBloc>().state as ProfileLoaded)
                      .profile
                      .commercialRegisterUrl
                      .isNotEmpty &&
                  (context.read<ProfileBloc>().state as ProfileLoaded)
                          .profile
                          .commercialRegisterUrl !=
                      'null'),
          onTap: () => _pickDocument('commercial'),
          onDelete: () {
            setState(() {
              commercialRegisterPath = null;
            });
          },
        ),
        Gap(context.setWidth(15)),
        _buildFieldLabel(
          '${l10n?.translate('tax_card') ?? 'Tax Card'} $optionalStr',
          context,
        ),
        _buildFileField(
          context: context,
          text: taxCardPath != null
              ? l10n?.translate('uploaded') ?? 'New file selected'
              : (context.read<ProfileBloc>().state is ProfileLoaded &&
                    (context.read<ProfileBloc>().state as ProfileLoaded)
                        .profile
                        .taxCardUrl
                        .isNotEmpty &&
                    (context.read<ProfileBloc>().state as ProfileLoaded)
                            .profile
                            .taxCardUrl !=
                        'null')
              ? l10n?.translate('uploaded') ?? 'Tax Card uploaded'
              : l10n?.translate('pick_file') ?? 'Upload Tax Card',
          isUploaded:
              taxCardPath != null ||
              (context.read<ProfileBloc>().state is ProfileLoaded &&
                  (context.read<ProfileBloc>().state as ProfileLoaded)
                      .profile
                      .taxCardUrl
                      .isNotEmpty &&
                  (context.read<ProfileBloc>().state as ProfileLoaded)
                          .profile
                          .taxCardUrl !=
                      'null'),
          onTap: () => _pickDocument('tax'),
          onDelete: () {
            setState(() {
              taxCardPath = null;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.setWidth(8.0),
        left: context.setWidth(5.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: context.setSp(14),
        ),
      ),
    );
  }

  Widget _buildClickableField({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.setWidth(15),
          vertical: context.setWidth(15),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(context.setWidth(15)),
          border: Border.all(color: textColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: context.setWidth(20)),
            Gap(context.setWidth(10)),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileField({
    required BuildContext context,
    required String text,
    required bool isUploaded,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.setWidth(15),
          vertical: context.setWidth(15),
        ),
        decoration: BoxDecoration(
          color: isUploaded
              ? HexColor('F5821F').withValues(alpha: 0.05)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(context.setWidth(15)),
          border: isUploaded
              ? Border.all(color: HexColor('F5821F').withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isUploaded
                  ? Icons.check_circle_outline
                  : Icons.upload_file_outlined,
              color: isUploaded ? HexColor('F5821F') : Colors.grey,
              size: context.setWidth(20),
            ),
            Gap(context.setWidth(10)),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isUploaded ? HexColor('F5821F') : Colors.grey[600],
                  fontWeight: isUploaded ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isUploaded)
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.close,
                  size: context.setWidth(18),
                  color: Colors.grey,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }
}
