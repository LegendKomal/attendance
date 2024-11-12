import 'package:attendmate/screens/date_screen.dart';
import 'package:attendmate/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blue top half background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
            ),
          ),
          // Centered login form
          Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.of(context).size.height * 0.25,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  _buildLoginForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text('OR', style: TextStyle(color: Colors.black54)),
                  TextButton(
                    onPressed: _navigateToSignUpPage,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.redAccent,
                       fontSize: MediaQuery.of(context).size.height * 0.025),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'LOGIN',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'example@example.com',
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: '********',
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ElevatedButton(
            onPressed: _loginUser,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.016, 
              horizontal: MediaQuery.of(context).size.height * 0.06),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text(
              'LOGIN',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, 
              color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('email');
      final storedPassword = prefs.getString('password');

     if (email == storedEmail && password == storedPassword) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => DateScreen()),
  );
      } else {
        Fluttertoast.showToast(
          msg: "Invalid email or password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: MediaQuery.of(context).size.height * 0.02,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please enter email and password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: MediaQuery.of(context).size.height * 0.02,
      );
    }
  }

  void _navigateToSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signup()),
    );
  }
}
