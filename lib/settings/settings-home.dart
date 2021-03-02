import 'package:flutter/material.dart';
import 'package:gene_deliver/other/app-drawer.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHome extends StatefulWidget {
  @override
  _SettingsHomeState createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  bool showDeliveredPolices = false;
  bool shouldAutoLogin = false;
  SharedPreferences preferences;

  @override
  void initState() {
    getSettings();
    super.initState();
  }

  getSettings() async {
    preferences = await SharedPreferences.getInstance();

    if (preferences.getBool(spkShouldShowCompleted) == null) {
      setState(() {
        showDeliveredPolices = false;
      });
    } else {
      if (preferences.getBool(spkShouldShowCompleted)) {
        setState(() {
          showDeliveredPolices = true;
        });
      } else {
        setState(() {
          showDeliveredPolices = false;
        });
      }
    }

    if (preferences.getBool(spkShouldAutoLogin) == null) {
      setState(() {
        shouldAutoLogin = false;
      });
    } else {
      if (preferences.getBool(spkShouldAutoLogin)) {
        setState(() {
          shouldAutoLogin = true;
        });
      } else {
        setState(() {
          shouldAutoLogin = false;
        });
      }
    }

    print(shouldAutoLogin);
    print(showDeliveredPolices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      endDrawer: AppDrawer(),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Show Delivered Policies"),
              subtitle: Text("Choose to show or hide completed deliveries"),
              trailing: Switch(
                value: showDeliveredPolices,
                onChanged: (v) {
                  preferences.setBool(spkShouldShowCompleted, v);
                  setState(() {
                    showDeliveredPolices = v;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Automatic Login"),
              subtitle: Text(
                  "Save Password to prevent login each time you open the app"),
              trailing: Switch(
                value: shouldAutoLogin,
                onChanged: (v) {
                  preferences.setBool(spkShouldAutoLogin, v);
                  setState(() {
                    shouldAutoLogin = v;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
