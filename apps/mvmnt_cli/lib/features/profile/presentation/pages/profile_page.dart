import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/profile/presentation/widgets/manage_account.dart';
import 'package:mvmnt_cli/ui/forms/custom_phone_field.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/alert_card.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/dismiss_keyboard.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occured'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return _ProfileView(
          key: Key("profile_view"),
          loading: state.status == ProfileStatus.loading,
          hasError: state.status == ProfileStatus.error,
          profile: state.profileEntity,
        );
      },
    );
  }
}

class _ProfileView extends StatefulWidget {
  final ProfileEntity? profile;
  final bool loading;
  final bool hasError;

  const _ProfileView({
    super.key,
    required this.profile,
    required this.loading,
    required this.hasError,
  });

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  String _selectedCountryCode = '';

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.profile?.firstName,
    );
    _lastNameController = TextEditingController(text: widget.profile?.lastName);
    if (widget.profile?.phone.countryCode.isNotEmpty ?? false) {
      _selectedCountryCode = widget.profile?.phone.countryCode ?? '+1';
    }
    _phoneNumberController = TextEditingController(
      text: widget.profile?.phone.number ?? '',
    );
    _emailController = TextEditingController(
      text: widget.profile?.email.address ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant _ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controllers if the profile has changed and was previously null
    if (widget.profile != null && oldWidget.profile != widget.profile) {
      _firstNameController.text = widget.profile!.firstName;
      _lastNameController.text = widget.profile!.lastName;
      if (widget.profile?.phone.countryCode.isNotEmpty ?? false) {
        _selectedCountryCode = widget.profile?.phone.countryCode ?? '+1';
      }
      _phoneNumberController.text = widget.profile!.phone.number;
      _emailController.text = widget.profile!.email.address;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildUpdatedProfileJson() {
    final Map<String, dynamic> updated = {};

    if (_firstNameController.text.trim().isNotEmpty &&
        _firstNameController.text.trim() != widget.profile?.firstName) {
      updated['first_name'] = _firstNameController.text.trim();
    }

    if (_lastNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim() != widget.profile?.lastName) {
      updated['last_name'] = _lastNameController.text.trim();
    }

    if ((_emailController.text.trim() != widget.profile!.email.address) &&
        (_emailController.text.trim().isNotEmpty)) {
      updated['email'] = {
        'address': _emailController.text.trim(),
        'verified': false,
      };
    }

    return updated;
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Profile',
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton(
                onPressed:
                    (widget.loading && !widget.hasError)
                        ? null
                        : () async {
                          context.read<ProfileCubit>().updateProfile(
                            _buildUpdatedProfileJson(),
                          );

                          if ((_selectedCountryCode !=
                                  widget.profile?.phone.countryCode ||
                              _phoneNumberController.text.trim() !=
                                  widget.profile?.phone.number)) {
                            String fullPhoneNumber =
                                '$_selectedCountryCode${_phoneNumberController.text.trim()}';
                            String encodedPhone = Uri.encodeComponent(
                              fullPhoneNumber,
                            );

                            await context.push(
                              '/profile/phone?phone_number=$encodedPhone',
                            );
                          }

                          // if (_emailController.text.trim() !=
                          //     widget.profile!.email.address) {
                          //   String encodedEmail = Uri.encodeComponent(
                          //     _emailController.text.trim(),
                          //   );

                          //   await context.push(
                          //     '/profile/email?emailAddress=$encodedEmail&isNew=${true}',
                          //   );
                          // }
                        },
                child:
                    widget.loading
                        ? CircularProgressIndicator.adaptive()
                        : Text('Save'),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: CustomTextField(
                              enabled: !widget.loading,
                              label: "First Name",
                              controller: _firstNameController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 1,
                            child: CustomTextField(
                              enabled: !widget.loading,
                              label: "Last Name",
                              controller: _lastNameController,
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        enabled: !widget.loading,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        verified: (widget.profile?.email.verified ?? false),
                        controller: _emailController,
                      ),
                      // if (widget.profile?.email != null &&
                      //     (widget.profile?.email.address.isNotEmpty ?? false) &&
                      //     (widget.profile?.email.verified == false)) ...[
                      //   AlertCard(
                      //     alertText: 'Please verify email address',
                      //     onTap: () {
                      //       String encodedEmail = Uri.encodeComponent(
                      //         widget.profile!.email.address,
                      //       );

                      //       context.push(
                      //         '/profile/email?emailAddress=$encodedEmail&isNew=${false}',
                      //       );
                      //     },
                      //   ),
                      // ],
                      CustomPhoneField(
                        enabled: !widget.loading,
                        verified: widget.profile?.phone.verified ?? false,
                        selectedCountryCode: _selectedCountryCode,
                        phoneNumberController: _phoneNumberController,
                        onCountryChanged: (value) {
                          setState(() {
                            _selectedCountryCode = value;
                          });
                        },
                      ),
                      if (widget.profile?.phone != null &&
                          (widget.profile?.phone.fullNumber.isNotEmpty ??
                              false) &&
                          (widget.profile?.phone.verified == false)) ...[
                        AlertCard(
                          alertText: 'Please verify phone number',
                          onTap: () {
                            String encodedPhone = Uri.encodeComponent(
                              widget.profile!.phone.fullNumber,
                            );

                            context.push(
                              '/profile/phone?phone_number=$encodedPhone',
                            );
                          },
                        ),
                      ],
                    ],
                  ),

                  // if (widget.profile != null &&
                  //     !widget.profile!.phone.verified) ...[
                  //   InfoCard(info: 'info'),
                  // ],
                  SizedBox(height: 30),
                  ManageAccount(enabled: !widget.loading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
