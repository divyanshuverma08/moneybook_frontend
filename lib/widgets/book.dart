import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/base_provider.dart';
import '../providers/book_provider.dart';

import '../screens/book_screen.dart';

class Book extends StatelessWidget {
  Book();

  @override
  Widget build(BuildContext context) {
    final bookData = Provider.of<BookProvider>(context, listen: false);

    Future<void> saveBook() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentBook', bookData.bookId);
    }

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (context) => ChangeNotifierProvider.value(
        //         value: bookData,
        //         child: BookScreen(
        //           bookId: bookData.bookId,
        //         ),
        //       ),
        //     ),
        //     (Route<dynamic> route) => false);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ChangeNotifierProvider.value(
        //           value: bookData,
        //           child: BookScreen(
        //             bookId: bookData.bookId,
        //             authController: authController,
        //           ),
        //         )));
        Navigator.pop(context, bookData.bookId);
        saveBook();
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 10.4,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.book,
                color: Colors.blue,
              ),
              title: Text(
                bookData.bookName,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              subtitle: Text("created on: Jun 11th 2021 | 2 Members",
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
              trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () async {
                            await Provider.of<BaseProvider>(context,
                                    listen: false)
                                .deleteBook(bookData.bookId);
                          },
                          child: Text("Delete Book"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Rename"),
                          value: 2,
                        )
                      ]),
            ),
            Divider(
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
