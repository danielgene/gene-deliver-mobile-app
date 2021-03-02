import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gene_deliver/jobs/delivery-detail/delivery-detail.dart';
import 'package:gene_deliver/models/delivery_model.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCompleted extends StatefulWidget {
  @override
  _MyCompletedState createState() => _MyCompletedState();
}

class _MyCompletedState extends State<MyCompleted> {
  List<DeliveryModel> deliveryList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchMyDeliveries(new http.Client(), urlMyCompletedDeliveries),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("There was an error"));
            } else {
              deliveryList = snapshot.data;
              TextEditingController c = new TextEditingController();
              c.text = jsonEncode(snapshot.data);
              //return SingleChildScrollView(child: TextField(controller: c,));
              return DeliveryList(deliveryList);
            }
          }
        });
  }
}

class PendingList extends StatefulWidget {
  final List<DeliveryModel> deliveryList;

  const PendingList(this.deliveryList);

  @override
  _PendingListState createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  List<DeliveryModel> deliveryList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            fetchMyDeliveries(new http.Client(), urlMyInCompletedDeliveries),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("There was an error"));
            } else {
              deliveryList = snapshot.data;
              TextEditingController c = new TextEditingController();
              c.text = jsonEncode(snapshot.data);
              //return SingleChildScrollView(child: TextField(controller: c,));
              return DeliveryList(deliveryList);
            }
          }
        });
  }
}

class AllDeliveries extends StatefulWidget {
  final List<DeliveryModel> deliveryList;

  const AllDeliveries(this.deliveryList);

  @override
  _AllDeliveriesState createState() => _AllDeliveriesState();
}

class _AllDeliveriesState extends State<AllDeliveries> {
  List<DeliveryModel> deliveryList;
  @override
  Widget build(BuildContext context) {
    return DeliveryList(widget.deliveryList);
  }
}

class DeliveryList extends StatefulWidget {
  final List<DeliveryModel> deliveries;

  const DeliveryList(this.deliveries);

  @override
  _DeliveryListState createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  SharedPreferences preferences;
  bool showCompletedDeliveries = false;
  List<DeliveryModel> deliveryList;

  @override
  void initState() {
    deliveryList = widget.deliveries;
    getSettings();
    super.initState();
  }

  getSettings() async {
    preferences = await SharedPreferences.getInstance();

    if (preferences.getBool(spkShouldShowCompleted) == null) {
      setState(() {
        showCompletedDeliveries = true;
      });
    } else {
      print("=====>" + preferences.getBool(spkShouldShowCompleted).toString());
      setState(() {
        showCompletedDeliveries = preferences.getBool(spkShouldShowCompleted);
      });
    }

    if (showCompletedDeliveries == false) {
      deliveryList.removeWhere((element) => element.jobStatus == 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: deliveryList.length,
        itemBuilder: (BuildContext context, int index) {
          DeliveryModel deliveryModel = deliveryList[index];

          // print(deliveries[index].id);

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DeliveryDetail(deliveryModel);
              })).then((value) {
                setState(() {});
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${deliveryModel.customerFirstName + ' ' + deliveryModel.customerLastName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),

                      Text(
                        "${deliveryModel.addressLine1 + ' ' + deliveryModel.addressLine2}",
                        style: TextStyle(fontSize: 15),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "\$${deliveryModel.policyAmount}",
                            style: TextStyle(fontSize: 18),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 1,
                            ),
                          ),
                          Text(
                            "Policy No: ${deliveryModel.policyID}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          deliveryStatus(deliveryModel.jobStatus),
                          Expanded(
                            child: SizedBox(
                              width: 1,
                            ),
                          ),
                          timesWidget(deliveryModel)
                        ],
                      ),
                      // Text("${deliveryModel. + ' ' + deliveryModel.addressLine2}",style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget timesWidget(DeliveryModel deliveryModel) {
    int status = deliveryModel.jobStatus;
    if (status == 1) {
      return Text(
        "Not Started",
        style: TextStyle(color: Colors.pink),
      );
    } else if (status == 2) {
      String dateFormate;
      if (deliveryModel.startTime != null) {
        dateFormate = DateFormat("dd/MM/yyyy H:m")
            .format(DateTime.parse(deliveryModel.startTime));
      } else {
        dateFormate = "";
      }
      return Text(
        "Started @ ${dateFormate}",
        style: TextStyle(color: Colors.blue),
      );
    } else {
      String dateFormate;
      if (deliveryModel.endTime != null) {
        dateFormate = DateFormat("dd/MM/yyyy H:m")
            .format(DateTime.parse(deliveryModel.endTime));
      } else {
        dateFormate = "";
      }
      return Text(
        "Completed @ ${dateFormate}",
        style: TextStyle(color: Colors.green),
      );
    }
  }

  Widget deliveryStatus(int status) {
    //1 not started
    //2 in progress
    //3 completed

    if (status == 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Icon(
            Icons.hourglass_empty,
            color: Colors.pink,
          ),
          Text(
            "Pending",
            style: TextStyle(color: Colors.pink),
          ),
        ],
      );
    } else if (status == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Icon(
            Icons.access_time,
            color: Colors.blue,
          ),
          Text(
            "In Progress",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          Text(
            "Complete",
            style: TextStyle(color: Colors.green),
          ),
        ],
      );
    }
  }
}
