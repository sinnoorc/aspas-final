import 'package:aspas/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();

  getUserInfo() {
    FirebaseFirestore.instance.collection('User').doc(user!.uid).get().then((value) {
      // ignore: unnecessary_this
      this.userModel = UserModel.frmMap(value.data());
      setState(() {});
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   color: Theme.of(context).iconTheme.color,
          //   tooltip: 'Back',
          //   onPressed: () => Navigator.pop(context),
          //   icon: const Icon(CupertinoIcons.back),
          // ),
          centerTitle: true,
          title: Text(
            'Home',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text('${userModel.fullName}'),
              ElevatedButton(
                onPressed: () => logOut(context),
                child: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }
}
