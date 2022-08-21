import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';

class Transaction extends StatelessWidget {
  const Transaction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 9,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        transactionProvider.details,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w600),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "by stayarth",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w500),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "6:54pm",
                        style: TextStyle(fontSize: 12.sp),
                      ))
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  transactionProvider.type == TransactionType.cashIn
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            transactionProvider.amount.toString(),
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          ))
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            transactionProvider.amount.toString(),
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Balance:19,281",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
