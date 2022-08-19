import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../models/http_exception.dart';

enum AuthMode { signup, login }

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final purpleColor = Color(0xff6688FF);

  final darkTextColor = Color(0xff1F1A3D);

  final lightTextColor = Color(0xff999999);

  final textFieldColor = Color(0xffF5F6FA);

  final borderColor = Color(0xffD9D9D9);

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.signup;
  final Map<String, String> _authData = {
    'name': '',
    'email': '',
    'phone': '',
    'password': '',
  };

  var _isLoading = false;

  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    print("form : $_authData");

    try {
      // user login
      if (_authMode == AuthMode.login) {
        await Provider.of<AuthProvider>(context, listen: false).signIn(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Sign user up
        await Provider.of<AuthProvider>(context, listen: false).signUp(
            _authData['email']!,
            _authData['password']!,
            _authData['name']!,
            _authData['phone']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This email address is not valid.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find user with that email address.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Not able to authenticate. Please try again later!';
      _showErrorDialog(errorMessage);
      rethrow;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52.h,
                  ),
                  Text(
                    "Sign Up to Moneybook",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: darkTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Wrap(
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: lightTextColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: _switchAuthMode,
                        child: Text(
                          _authMode == AuthMode.login ? "SignUp" : "Login",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: purpleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  if (_authMode == AuthMode.signup)
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Invalid name!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['name'] = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          filled: true,
                          fillColor: textFieldColor,
                          hintText: "Full Name",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  SizedBox(
                    height: 16.h,
                  ),
                  if (_authMode == AuthMode.signup)
                    TextFormField(
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        _authData['phone'] = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          filled: true,
                          fillColor: textFieldColor,
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        filled: true,
                        fillColor: textFieldColor,
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        filled: true,
                        fillColor: textFieldColor,
                        hintText: "Password",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  if (_authMode == AuthMode.signup)
                    TextFormField(
                      validator: _authMode == AuthMode.signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                          : null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          filled: true,
                          fillColor: textFieldColor,
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  SizedBox(
                    height: 16.h,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _submit,
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 14.h)),
                            textStyle: MaterialStateProperty.all(TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ))),
                        child: Text(_authMode == AuthMode.login
                            ? "Login"
                            : "Create Account"),
                      ),
                    ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Wrap(
                  //   children: [
                  //     Text(
                  //       "By signing up to Masterminds you agree to our ",
                  //       style: TextStyle(
                  //         fontSize: 14.sp,
                  //         fontWeight: FontWeight.w600,
                  //         color: lightTextColor,
                  //       ),
                  //     ),
                  //     Text(
                  //       "terms and conditions",
                  //       style: TextStyle(
                  //         fontSize: 14.sp,
                  //         fontWeight: FontWeight.w700,
                  //         color: purpleColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
