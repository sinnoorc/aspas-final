import 'package:aspas/animation/fade_animation.dart';
import 'package:aspas/model/user.dart';
import 'package:aspas/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

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
            'Register',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Full Name'),
                        suffix: Icon(Icons.person_outlined),
                        hintText: "Enter Your Name",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (name) {
                        if (name == null || name.isEmpty) {
                          return 'Enter a your name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Mobile Number'),
                        prefix: Text('+91 '),
                        hintText: "Enter Your Mobile Number",
                        suffix: Icon(Icons.phone_android_outlined),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (mobile) {
                        if (mobile == null || mobile.isEmpty) {
                          return 'Enter a your mobile number';
                        } else if (mobile.length < 10) {
                          return 'Enter valid mobile number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        hintText: 'someone@email.com',
                        suffix: Icon(Icons.email_outlined),
                      ),
                      validator: (email) => email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Password'),
                          hintText: "Enter New Password",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Enter a valid password';
                          } else if (password.length < 6) {
                            return 'Must be at least 6 characters long';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 10),
                    TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Confirm password'),
                          hintText: "Re-Enter New Password",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: cpasswordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Enter valid confirm  password';
                          } else if (password.length < 6) {
                            return 'Must be at least 6 characters long';
                          } else if (passwordController.text != cpasswordController.text) {
                            return 'Password must be same as above';
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                      onPressed: () {
                        final form = _formKey.currentState!;
                        if (form.validate()) {
                          register(emailController.text, cpasswordController.text);
                        }
                      },
                      child: const Text('Register'),
                    ),
                    // const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.push(context, ScaleRoute(page: const LoginScreen())),
                      child: const Text('Login'),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void register(String email, String password) async {
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              sendToFirebase(),
            })
        .catchError((error) {
      Fluttertoast.showToast(msg: error!.message);
    });
  }

  sendToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = nameController.text;
    userModel.mobile = mobileController.text;

    await firebaseFirestore.collection('User').doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: 'Account created successfully');
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}
