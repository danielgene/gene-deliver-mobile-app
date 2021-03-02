import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gene_deliver/jobs/delivery-list.dart';
import 'package:gene_deliver/models/delivery_model.dart';
import 'package:gene_deliver/other/app-drawer.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';
import 'package:gene_deliver/user-account/profile.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  initState() {
    getProfileData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getDeliveries();
    super.initState();
  }

  bool isLoading = false;
  String pageTitle = "Home";

  List<DeliveryModel> myDeliveries;
  List<DeliveryModel> myPendingDeliveries;
  List<DeliveryModel> myCompletedDeliveries;

  void getDeliveries() async {
    setState(() {
      isLoading = true;
    });

    myDeliveries = await fetchMyDeliveries(new Client(), urlGetMyDeliveries);
    myPendingDeliveries = await fetchMyDeliveries(new Client(), urlMyInCompletedDeliveries);
    myCompletedDeliveries =  await fetchMyDeliveries(new Client(), urlMyCompletedDeliveries);

    setState(() {
      isLoading = false;
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    getDeliveries();
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_numbered), title: Text('All')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.hourglass_empty), title: Text("Pending")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_add_check),
                  title: Text("Completed")),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                title: Text("Profile"),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black38,
            onTap: _onItemTapped,
          ),
          appBar: AppBar(title: Text(pageTitle)),
          drawer: AppDrawer(),
          body: !isLoading
              ? _widgetOptions(_selectedIndex)
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }

  bool hasZone;
  String userName, phone, accountType, firstName, surname;

  getProfileData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    firstName = preferences.getString(spkFirstName);
    surname = preferences.getString(spkSecondName);
    phone = preferences.getString(spkPhone);
    accountType = preferences.getString(spkAccountType);
    hasZone = preferences.getBool(spkHasZone);
  }

  Widget _widgetOptions(int index) {
    var w = <Widget>[
      Container(child: DeliveryList(myDeliveries)),
      DeliveryList(myPendingDeliveries),
      Container(child: DeliveryList(myCompletedDeliveries)),
      ProfilePage(userName, phone, accountType, firstName, surname),
    ];

    return w[index];
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        pageTitle = "All Deliveries";
      } else if (index == 1) {
        pageTitle = "Pending Deliveries";
      } else if (index == 2) {
        pageTitle = "Completed Deliveries";
      } else {
        pageTitle = "Profile";
      }
      _selectedIndex = index;
    });
  }
}
