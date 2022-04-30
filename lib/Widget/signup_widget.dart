import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookmarker1/main.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  String userEmail = '';
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                child: Image.asset(
                  'images/bookmarker.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Let\'s Start Here',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  userEmail = value;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                onChanged: (value) {
                  password = value;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 8
                    ? 'Enter minimum 8 characters'
                    : null,
              ),
              const SizedBox(height: 5),
              TextFormField(
                onChanged: (value) {
                  confirmPassword = value;
                },
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                ),
                obscureText: true,
                validator: (value) => confirmPassword != password
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: signUp,
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                ),
                label: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 25.0),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50.0),
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20.0,
                  ),
                  text: 'Already have an account? ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.message != null) {
        final snackBar = SnackBar(content: Text(e.message!));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
