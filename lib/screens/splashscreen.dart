import 'package:attendance/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';  

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>Login()), 
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
       
            Image.asset(
              'assets/logo.png',
              width: MediaQuery.of(context).size.height * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
            ),
          ],
        ),
      ),
    );
  }
}