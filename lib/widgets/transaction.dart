import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Transaction extends StatelessWidget {
  const Transaction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        "Amazon affiliate",
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
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "1,193",
                        style: TextStyle(
                            color: Colors.green,
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
