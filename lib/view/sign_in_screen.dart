import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/controller/auth_controller.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final c = Get.find<AuthController>();
    final ok = await c.signIn(_email.text, _password.text);
    if (ok && mounted) {
      Get.offAllNamed(Routes.dashboard);
    }
  }

  Future<void> _forgotPassword() async {
    final emailCtl = TextEditingController(text: _email.text);
    final email = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset password'),
        content: TextField(
          controller: emailCtl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'you@example.com',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, emailCtl.text),
            child: const Text('Send link'),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !mounted) return;
    final c = Get.find<AuthController>();
    final ok = await c.sendPasswordReset(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? 'Password reset email sent.'
          : (c.error.value ?? 'Failed to send reset email.')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: AppColors.heroGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.coronavirus,
                            size: 48, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text('Welcome back',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text('Sign in to continue',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14)),
                    ),
                    const SizedBox(height: 32),
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
                      hint: 'Your password',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Password is required' : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: const Text('Forgot password?',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                            : const Text('Sign in',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ",
                            style: TextStyle(
                                color: AppColors.textSecondary)),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.signUp),
                          child: const Text('Sign up',
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
