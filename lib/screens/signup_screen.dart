import 'package:flutter/material.dart';
import '../widgets/inputs/custom_input_field.dart';
import '../widgets/buttons/primary_button.dart';
import '../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedCourse;
  String? errorMessage;

  final List<String> courses = [
    "Mobile App Development (Flutter)",
    "Introduction to Linux",
    "Web Development",
  ];

  bool isUniversityEmail(String email) {
    return email.contains('@') &&
        (email.endsWith('.edu') ||
            email.contains('university') ||
            email.contains('alustudent.com'));
  }

  void signUp() {
    final email = _emailController.text.trim();

    if (email.isEmpty || !isUniversityEmail(email)) {
      setState(() {
        errorMessage = "Please use a valid university email";
      });
      return;
    }

    if (selectedCourse == null) {
      setState(() {
        errorMessage = "Please select a course";
      });
      return;
    }

    // Success → Navigate to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
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
                "Select Course",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              /// COURSES
              ...courses.map((course) {
                final isSelected = selectedCourse == course;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCourse = course;
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
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
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
              PrimaryButton(
                text: "Sign Up",
                onPressed: signUp,
              ),

              const SizedBox(height: 16),

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
