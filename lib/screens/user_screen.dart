import 'package:flutter/material.dart';
import 'package:moneybook/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

import '../providers/auth_provider.dart';

class UserScreen extends StatelessWidget {
  static const routeName = 'user-screen';
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  // Navigator.of(context).pushAndRemoveUntil(
                  //   // the new route
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => SignUpScreen(),
                  //   ),
                  //   (Route route) => false,
                  // );
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (ctx) => SignUpScreen()));
                  // Provider.of<AuthProvider>(context, listen: false).logout();
                  await Get.find<AuthController>().logout();
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                )),
          )
        ],
      ),
    );
  }
}
