import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gene_deliver/jobs/delivery-detail/confirmation-info.dart';
import 'package:gene_deliver/jobs/delivery-detail/signature-pad.dart';
import 'package:gene_deliver/models/comment_model.dart';
import 'package:gene_deliver/models/delivery_model.dart';
import 'package:gene_deliver/other/comment-bubble.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'confirmation-info.dart';

class DeliveryDetail extends StatefulWidget {
  final DeliveryModel deliveryModel;

  const DeliveryDetail(this.deliveryModel);

  @override
  _DeliveryDetailState createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetail> {
  DeliveryModel deliveryModel;

  @override
  void initState() {
    deliveryModel = widget.deliveryModel;
    super.initState();
  }

  String deliveryStatusStr = '';

  Color appBarColor(int deliveryStatus) {
    //1 not started
    //2 on going
    //3 completed

    if (deliveryStatus == 1) {
      deliveryStatusStr = 'Not Started';
      return Colors.pink;
    } else if (deliveryStatus == 2) {
      deliveryStatusStr = 'Not Started';
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

  String getDelStatus() {
    int deliveryStatus = deliveryModel.jobStatus;

    if (deliveryStatus == 1) {
      return 'Not Started';
    } else if (deliveryStatus == 2) {
      return 'Ongoing';
    } else {
      return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Delivery Details"),
            Text(
              getDelStatus(),
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.access_time,
              color: Colors.white,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            child: GestureDetector(
              onTap: () {
                if (deliveryModel.jobStatus != 3) {
                  showCommentDialog(context);
                } else {
                  Fluttertoast.showToast(
                      msg: "You cannot do that",
                      backgroundColor: Colors.black,
                      textColor: Colors.white);
                }
              },
              child: Icon(
                Icons.add_comment,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
        backgroundColor: appBarColor(deliveryModel.jobStatus),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                listTile(
                  'Customer Name',
                  '${deliveryModel.customerFirstName + " " + deliveryModel.customerLastName}',
                ),
                listTile('Destination',
                    '${deliveryModel.addressLine1 + "\n" + deliveryModel.addressLine2}'),
                listTile('Phone', '${deliveryModel.phoneNumber}'),
                listTile('Amount', '\$${deliveryModel.policyAmount}'),
                listTile(
                    'Date Added', '${deliveryModel.policyTransactionDate}'),
                listTile('Policy Id', '${deliveryModel.policyID}'),
                listTile('Agent Name', '${deliveryModel.agentName}'),
                listTile('Start Time', '${deliveryModel.startTime}'),
                listTile('End Time', '${deliveryModel.endTime}'),
                deliveryButton(),
                commentsWidget(),
                DeliveryConfirmation(deliveryModel)
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget deliveryButton() {
    switch (deliveryModel.jobStatus) {
      case 3:
        return Container();
        break;

      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GFButton(
            onPressed: () async {
              if (deliveryModel.jobStatus == 1) {
                showStartDeliveryProgress(context, false);
              } else {
                var f = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) {
                  return SignaturePad(deliveryModel.id);
                }));

                if (f != null) {
                  setState(() {
                    deliveryModel.jobStatus = 2;
                  });

                  showStartDeliveryProgress(context, false);
                }
              }
            },
            text: deliveryModel.jobStatus == 2
                ? "Stop Delivery"
                : "Start Delivery",
            size: GFSize.MEDIUM,
            fullWidthButton: true,
          ),
        );
        break;
    }
  }

  TextEditingController commentController = TextEditingController();

  showCommentDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Comment'),
            content: TextField(
              controller: commentController,
              decoration: InputDecoration(hintText: "Comment comes here .."),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  addComment();
                },
              )
            ],
          );
        });
  }

  Future<void> showProgress(BuildContext context, bool shouldEnd) async {
    var result = await showDialog(
        context: context,
        child: FutureProgressDialog(doSubmit(), message: Text('Loading...')));
    showResultDialog(context, result);
  }

  Future<void> showStartDeliveryProgress(
      BuildContext context, bool shouldEnd) async {
    var result = await showDialog(
        context: context,
        child:
            FutureProgressDialog(startDelivery(), message: Text('Loading...')));
    showResultDialog(context, result);
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Result"),
        content: Text("$result "),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.pink),
            ),
          )
        ],
      ),
    );
  }

  Widget commentsWidget() {
    print(urlGetComments + "${deliveryModel.id}");
    return FutureBuilder(
      future: fetchDeliveryComments(
          new http.Client(), urlGetComments + "${deliveryModel.id}"),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.data);
          print(snapshot.error);

          return Text("error");
        } else {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            // print("-----> snapshot has data must render list");
            return commentsList(snapshot.data);
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              // print("-----> snapshot has no data but connection is okay");

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("No comments available"),
                ),
              );
            } else {
              //  print("-----> snapshot has no data but connection not is okay");

              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        }
      },
    );
  }

  Widget commentsList(List<CommentModel> comments) {
    //  print('rendering list-->');
    if (comments.length == 0) {
      return Text("No comments for this delivery");
    } else {
      List<Widget> commentsWList = new List<Widget>();

      for (int i = 0; i < comments.length; i++) {
        commentsWList.add(Bubble(
          message: comments[i].comment,
          time: DateFormat("dd/MM/yyyy H:m")
              .format(DateTime.parse(comments[i].callTime)),
        ));
      }

      return Column(
        children: commentsWList,
      );
    }
  }

  Future doSubmit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.get(spkToken);
    // print("---> ${deliveryModel.id}");
    http.Response r = await http.post(urlPostComments,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "deliveryId": deliveryModel.id,
          "comment": commentController.text
        }));

    if (r.statusCode == 201) {
      commentController.text = '';
      setState(() {});
      return "Comment posted";
    } else {
      return "there was an error please try again";
    }
  }

  void addComment() {
    if (commentController.text.length > 2) {
      showProgress(context, false);
    } else {
      Fluttertoast.showToast(msg: "You cannot send a blank comment");
    }
  }

  void initiateDelivery() {
    if (deliveryModel.jobStatus != 3) {
      showStartDeliveryProgress(context, false);
    } else {
      Fluttertoast.showToast(msg: "You cannot start this delivery");
    }
  }

  Future startDelivery() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.get(spkToken);

    if (deliveryModel.jobStatus == 1) {
      var r = await http.get(
        urlStartDelivery + deliveryModel.id.toString(),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      // s = 'delivery started';

      print(r.statusCode);
      if (r.statusCode == 200) {
        String startAddress;
        String startLocation;

        try {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          if (position == null) {
            position = await Geolocator.getLastKnownPosition();
          }

          final coordinates =
              new Coordinates(position.latitude, position.longitude);

          print(coordinates.latitude);
          print(coordinates.longitude);

          List<Address> addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);

          startAddress = addresses.first.addressLine;

          startLocation = "${position.latitude.toString()}" +
              " , " +
              "${position.longitude.toString()}";
          print(startAddress);
        } catch (e) {
          startLocation = "0000 , 0000";
          startAddress = "Unable to find current address";
          Fluttertoast.showToast(msg: "Location not found");
        }
        print("----->");



        var x = await http.post(pcIp + "/DeliveryConfirmations/confirm",
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              "deliveryId": deliveryModel.id,
              "startAddress": startAddress,
              "startLocation": startLocation
            }));

        print(x.statusCode);
        print("-------->jjjj");

        setState(() {
          commentController.text = '';
          deliveryModel.jobStatus = 2;
        });

        return "delivery started";
      } else {
        return "there was an error please try again";
      }
    } else if (deliveryModel.jobStatus == 2) {
      var sx = await http.get(
        urlStopDelivery + deliveryModel.id.toString(),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (sx.statusCode == 200) {
        commentController.text = '';
        deliveryModel.jobStatus = 3;
        setState(() {});
        return 'delivery stopped';
      } else {
        return "there was an error please try again";
      }
    }
  }
}
