import 'package:core/ui_elements/buttons.dart';
import 'package:fleetcarpooling/services/user_repository.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:core/ui_elements/text_field.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});
  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 70,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            "RESET PASSWORD",
            style: TextStyle(color: AppColors.mainTextColor),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircularIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 0.5,
          ),
        ),
      ),
      body: Container(
          color: AppColors.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Enter your email to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 10.0),
              MyTextField(
                controller: emailController,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 10.0),
              MyElevatedButton(
                onPressed: () async {
                  try {
                    await UserRepository().passwordReset(emailController.text);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Password reset email sent successfully'),
                    ));
                  } catch (e) {
                    // ignore: avoid_print
                    print("Error sending password reset email: $e");
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Error sending password reset email. Please try again later.'),
                    ));
                  }
                },
                label: "Reset Password",
              ),
            ],
          )),
    );
  }
}
