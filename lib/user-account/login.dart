import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';
import 'package:gene_deliver/user-account/home-page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontSize: 20.0);
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Widget formField(
      TextEditingController controller, String label, Function onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '$label',
          hintText: '',
        ),
        autofocus: false,
        onChanged: onChanged,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      controller: emailController,
      enabled: !isLoading,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      enabled: !isLoading,
      controller: passwordController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(87, 197, 212, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (!isLoading) {
            doLogin();
          } else {
            showToast("Please wait");
          }
        },
        child: Row(
          children: <Widget>[
            Expanded(
                child: SizedBox(
              width: 1,
            )),
            isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : Container(),
            Text(
              "Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: SizedBox(
              width: 1,
            )),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  doLogin() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (emailController.text == '') {
      showToast("Provide your email");
    } else if (passwordController.text == '') {
      showToast("Provide your password");
    } else if (passwordController.text == '' && emailController.text == '') {
      showToast("Provide your login credentials");
    } else {
      setState(() {
        isLoading = true;
      });

      print(urlLogin);
      try {


        var postData = await http
            .post(urlLogin,
                headers: {"Content-Type": "application/json"},
                body: jsonEncode(<String, String>{
                  "Username": emailController.text.trim(),
                  "Password": passwordController.text.trim()
                }))
            .timeout(const Duration(seconds: 30));

        print(postData.statusCode);
        print("------------> api call started");

        if (postData.statusCode == 401) {
          print("------------> user not found");
          Fluttertoast.showToast(msg: "Unable to login incorrect credentials");
          passwordController.text = '';

          setState(() {
            isLoading = false;
          });
        } else if (postData.statusCode == 200) {
          //login success save token to shared prefs then move on
          print("------------> status code was 200");
          var parsedJson = jsonDecode(postData.body);
          preferences.setString(spkToken, parsedJson[spkToken]);
          preferences.setString(spkAccountType, parsedJson[spkAccountType]);
          preferences.setString(spkUserId, parsedJson[spkUserId]);

          var getUsers = await http
              .get(
            urlGetUserUrl + parsedJson[spkUserId],
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${parsedJson[spkToken]}',
            },
          );

          print("------------> getting user");

          print(getUsers.body);
          print(getUsers.statusCode);

          if (getUsers.statusCode != 200) {
            print("------------> status failed to get");
            showToast("Unable to get user data please try again");
            setState(() {
              isLoading = false;
            });
          } else {
            print("------------> status user data received");
            var userDataJson = jsonDecode(getUsers.body);
            if (userDataJson[spkActive]) {
              print(getUsers.body);

              preferences.setBool(spkHasZone, userDataJson[spkHasZone]);
              preferences.setString(spkPhone, userDataJson[spkPhone]);
              preferences.setBool(spkActive, userDataJson[spkActive]);
              preferences.setString(spkFirstName, userDataJson[spkFirstName]);
              preferences.setString(spkSecondName, userDataJson[spkSecondName]);
              preferences.setString(spkUserId2, userDataJson[spkUserId2]);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return HomePage();
                  },
                ),
              );
            } else {
              setState(() {
                isLoading = false;
              });

              print("------------> status user account is inactive");
              showToast(
                  "Your account has been deactivated please contact support");
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Unable to connect please try again");
      }
    }
  }
}
