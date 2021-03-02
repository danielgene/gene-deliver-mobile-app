import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gene_deliver/jobs/reciept-module/search-policy/view-policy.dart';
import 'package:gene_deliver/models/search_result_model.dart';
import 'package:gene_deliver/other/app-drawer.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';

class SearchReciept extends StatefulWidget {
  @override
  _SearchRecieptState createState() => _SearchRecieptState();
}

class _SearchRecieptState extends State<SearchReciept> {
  String searchQ = '';

  String searchUrl;

  @override
  void initState() {
    super.initState();
  }

  String userChatNumber;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    searchUrl = policySearchUrl;

    Widget f = FutureBuilder<List<SearchResultModel>>(
      future: fetchSearchResults(searchQ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text("Enter text to search"),
          );
        }
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return resultCard(snapshot.data);
        }
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Center(child: Text("No results found for '$searchQ'"));
        }

        if (snapshot.connectionState != ConnectionState.done &&
            !snapshot.hasData) {
          return Center(child: new CircularProgressIndicator());
        } else {
          return Center(child: new CircularProgressIndicator());
        }
      },
    );

    return SafeArea(
      child: Scaffold(
        endDrawer: new AppDrawer(),
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.blue,
              elevation: 5,
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
                              setState(() {
                                searchQ = v;
                                print(searchUrl);
                              });
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
            Container(
                height: MediaQuery.of(context).size.height * 0.85, child: f),
          ],
        ),
      ),
    );
  }

  Widget resultCard(List<SearchResultModel> modelList) {
    if (modelList.length == 0) {
      return Center(child: Text("No results found"));
    } else {
      List<Widget> s = new List<Widget>();
      for (int i = 0; i < modelList.length; i++) {
        s.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                return ViewPolicy(modelList[i].policyNumber);
              }));
            },
            child: Material(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${modelList[i].customerName}",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                    Text("${modelList[i].vehicleRegNumber}"),
                    Text("${modelList[i].policyNumber}"),
                  ],
                ),
              ),
            ),
          ),
        ));
      }
      return SingleChildScrollView(
        child: Column(
          children: s,
        ),
      );
    }
  }
}
