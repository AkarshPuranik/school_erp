import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/components/plain_background.dart';
import 'package:school_erp/screens/login_screens/user_screen.dart';

import '../model/user_model.dart';
import 'student_screens/home_screen.dart';
import 'login_screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Box<UserModel> userBox = Hive.box<UserModel>('users');

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => userBox.values.isNotEmpty
                  ? const HomeScreen()
                  : const UserScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D83C6),
      body: SafeArea(
        child: Stack(
          children: [
            const PlainBackground(),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 5),
              child: Image.asset(
                "assets/school_erp_logo.png",
                height: MediaQuery.of(context).size.width / 5,
              ),
            ),
            Positioned(
              bottom: 60.0,
              right: 20.0,
              child: Image.asset(
                "assets/school_erp_vector.png",
                width: MediaQuery.of(context).size.width * 1.5,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
