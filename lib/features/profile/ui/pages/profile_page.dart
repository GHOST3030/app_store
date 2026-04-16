// profile/ui/pages/profile_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/core/widgets/shared_text_field.dart';
import 'package:new_auth/features/profile/logic/entities/profile_entity.dart';
import '../../logic/providers/profile_providers.dart';
import '../widgets/change_password_dialog.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _ifscController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).fetchProfile();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _bankAccountController.dispose();
    _accountHolderController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  void _updateControllersFromProfile() {
    final profile = ref.read(profileNotifierProvider).profile;
    if (profile != null) {
      _emailController.text = profile.email;
      _passwordController.text = profile.password;
      _addressController.text = profile.address;
      _cityController.text = profile.city;
      _countryController.text = profile.country;
      _pincodeController.text = profile.pincode;
      _bankAccountController.text = profile.bankAccountNumber;
      _accountHolderController.text = profile.accountHolderName;
      _ifscController.text = profile.ifscCode;
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final currentProfile = ref.read(profileNotifierProvider).profile;
      if (currentProfile == null) return;
      final updatedProfile = ProfileEntity(
        id: currentProfile.id,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        pincode: _pincodeController.text.trim(),
        bankAccountNumber: _bankAccountController.text.trim(),
        accountHolderName: _accountHolderController.text.trim(),
        ifscCode: _ifscController.text.trim(),
        createdAt: currentProfile.createdAt,
      );
      ref.read(profileNotifierProvider.notifier).updateProfile(updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final profile = profileState.profile;

    if (profileState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgGrey,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: const Text(
            'Profile & Checkout',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (profileState.error != null && profile == null) {
      log(profileState.error!);
      return Scaffold(
        backgroundColor: AppColors.bgGrey,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: const Text(
            'Profile & Checkout',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textDark),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),

              Text(
                'Error: ${profileState.error}',
                style: const TextStyle(color: AppColors.textDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(profileNotifierProvider.notifier).fetchProfile(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (profile != null) {
      _updateControllersFromProfile();
    }

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Profile & Checkout',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Personal Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSectionHeader(
                      'Personal Details',
                      Icons.person_outline,
                    ),
                    SharedTextField(
                      controller: _emailController,
                      hintText: 'hello@example.com',
                      labelText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Email is required';
                        if (!value.contains('@') || !value.contains('.'))
                          return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SharedTextField(
                      controller: _passwordController,
                      hintText: '••••••',
                      labelText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onSuffixIconTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Password is required';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          if (profile != null) {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  ChangePasswordDialog(currentProfile: profile),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.lock_reset,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        label: const Text(
                          'Change Password',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Address Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSectionHeader(
                      'Delivery Address',
                      Icons.location_on_outlined,
                    ),
                    SharedTextField(
                      controller: _addressController,
                      labelText: 'Street Address',
                      prefixIcon: Icons.home_outlined,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Address is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SharedTextField(
                            controller: _cityController,
                            labelText: 'City',
                            prefixIcon: Icons.location_city_outlined,
                            validator: (value) => value == null || value.isEmpty
                                ? 'City required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SharedTextField(
                            controller: _pincodeController,
                            labelText: 'Pincode',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.pin_drop_outlined,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Pincode required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SharedTextField(
                      controller: _countryController,
                      labelText: 'Country',
                      prefixIcon: Icons.public_outlined,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Country is required'
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bank Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSectionHeader(
                      'Bank Details',
                      Icons.account_balance_outlined,
                    ),
                    SharedTextField(
                      controller: _accountHolderController,
                      labelText: 'Account Name',
                      prefixIcon: Icons.person_pin_outlined,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Account name required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    SharedTextField(
                      controller: _bankAccountController,
                      labelText: 'Account Number',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.numbers_outlined,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Account number required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    SharedTextField(
                      controller: _ifscController,
                      labelText: 'IFSC Code',
                      prefixIcon: Icons.account_balance_wallet_outlined,
                      validator: (value) => value == null || value.isEmpty
                          ? 'IFSC code required'
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: profileState.isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.authButton,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: profileState.isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              if (profileState.error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          profileState.error!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
