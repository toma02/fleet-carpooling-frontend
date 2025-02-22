import 'package:core/ui_elements/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/auth_login.dart';
import 'package:fleetcarpooling/screens/admin/admin_home_page.dart';
import 'package:fleetcarpooling/screens/login/reset_password_form.dart';
import 'package:core/ui_elements/colors';
import 'package:core/ui_elements/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fleetcarpooling/ui_elements/navigation.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool? logged;
  bool? adminIsLogged;
  String? errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo_login.png',
                  width: 320,
                  height: 220,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "FLEET CARPOOLING",
                  style:
                      TextStyle(color: AppColors.mainTextColor, fontSize: 32.0),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "SIGN IN TO CONTINUE",
                  style:
                      TextStyle(color: AppColors.mainTextColor, fontSize: 24.0),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email or Username",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  ),
                ),
                const SizedBox(height: 3.0),
                MyTextField(
                  controller: emailController,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 15.0),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(color: AppColors.mainTextColor),
                    ),
                  ),
                ),
                MyTextField(
                  controller: passwordController,
                  isPassword: true,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 3.0),
                MyElevatedButton(
                  key: UniqueKey(),
                  onPressed: () async {
                    setState(() {
                      logged = null;
                      errorMessage = null;
                      isLoading = true;
                    });

                    logged = await AuthLogin(
                            FirebaseDatabase.instance, FirebaseAuth.instance)
                        .login(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    setState(() {
                      isLoading = false;
                    });

                    if (logged == true) {
                      adminIsLogged = await AuthLogin(
                              FirebaseDatabase.instance, FirebaseAuth.instance)
                          .isAdmin();
                      if (adminIsLogged == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminHomePage(),
                          ),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigationPage(
                                returnTime: DateTime.now(),
                                pickupTime: DateTime.now()),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        errorMessage =
                            'Login failed. Please check your credentials.';
                      });
                    }
                  },
                  label: "Login",
                  isLoading: isLoading,
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ResetPasswordForm();
                    }));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ),
                if (logged == false && errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
