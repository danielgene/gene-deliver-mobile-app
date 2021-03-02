import 'package:flutter/material.dart';
import 'package:gene_deliver/jobs/delivery-list.dart';
import 'package:gene_deliver/models/delivery_model.dart';
import 'package:gene_deliver/other/app-drawer.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQ = '';

  String searchUrl;

  @override
  void initState() {
    getAllDeliveries();
    super.initState();
  }

  List<DeliveryModel> originalList;
  List<DeliveryModel> copyList = new List<DeliveryModel>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;

  getAllDeliveries() async {
    setState(() {
      isLoading = true;
    });

    originalList = await fetchMyDeliveries(http.Client(), urlGetMyDeliveries);

    setState(() {
      //copyList = originalList;
      isLoading = false;
    });
  }

  void filterSearchResults(String query) {
    List<DeliveryModel> tempList = new List<DeliveryModel>();
    if (originalList.length == 0) {}
    getAllDeliveries();

    print(query);
    if (query.isNotEmpty) {
      for (int i = 0; i < originalList.length; i++) {
        //print(originalList[i].customerFirstName);
        if ((originalList[i].customerFirstName +
                    " " +
                    originalList[i].customerLastName)
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (originalList[i].policyID.toLowerCase())
                .contains(query.toLowerCase()) ||
            (originalList[i].addressLine1 +
                    " " +
                    originalList[i].addressLine2.toLowerCase())
                .contains(query.toLowerCase())) {
          print(originalList[i].customerFirstName + " found");
          tempList.add(originalList[i]);
          // });
        }
      }
      setState(() {
        copyList = tempList;
      });

      // return;
    } else {
      setState(() {
        copyList.clear();
        copyList.addAll(originalList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if(originalList.length==0){
    //   getAllDeliveries();
    // }

    return SafeArea(
      child: Scaffold(
        endDrawer: new AppDrawer(),
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back,
                            size: 25,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            child: TextFormField(
                              autofocus: true,
                              onChanged: (v) {
                                filterSearchResults(v);
                                //print(v);
                              },
                              style: new TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.dehaze,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: DeliveryList(copyList),
                  )
          ],
        ),
      ),
    );
  }
}
