import 'package:flutter/material.dart';
import 'package:gene_deliver/jobs/reciept-module/search-home.dart';
import 'package:gene_deliver/jobs/reciept-module/search-policy/search-page.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/settings/settings-home.dart';
import 'package:gene_deliver/user-account/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  String userName = "";
  String phoneNumber = "";

  getProfileData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString(spkFirstName) +
          ' ' +
          preferences.getString(spkSecondName);
      phoneNumber = preferences.getString(spkPhone);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(phoneNumber),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "G",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SettingsHome();
              }));
            },
            title: Text("Settings"),
            subtitle: Text("Customize Application"),
            trailing: Icon(Icons.settings),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SearchPage();
              }));
            },
            title: Text("Search"),
            subtitle: Text("Quick find something"),
            trailing: Icon(Icons.search),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SearchReciept();
              }));
            },
            title: Text("Receipt"),
            subtitle: Text("Receipt a policy"),
            trailing: Icon(Icons.search),
          ),
          ListTile(
            onTap: () {
              signOut();
            },
            title: Text("Sign Out"),
            subtitle: Text("Exit and logout"),
            trailing: Icon(Icons.power_settings_new),
          ),
        ],
      ),
    );
  }

  void signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return LoginPage();
    }));
  }
}
