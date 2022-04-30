import 'package:flutter/material.dart';
import 'package:bookmarker1/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:bookmarker1/Page/forgot_password_page.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String userEmail = '';
  String password = '';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
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
              'Hello,\n Welcome Back!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
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
              cursorColor: Colors.black45,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black45,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45.0),
              ),
              icon: const Icon(
                Icons.lock_open,
                size: 30,
              ),
              label: const Text(
                'Sign In',
                style: TextStyle(fontSize: 25),
              ),
              onPressed: signIn,
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                ),
                text: 'No account? ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Sign Up',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              child: const Text(
                'Forgot your password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueGrey,
                  fontSize: 20,
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                ),
              ),
            ),
          ],
        ),
      );

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      final snackBar = SnackBar(content: Text(e.message!));
      if (e.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
