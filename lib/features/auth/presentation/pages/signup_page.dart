import 'package:blog_app/core/theme/pallete.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Signup",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                AuthField(hintText: "Email", controller: _emailController),
                SizedBox(height: 15),
                AuthField(hintText: "Name", controller: _nameController),
                SizedBox(height: 15),
                AuthField(
                  hintText: "Password",
                  controller: _passwordController,
                  isHide: true,
                ),
                SizedBox(height: 15),
                AuthButton(buttonText: "Signup"),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    text: "Already have an Account? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "Signin",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Pallete.gradient1,
                        ),
                      ),
                    ],
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
