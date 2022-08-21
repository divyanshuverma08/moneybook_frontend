import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';

import '../widgets/transaction.dart';

import './books_screen.dart';
import './transaction_add_screen.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({Key? key}) : super(key: key);

  Future<void> _getTransactions(BuildContext context) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    try {
      await bookProvider.getTransactions();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    return FutureBuilder(
        future: _getTransactions(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Scaffold(
                body: CircularProgressIndicator(),
              )
            : Scaffold(
                backgroundColor: Color(0xFFEEEEEE),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 1,
                  systemOverlayStyle:
                      const SystemUiOverlayStyle(statusBarColor: Colors.blue),
                  backgroundColor: Colors.white,
                  title: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(BooksScreen.routeName);
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
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.black),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Net Balance",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(bookProvider.total.toString(),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total In (+)",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(bookProvider.cashIn.toString(),
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total Out (-)",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(bookProvider.cashOut.toString(),
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
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.w),
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
                                .toList(),
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
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider.value(
                                            value: bookProvider,
                                            child: TransactionAddScreen(),
                                          ),
                                      settings: RouteSettings(arguments: {
                                        "bookId": bookProvider.bookId,
                                        "type": TransactionType.cashIn
                                      })),
                                );
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(vertical: 14.h)),
                                  textStyle:
                                      MaterialStateProperty.all(TextStyle(
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
                                      builder: (context) =>
                                          ChangeNotifierProvider.value(
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
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(vertical: 14.h)),
                                  textStyle:
                                      MaterialStateProperty.all(TextStyle(
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
              ));
  }
}
