import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';

class TransactionAddScreen extends StatefulWidget {
  static const routeName = "add-transaction";

  TransactionAddScreen({Key? key}) : super(key: key);

  @override
  State<TransactionAddScreen> createState() => _TransactionAddScreenState();
}

class _TransactionAddScreenState extends State<TransactionAddScreen> {
  final purpleColor = Color(0xff6688FF);

  final darkTextColor = Color(0xff1F1A3D);

  final lightTextColor = Color(0xff999999);

  final textFieldColor = Color(0xffF5F6FA);

  final borderColor = Color(0xffD9D9D9);

  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _formData = {
    'detail': '',
    'amount': '',
  };

  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final _transactionInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    try {
      Provider.of<BookProvider>(context, listen: false).addTransaction(
          _formData['detail'] as String,
          double.parse(_formData['amount'] as String),
          _transactionInfo['type'],
          _transactionInfo['bookId']);
    } catch (error) {
      rethrow;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 1,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.blue),
        backgroundColor: Colors.white,
        title: Text(
          "Cash In",
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
        ),
      ),
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
                    height: 16.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Something';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['amount'] = value!;
                    },
                    keyboardType: TextInputType.number,
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
                        hintText: "Amount",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter something!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData['detail'] = value!;
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
                        hintText: "Remark",
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
                        child: const Text("Save"),
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
