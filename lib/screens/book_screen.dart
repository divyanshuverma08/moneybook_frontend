import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/auth_provider.dart';

import '../widgets/transaction.dart';

import './books_screen.dart';
import './transaction_add_screen.dart';
import './user_screen.dart';
import './home_screen.dart';
import 'signup_screen.dart';

class BookScreen extends StatefulWidget {
  final String bookId;
  Function getBookDetails;

  BookScreen({required this.bookId, required this.getBookDetails});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<BookProvider>(context, listen: false)
            .getTransactions();
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        rethrow;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .logout();
                      },
                      child: const Text("Logout"),
                      value: 1,
                    )
                  ]),
          // IconButton(
          //     onPressed: () async {
          //       Provider.of<AuthProvider>(context, listen: false).logout();
          //     },
          //     icon: Icon(
          //       Icons.menu,
          //       color: Colors.black,
          //     ))
        ],
        automaticallyImplyLeading: false,
        elevation: 1,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.blue),
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () async {
            final result = Navigator.of(context)
                .pushNamed(BooksScreen.routeName)
                .then((value) {
              widget.getBookDetails();
            });
            // final result = await Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         BooksScreen(authController: widget.authController),
            //   ),
            // );
            print(result);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.book,
                color: Colors.blue,
              ),
              Text(
                bookProvider.bookName,
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
              const Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Net Balance",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    _isLoading
                                        ? "0.0"
                                        : bookProvider.total.toString(),
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color(0xFFEEEEEE),
                            thickness: 0.5,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total In (+)",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    _isLoading
                                        ? "0.0"
                                        : bookProvider.cashIn.toString(),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Out (-)",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    _isLoading
                                        ? "0.0"
                                        : bookProvider.cashOut.toString(),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                          child: Divider(
                        thickness: 1,
                      )),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "Showing ${bookProvider.listTransactions.length} entries",
                          style: TextStyle(fontSize: 10.sp),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  _isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Center(
                              child: CircularProgressIndicator(),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            ...bookProvider.listTransactions
                                .map(
                                  (transaction) => Column(
                                    children: [
                                      ChangeNotifierProvider.value(
                                        value: transaction,
                                        child: Transaction(),
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                    ],
                                  ),
                                )
                                .toList()
                          ],
                        ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 10,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  height: MediaQuery.of(context).size.height / 14,
                  child: TextButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                                  value: bookProvider,
                                  child: TransactionAddScreen(),
                                ),
                            settings: RouteSettings(arguments: {
                              "bookId": bookProvider.bookId,
                              "type": TransactionType.cashIn
                            })),
                      );
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text("Transaction Added")));
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 14.h)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ))),
                    child: Text(
                      "+  Cash In",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  height: MediaQuery.of(context).size.height / 14,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                                  value: bookProvider,
                                  child: TransactionAddScreen(),
                                ),
                            settings: RouteSettings(arguments: {
                              "bookId": bookProvider.bookId,
                              "type": TransactionType.cashOut
                            })),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 14.h)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ))),
                    child: Text(
                      "-  Cash Out",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
