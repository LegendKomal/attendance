import 'dart:math';

import 'package:attendance/screens/emp_list.dart';
import 'package:attendance/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  TimeOfDay _loginTime = TimeOfDay.now();
  TimeOfDay _logoutTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(screenWidth * 0.08),
                  bottomRight: Radius.circular(screenWidth * 0.08),
                ),
              ),
            ),
          ),
          // Centered sign-up form
          Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Form(
                key: _formKey,
                child: Container(
                  width: screenWidth * 0.75,
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: screenWidth * 0.01,
                        blurRadius: screenWidth * 0.02,
                        offset: Offset(0, screenHeight * 0.01),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@') || !value.endsWith('@gmail.com')) {
                            return 'Please enter a valid email with "@gmail.com"';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password should be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _selectLoginTime(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: _loginTime.format(context)),
                                  decoration: InputDecoration(
                                    hintText: 'Login Time',
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _selectLogoutTime(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: TextEditingController(
                                      text: _logoutTime.format(context)),
                                  decoration: InputDecoration(
                                    hintText: 'Logout Time',
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _registerUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.15,
                          ),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.08),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectLoginTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _loginTime,
    );
    if (pickedTime != null) {
      setState(() {
        _loginTime = pickedTime;
      });
    }
  }

  void _selectLogoutTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _logoutTime,
    );
    if (pickedTime != null) {
      setState(() {
        _logoutTime = pickedTime;
      });
    }
  }

  String _generateEmployeeId() {
    final random = Random();
    const String chars = '0123456789';
    final StringBuffer buffer = StringBuffer('EMP');

    for (int i = 0; i < 4; i++) {
      buffer.write(chars[random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  void _registerUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final loginTime = _loginTime.format(context);
    final logoutTime = _logoutTime.format(context);
    final employeeId = _generateEmployeeId();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final empList = await prefs.getStringList('empList') ?? [];


      final employeeDetails = '$name - $email - $employeeId';
      empList.add(employeeDetails);

      await prefs.setStringList('empList', empList);
      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setString('loginTime', loginTime);
      await prefs.setString('logoutTime', logoutTime);
      await prefs.setString('employeeId_$email', employeeId);

      Fluttertoast.showToast(
        msg: 'Registration successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Please enter all details',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
