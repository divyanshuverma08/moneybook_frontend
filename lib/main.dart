import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './providers/auth_provider.dart';
import './providers/base_provider.dart';

import './screens/home_screen.dart';
import './screens/books_screen.dart';
import './screens/signup_screen.dart';
import './screens/transaction_add_screen.dart';
import './screens/user_screen.dart';

void main() async {
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider<BaseProvider>(
          create: (ctx) => BaseProvider(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Consumer<AuthProvider>(
          builder: (ctx, auth, _) => ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (context, child) => MaterialApp(
                    title: 'Flutter Demo',
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                    ),
                    home: auth.isAuth
                        ? HomeScreen()
                        : FutureBuilder(
                            future: auth.tryAutoLogin(),
                            builder: (ctx, authResultSnapshot) =>
                                authResultSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? const Scaffold(
                                        body: Center(
                                          child: Text('Loading...'),
                                        ),
                                      )
                                    : SignUpScreen(),
                          ),
                    routes: {
                      BooksScreen.routeName: (ctx) => BooksScreen(),
                      TransactionAddScreen.routeName: (ctx) =>
                          TransactionAddScreen(),
                      UserScreen.routeName: (ctx) => UserScreen()
                    },
                  )),
        ),
      ),
    );
  }
}

// Consumer<AuthProvider>(
//         builder: (ctx, auth, _) => ScreenUtilInit(
//             designSize: const Size(375, 812),
//             builder: (context, child) => MaterialApp(
//                   title: 'Flutter Demo',
//                   theme: ThemeData(
//                     primarySwatch: Colors.blue,
//                   ),
//                   home: auth.isAuth ? HomeScreen() : SignUpScreen(),
//                   routes: {
//                     BooksScreen.routeName: (ctx) => BooksScreen(),
//                     TransactionAddScreen.routeName: (ctx) =>
//                         TransactionAddScreen(),
//                     UserScreen.routeName: (ctx) => UserScreen()
//                   },
//                 )),
//       )


// FutureBuilder(
//                           future: auth.tryAutoLogin(),
//                           builder: (ctx, authResultSnapshot) =>
//                               authResultSnapshot.connectionState ==
//                                       ConnectionState.waiting
//                                   ? const Scaffold(
//                                       body: Center(
//                                         child: Text('Loading...'),
//                                       ),
//                                     )
//                                   : SignUpScreen(),
//                         )