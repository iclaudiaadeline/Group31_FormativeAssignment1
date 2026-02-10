import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/inputs/custom_input_field.dart';
import '../widgets/buttons/primary_button.dart';
import '../providers/auth_provider.dart';
import '../main.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  void login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = "Please enter your email";
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        errorMessage = "Please enter your password";
      });
      return;
    }

    // Show loading indicator
    setState(() {
      errorMessage = null;
    });

    // Sign in with Firebase Auth
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signIn(
      email: email,
      password: password,
    );

    if (success && mounted) {
      // Success → Navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else if (mounted) {
      // Show error from auth provider
      setState(() {
        errorMessage = authProvider.error ?? "Login failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Center(
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "ALU Academic Platform",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              /// EMAIL
              CustomInputField(
                hint: "Email",
                controller: _emailController,
              ),
              const SizedBox(height: 16),

              /// PASSWORD
              CustomInputField(
                hint: "Password",
                isPassword: true,
                controller: _passwordController,
              ),

              /// ERROR MESSAGE
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              /// LOGIN BUTTON
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return PrimaryButton(
                    text: authProvider.isLoading ? "Logging in..." : "Login",
                    onPressed: authProvider.isLoading ? () {} : login,
                  );
                },
              ),

              const SizedBox(height: 16),

              /// SIGN UP LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),

              /// SKIP FOR NOW (Development only)
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
