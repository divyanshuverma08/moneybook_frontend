import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneybook/screens/book_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/base_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/auth_provider.dart';

import '../widgets/transaction.dart';

import './books_screen.dart';
import './transaction_add_screen.dart';
import 'book_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bookIndex = 0;

  Future<void> _getAllBooks(BuildContext context) async {
    final baseProvider = Provider.of<BaseProvider>(context, listen: false);
    try {
      if (!baseProvider.userInsideApp) {
        await baseProvider.getAllBooks();
      }
      final prefs = await SharedPreferences.getInstance();
      final currentBook = prefs.getString('currentBook') as String;
      bookIndex = baseProvider.listBooks
          .indexWhere((element) => element.bookId == currentBook);
      baseProvider.userInsideApp = true;
    } catch (e) {
      rethrow;
    }
  }

  void getBookDetails() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final baseProvider = Provider.of<BaseProvider>(context, listen: false);

    return FutureBuilder(
      future: _getAllBooks(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Scaffold(
                  backgroundColor: Color(0xFFEEEEEE),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height / 6,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Text("Getting your books",
                                    style: TextStyle(
                                        fontSize: 25.sp, color: Colors.black)),
                                SizedBox(
                                  height: 20.h,
                                ),
                                const CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                )
              : MultiProvider(
                  providers: [
                      ChangeNotifierProvider.value(
                        value: baseProvider.listBooks[bookIndex],
                      ),
                    ],
                  child: BookScreen(
                    bookId: baseProvider.listBooks[bookIndex].bookId,
                    getBookDetails: getBookDetails,
                  )),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final baseProvider = Provider.of<BaseProvider>(context, listen: false);

  //   return FutureBuilder(
  //     future: _getAllBooks(context),
  //     builder: (ctx, snapshot) => snapshot.connectionState ==
  //             ConnectionState.waiting
  //         ? !baseProvider.userInsideApp
  //             ? Scaffold(
  //                 backgroundColor: Color(0xFFEEEEEE),
  //                 body: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Center(
  //                       child: Container(
  //                           padding: const EdgeInsets.all(10),
  //                           height: MediaQuery.of(context).size.height / 6,
  //                           width: MediaQuery.of(context).size.width * 0.8,
  //                           decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: Column(
  //                             children: [
  //                               Text("Getting your books",
  //                                   style: TextStyle(
  //                                       fontSize: 25.sp, color: Colors.black)),
  //                               SizedBox(
  //                                 height: 20.h,
  //                               ),
  //                               const CircularProgressIndicator(
  //                                 color: Colors.blue,
  //                               ),
  //                             ],
  //                           )),
  //                     )
  //                   ],
  //                 ),
  //               )
  //             : Scaffold(
  //                 backgroundColor: Color(0xFFEEEEEE),
  //                 appBar: AppBar(
  //                   automaticallyImplyLeading: false,
  //                   elevation: 1,
  //                   systemOverlayStyle:
  //                       const SystemUiOverlayStyle(statusBarColor: Colors.blue),
  //                   backgroundColor: Colors.white,
  //                   title: GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pushNamed(BooksScreen.routeName);
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         const Icon(
  //                           Icons.book,
  //                           color: Colors.blue,
  //                         ),
  //                         Text(
  //                           baseProvider.listBooks[0].bookName,
  //                           style:
  //                               TextStyle(fontSize: 18.sp, color: Colors.black),
  //                         ),
  //                         const Icon(
  //                           Icons.arrow_drop_down_outlined,
  //                           color: Colors.black,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 body: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                           children: [
  //                             SizedBox(
  //                               height: 20.h,
  //                             ),
  //                             Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 10.w),
  //                               child: Container(
  //                                 width: double.infinity,
  //                                 height:
  //                                     MediaQuery.of(context).size.height / 6,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.circular(4.r),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 10.w, vertical: 10.h),
  //                                       child: Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text(
  //                                             "Net Balance",
  //                                             style: TextStyle(
  //                                                 fontSize: 16.sp,
  //                                                 fontWeight: FontWeight.w600),
  //                                           ),
  //                                           Text(
  //                                               baseProvider.listBooks[0].total
  //                                                   .toString(),
  //                                               style: TextStyle(
  //                                                   fontSize: 16.sp,
  //                                                   fontWeight:
  //                                                       FontWeight.w600))
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     const Divider(
  //                                       color: Color(0xFFEEEEEE),
  //                                       thickness: 0.5,
  //                                     ),
  //                                     Padding(
  //                                       padding: EdgeInsets.all(10.w),
  //                                       child: Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text(
  //                                             "Total In (+)",
  //                                             style: TextStyle(
  //                                                 fontSize: 14.sp,
  //                                                 fontWeight: FontWeight.w600),
  //                                           ),
  //                                           Text(
  //                                               baseProvider.listBooks[0].cashIn
  //                                                   .toString(),
  //                                               style: TextStyle(
  //                                                   fontSize: 14.sp,
  //                                                   fontWeight:
  //                                                       FontWeight.w400))
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Padding(
  //                                       padding: EdgeInsets.all(10.w),
  //                                       child: Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Text(
  //                                             "Total Out (-)",
  //                                             style: TextStyle(
  //                                                 fontSize: 14.sp,
  //                                                 fontWeight: FontWeight.w600),
  //                                           ),
  //                                           Text(
  //                                               baseProvider
  //                                                   .listBooks[0].cashOut
  //                                                   .toString(),
  //                                               style: TextStyle(
  //                                                   fontSize: 14.sp,
  //                                                   fontWeight:
  //                                                       FontWeight.w400))
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: 22.h,
  //                             ),
  //                             Column(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceEvenly,
  //                               children: [
  //                                 Center(
  //                                   child: CircularProgressIndicator(),
  //                                 ),
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       width: double.infinity,
  //                       height: MediaQuery.of(context).size.height / 10,
  //                       decoration: const BoxDecoration(
  //                         color: Colors.white,
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: [
  //                           SizedBox(
  //                             width: MediaQuery.of(context).size.width / 2.2,
  //                             height: MediaQuery.of(context).size.height / 14,
  //                             child: TextButton(
  //                               onPressed: () {},
  //                               style: ButtonStyle(
  //                                   backgroundColor:
  //                                       MaterialStateProperty.all(Colors.green),
  //                                   foregroundColor:
  //                                       MaterialStateProperty.all(Colors.white),
  //                                   padding: MaterialStateProperty.all(
  //                                       EdgeInsets.symmetric(vertical: 14.h)),
  //                                   textStyle:
  //                                       MaterialStateProperty.all(TextStyle(
  //                                     fontSize: 14.sp,
  //                                     fontWeight: FontWeight.w700,
  //                                   ))),
  //                               child: Text(
  //                                 "+  Cash In",
  //                                 style: TextStyle(
  //                                   fontSize: 20.sp,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: MediaQuery.of(context).size.width / 2.2,
  //                             height: MediaQuery.of(context).size.height / 14,
  //                             child: TextButton(
  //                               onPressed: () {},
  //                               style: ButtonStyle(
  //                                   backgroundColor:
  //                                       MaterialStateProperty.all(Colors.red),
  //                                   foregroundColor:
  //                                       MaterialStateProperty.all(Colors.white),
  //                                   padding: MaterialStateProperty.all(
  //                                       EdgeInsets.symmetric(vertical: 14.h)),
  //                                   textStyle:
  //                                       MaterialStateProperty.all(TextStyle(
  //                                     fontSize: 14.sp,
  //                                     fontWeight: FontWeight.w700,
  //                                   ))),
  //                               child: Text(
  //                                 "-  Cash Out",
  //                                 style: TextStyle(
  //                                   fontSize: 20.sp,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               )
  //         : Scaffold(
  //             backgroundColor: const Color(0xFFEEEEEE),
  //             appBar: AppBar(
  //               actions: [
  //                 PopupMenuButton(
  //                     icon: Icon(
  //                       Icons.menu,
  //                       color: Colors.black,
  //                     ),
  //                     itemBuilder: (context) => [
  //                           PopupMenuItem(
  //                             onTap: () async {
  //                               await Provider.of<AuthProvider>(context,
  //                                       listen: false)
  //                                   .logout();
  //                             },
  //                             child: const Text("Logout"),
  //                             value: 1,
  //                           )
  //                         ])
  //               ],
  //               automaticallyImplyLeading: false,
  //               elevation: 1,
  //               systemOverlayStyle:
  //                   const SystemUiOverlayStyle(statusBarColor: Colors.blue),
  //               backgroundColor: Colors.white,
  //               title: GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context).pushNamed(BooksScreen.routeName);
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     const Icon(
  //                       Icons.book,
  //                       color: Colors.blue,
  //                     ),
  //                     Text(
  //                       baseProvider.listBooks[0].bookName,
  //                       style: TextStyle(fontSize: 18.sp, color: Colors.black),
  //                     ),
  //                     const Icon(
  //                       Icons.arrow_drop_down_outlined,
  //                       color: Colors.black,
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             body: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                       children: [
  //                         SizedBox(
  //                           height: 20.h,
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 10.w),
  //                           child: Container(
  //                             width: double.infinity,
  //                             height: MediaQuery.of(context).size.height / 6,
  //                             decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.circular(4.r),
  //                             ),
  //                             child: Column(
  //                               children: [
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 10.w, vertical: 10.h),
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text(
  //                                         "Net Balance",
  //                                         style: TextStyle(
  //                                             fontSize: 16.sp,
  //                                             fontWeight: FontWeight.w600),
  //                                       ),
  //                                       Text(
  //                                           baseProvider.listBooks[0].total
  //                                               .toString(),
  //                                           style: TextStyle(
  //                                               fontSize: 16.sp,
  //                                               fontWeight: FontWeight.w600))
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 const Divider(
  //                                   color: Color(0xFFEEEEEE),
  //                                   thickness: 0.5,
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.all(10.w),
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text(
  //                                         "Total In (+)",
  //                                         style: TextStyle(
  //                                             fontSize: 14.sp,
  //                                             fontWeight: FontWeight.w600),
  //                                       ),
  //                                       Text(
  //                                           baseProvider.listBooks[0].cashIn
  //                                               .toString(),
  //                                           style: TextStyle(
  //                                               fontSize: 14.sp,
  //                                               fontWeight: FontWeight.w400))
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.all(10.w),
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       Text(
  //                                         "Total Out (-)",
  //                                         style: TextStyle(
  //                                             fontSize: 14.sp,
  //                                             fontWeight: FontWeight.w600),
  //                                       ),
  //                                       Text(
  //                                           baseProvider.listBooks[0].cashOut
  //                                               .toString(),
  //                                           style: TextStyle(
  //                                               fontSize: 14.sp,
  //                                               fontWeight: FontWeight.w400))
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 22.h,
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: [
  //                             const Expanded(
  //                                 child: Divider(
  //                               thickness: 1,
  //                             )),
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 20.w),
  //                               child: Text(
  //                                 "Showing ${baseProvider.listBooks[0].listTransactions.length} entries",
  //                                 style: TextStyle(fontSize: 10.sp),
  //                               ),
  //                             ),
  //                             const Expanded(
  //                               child: Divider(
  //                                 thickness: 1,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 22.h,
  //                         ),
  //                         ...baseProvider.listBooks[0].listTransactions
  //                             .map(
  //                               (transaction) => Column(
  //                                 children: [
  //                                   ChangeNotifierProvider.value(
  //                                     value: transaction,
  //                                     child: Transaction(),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 22.h,
  //                                   ),
  //                                 ],
  //                               ),
  //                             )
  //                             .toList(),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   width: double.infinity,
  //                   height: MediaQuery.of(context).size.height / 10,
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 2.2,
  //                         height: MediaQuery.of(context).size.height / 14,
  //                         child: TextButton(
  //                           onPressed: () {
  //                             // Navigator.of(context).pushNamed(
  //                             //     TransactionAddScreen.routeName,
  //                             //     arguments: {
  //                             //       "bookId":
  //                             //           baseProvider.listBooks[0].bookId,
  //                             //       "type": TransactionType.cashIn
  //                             //     });
  //                             Navigator.of(context).push(
  //                               MaterialPageRoute(
  //                                   builder: (context) =>
  //                                       ChangeNotifierProvider.value(
  //                                         value: baseProvider.listBooks[0],
  //                                         child: TransactionAddScreen(),
  //                                       ),
  //                                   settings: RouteSettings(arguments: {
  //                                     "bookId":
  //                                         baseProvider.listBooks[0].bookId,
  //                                     "type": TransactionType.cashIn
  //                                   })),
  //                             );
  //                           },
  //                           style: ButtonStyle(
  //                               backgroundColor:
  //                                   MaterialStateProperty.all(Colors.green),
  //                               foregroundColor:
  //                                   MaterialStateProperty.all(Colors.white),
  //                               padding: MaterialStateProperty.all(
  //                                   EdgeInsets.symmetric(vertical: 14.h)),
  //                               textStyle: MaterialStateProperty.all(TextStyle(
  //                                 fontSize: 14.sp,
  //                                 fontWeight: FontWeight.w700,
  //                               ))),
  //                           child: Text(
  //                             "+  Cash In",
  //                             style: TextStyle(
  //                               fontSize: 20.sp,
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 2.2,
  //                         height: MediaQuery.of(context).size.height / 14,
  //                         child: TextButton(
  //                           onPressed: () {
  //                             Navigator.of(context).push(
  //                               MaterialPageRoute(
  //                                   builder: (context) =>
  //                                       ChangeNotifierProvider.value(
  //                                         value: baseProvider.listBooks[0],
  //                                         child: TransactionAddScreen(),
  //                                       ),
  //                                   settings: RouteSettings(arguments: {
  //                                     "bookId":
  //                                         baseProvider.listBooks[0].bookId,
  //                                     "type": TransactionType.cashOut
  //                                   })),
  //                             );
  //                           },
  //                           style: ButtonStyle(
  //                               backgroundColor:
  //                                   MaterialStateProperty.all(Colors.red),
  //                               foregroundColor:
  //                                   MaterialStateProperty.all(Colors.white),
  //                               padding: MaterialStateProperty.all(
  //                                   EdgeInsets.symmetric(vertical: 14.h)),
  //                               textStyle: MaterialStateProperty.all(TextStyle(
  //                                 fontSize: 14.sp,
  //                                 fontWeight: FontWeight.w700,
  //                               ))),
  //                           child: Text(
  //                             "-  Cash Out",
  //                             style: TextStyle(
  //                               fontSize: 20.sp,
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //   );
  // }
}
