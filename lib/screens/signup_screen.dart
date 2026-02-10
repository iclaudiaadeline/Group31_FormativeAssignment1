import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/inputs/custom_input_field.dart';
import '../widgets/buttons/primary_button.dart';
import '../providers/auth_provider.dart';
import '../main.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Set<String> selectedCourses = {}; // Changed to Set for multiple selection
  String? errorMessage;

  final List<String> courses = [
    "Mobile App Development (Flutter)",
    "Introduction to Linux",
    "Web Development",
    "Data Structures and Algorithms",
    "Database Management Systems",
    "Software Engineering",
  ];

  bool isUniversityEmail(String email) {
    return email.contains('@') &&
        (email.endsWith('.edu') ||
            email.contains('university') ||
            email.contains('alustudent.com'));
  }

  void signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !isUniversityEmail(email)) {
      setState(() {
        errorMessage = "Please use a valid university email";
      });
      return;
    }

    if (password.isEmpty || password.length < 6) {
      setState(() {
        errorMessage = "Password must be at least 6 characters";
      });
      return;
    }

    if (selectedCourses.isEmpty) {
      setState(() {
        errorMessage = "Please select at least one course";
      });
      return;
    }

    // Show loading indicator
    setState(() {
      errorMessage = null;
    });

    // Sign up with Firebase Auth
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      email: email,
      password: password,
      courses: selectedCourses.toList(), // Pass list of courses
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
        errorMessage = authProvider.error ?? "Sign up failed";
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Student Sign-Up",
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
                hint: "University Email",
                controller: _emailController,
              ),
              const SizedBox(height: 16),

              /// PASSWORD
              CustomInputField(
                hint: "Password",
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 24),

              const Text(
                "Select Courses (one or more)",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              /// COURSES - Multiple selection
              ...courses.map((course) {
                final isSelected = selectedCourses.contains(course);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedCourses.remove(course);
                      } else {
                        selectedCourses.add(course);
                      }
                      errorMessage = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            course,
                            style: TextStyle(
                              color: isSelected ? Colors.white : null,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              /// ERROR MESSAGE
              if (errorMessage != null) ...[
                const SizedBox(height: 12),
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

              /// SIGN UP BUTTON
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return PrimaryButton(
                    text: authProvider.isLoading ? "Signing up..." : "Sign Up",
                    onPressed: authProvider.isLoading ? () {} : signUp,
                  );
                },
              ),

              const SizedBox(height: 16),

              /// LOGIN LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text("Login"),
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
