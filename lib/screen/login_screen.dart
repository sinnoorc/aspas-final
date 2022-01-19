import 'dart:math';

import 'package:aspas/animation/fade_animation.dart';
import 'package:aspas/screen/register_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            color: Theme.of(context).iconTheme.color,
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back),
          ),
          centerTitle: true,
          title: Text(
            'Login',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: LottieBuilder.asset('assets/json/two-factor-authentication.json'),
                  ),
                ),
                const SizedBox(height: 70),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          hintText: 'someone@email.com',
                        ),
                        controller: emailController,
                        validator: (email) => email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Password'),
                          hintText: 'Enter Your Password',
                        ),
                        controller: passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Enter a valid password';
                          } else if (password.length < 6) {
                            return 'Must be at least 6 characters long';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                    final form = _formKey.currentState!;

                    if (form.validate()) {
                      print('Validated');
                      logIn(emailController.text, passwordController.text);
                    }
                  },
                  child: const Text('Login'),
                ),
                // const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.push(context, ScaleRoute(page: const RegisterScreen())),
                  child: const Text('Register'),
                ),
                // ChangeThemeButtonWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              Fluttertoast.showToast(msg: 'Login Successful'),
              Navigator.pushNamed(context, '/home'),
            })
        .catchError((error) {
      Fluttertoast.showToast(msg: error!.message);
    });
  }
}
