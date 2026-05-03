import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/auth_controller.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final c = Get.find<AuthController>();
    final ok = await c.signUp(_email.text, _password.text);
    if (ok && mounted) {
      Get.offAllNamed(Routes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: AppColors.heroGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_add_alt_1_rounded,
                            size: 36, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text('Create account',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text('Get started in a few seconds',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14)),
                    ),
                    const SizedBox(height: 28),
                    if (c.error.value != null) _errorBanner(c.error.value!),
                    if (c.error.value != null) const SizedBox(height: 12),
                    _label('Email'),
                    _input(
                      controller: _email,
                      hint: 'you@example.com',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!v.contains('@') || !v.contains('.')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _label('Password'),
                    _input(
                      controller: _password,
                      hint: 'At least 6 characters',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 6) return 'At least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _label('Confirm password'),
                    _input(
                      controller: _confirm,
                      hint: 'Repeat password',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscureConfirm,
                      suffix: IconButton(
                        icon: Icon(_obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (v) =>
                          v != _password.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: c.isLoading.value ? null : _submit,
                        child: c.isLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Text('Sign up',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ',
                            style: TextStyle(
                                color: AppColors.textSecondary)),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text('Sign in',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 13)),
      );

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.textSecondary),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _errorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                    color: AppColors.danger, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
