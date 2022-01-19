import 'package:aspas/animation/fade_animation.dart';
import 'package:aspas/constants/app_style.dart';
import 'package:aspas/screen/login_screen.dart';
import 'package:aspas/screen/register_screen.dart';
import 'package:aspas/widget/change_theme_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 120.0),
                  child: Text(
                    "Welcome",
                    style: AppStyle.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 100,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "We are introducing a project based on entrance pass to keep track of all the vehicles that have entered the premises.",
                    style: AppStyle.kWelcomeTitle,
                    maxLines: 3,
                  ),
                ),
                // ChangeThemeButtonWidget(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                    onPressed: () => Navigator.push(context, ScaleRoute(page: const LoginScreen())),
                    child: const Text(
                      'Login',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account ?',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          ScaleRoute(
                            page: const RegisterScreen(),
                          )),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
