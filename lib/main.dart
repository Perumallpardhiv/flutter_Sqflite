import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_todo/models/provider.dart';
import 'package:sql_todo/screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final theme = sharedPreferences.getBool('theme') ?? true;
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => themeChange(theme),
    child: MyApp(
      appTheme: theme,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final appTheme;
  MyApp({super.key, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    return Consumer<themeChange>(builder: (BuildContext context, value, Widget? child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: value.isDark == true
            ? ThemeData(
                primaryColor: Colors.black,
                scaffoldBackgroundColor: Colors.blueGrey.shade900,
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              )
            : ThemeData(
                primaryColor: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
        home: homePage(),
      );
    });
  }
}
