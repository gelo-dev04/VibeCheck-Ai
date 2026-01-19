import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibecheck_ai/theme.dart';
import 'package:vibecheck_ai/state.dart';
import 'package:vibecheck_ai/widgets/glass_input.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppColors.skyBlue.withValues(alpha: 0.1)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 48),
                  _buildSignupForm(),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 1.seconds).slideX(begin: 0.1, end: 0),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Join VibeCheck',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: AppColors.slate800,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'MAP YOUR EMOTIONAL UNIVERSE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppColors.slate600,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Column(
      children: [
        GlassWidget(
          blur: 10,
          borderRadius: BorderRadius.circular(44),
          decoration: GlassDecoration(
            borderRadius: BorderRadius.circular(44),
            border: Border.all(color: Colors.white),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const GlassInput(label: 'FULL NAME', hint: 'Archie Vibe'),
                const SizedBox(height: 20),
                const GlassInput(
                  label: 'NEURAL IDENTITY',
                  hint: 'email@vibe.ai',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const GlassInput(
                  label: 'SET FREQUENCY KEY',
                  hint: '••••••••',
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                _buildInitializeButton(),
                const SizedBox(height: 24),
                _buildGoogleButton(),
                const SizedBox(height: 32),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitializeButton() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: () => AppState.login(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sky600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        child: const Text(
          'INITIALIZE PROFILE',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          side: BorderSide(color: Colors.grey.shade200),
          backgroundColor: Colors.white.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
              height: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              'Sign up with Google',
              style: TextStyle(
                color: AppColors.slate600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => AppState.navigateTo(AppScreen.login),
      child: const Text(
        'BACK TO SYNC ←',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: AppColors.slate600,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
