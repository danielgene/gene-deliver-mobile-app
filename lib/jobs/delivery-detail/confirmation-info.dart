import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gene_deliver/models/delivery_model.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryConfirmation extends StatefulWidget {
  final DeliveryModel deliveryModel;

  const DeliveryConfirmation(this.deliveryModel);

  @override
  _DeliveryConfirmationState createState() => _DeliveryConfirmationState();
}

class _DeliveryConfirmationState extends State<DeliveryConfirmation> {

  DeliveryModel deliveryModel;

  @override
  Widget build(BuildContext context) {
    deliveryModel = widget.deliveryModel;
    return FutureBuilder(
        future: getConfirmationInfo(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            http.Response r = snapshot.data;

            if (r.statusCode == 404) {
              return Center(
                child:
                    Text("No confirmation data is available for this delivery"),
              );
            } else {
              print(
                urlDeliveryConfirmation.replaceAll('api/', '') +
                    "${deliveryModel.id}",
              );
              print(r.statusCode);
              var data = jsonDecode(r.body);
              print(r.body);

              String accountType = preferences.getString(spkAccountType);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Confirmation Details",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  deliveryModel.jobStatus == 3
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                              (pcIp + "/" + data['signatureFilePath'])
                                  .replaceAll('\\', "/")
                                  .replaceAll('/wwwroot', '')),
                        )
                      : Text(""),
                  accountType == "super"
                      ? Column(
                          children: [
                            listTile('Started At', '${data['startAddress']}'),
                            listTile('Ended At', '${data['endAddress']}'),
                          ],
                        )
                      : Text(""),
                ],
              );
            }
          }
        });
  }

  SharedPreferences preferences;

  Future getConfirmationInfo() async {
    //print(urlDeliveryConfirmation + "${deliveryModel.id}");

    preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(spkToken);

    return http.get(
        urlDeliveryConfirmation.replaceAll('api/', '') + "${deliveryModel.id}",
        headers: {
          "content-type": "application/json",
          "authorization": "bearer $token"
        });
  }
}
