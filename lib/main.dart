import 'package:flutter/material.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/user-account/home-page.dart';
import 'package:gene_deliver/user-account/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color color = Color.fromRGBO(87, 197, 212, 1);
    return MaterialApp(
      title: 'Gene Deliver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  bool isAutoLoggedIn = false;

  checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(spkToken);

    if (preferences.getBool(spkShouldAutoLogin) == null) {
      setState(() {
        isAutoLoggedIn = false;
      });
    } else {
      isAutoLoggedIn = preferences.getBool(spkShouldAutoLogin);
    }

    if (token == null) {
      setState(() {
        isLoggedIn = false;
      });
    } else {
      isLoggedIn = true;
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      if (isLoggedIn) {
        return HomePage();
      } else {
        return LoginPage();
      }

  }
}
