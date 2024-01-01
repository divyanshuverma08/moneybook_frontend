import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/base_provider.dart';

import '../widgets/book.dart';

class BooksScreen extends StatelessWidget {
  static const routeName = "books-screen";

  BooksScreen();

  TextEditingController textController = TextEditingController();

  Future<void> _getAllBooks(BuildContext context) async {
    final baseProvider = Provider.of<BaseProvider>(context, listen: false);
    try {
      await baseProvider.getAllBooks();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.blue),
        backgroundColor: Colors.white,
        title: Text(
          "Your Moneybooks",
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: _getAllBooks(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : Consumer<BaseProvider>(
                    builder: (ctx, book, child) => ListView.builder(
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value: book.listBooks[i], child: Book()),
                      itemCount: book.listBooks.length,
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ListTile(
                      leading: const Icon(Icons.clear),
                      title: Text("Create New Book",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    ),
                    const Divider(
                      height: 0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.w),
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 14.h),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter Book Name",
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15.w, right: 15.w, bottom: 15.w),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            await Provider.of<BaseProvider>(context,
                                    listen: false)
                                .createBook(textController.text);

                            Navigator.of(context).pop();
                          },
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
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          },
          child: Icon(Icons.add)),
    );
  }
}
