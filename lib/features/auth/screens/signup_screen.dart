import 'package:flutter/material.dart';
import '../../../widgets/inputs/custom_input_field.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../navigation/bottom_nav.dart';

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
        (email.endsWith('.edu') || email.contains('university'));
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

    // ✅ SUCCESS → GO TO DASHBOARD
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNav()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Student Sign-Up",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            /// EMAIL
            CustomInputField(
              hint: "University Email",
              controller: _emailController,
            ),
            const SizedBox(height: 12),

            /// PASSWORD
            CustomInputField(
              hint: "Password",
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20),

            const Text(
              "Select Course",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

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
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    course,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),

            /// ERROR MESSAGE
            if (errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            const SizedBox(height: 20),

            /// SIGN UP BUTTON
            PrimaryButton(
              text: "Sign Up",
              onPressed: signUp,
            ),
          ],
        ),
      ),
    );
  }
}
