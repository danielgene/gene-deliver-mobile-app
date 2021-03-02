import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gene_deliver/models/policy_model.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:gene_deliver/other/methods.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

class ViewPolicy extends StatefulWidget {
  final String policyGmcc;

  const ViewPolicy(this.policyGmcc);

  @override
  _StateViewPolicy createState() => _StateViewPolicy();
}

class _StateViewPolicy extends State<ViewPolicy> {
  Future<PolicyModel> getPolicy() async {
    var r = await http.post(policyDetailUrl,
        headers: {"content-type":"application/json"},
        body: json.encode({"txtvalue": widget.policyGmcc}));
    if (r.statusCode == 200) {
      return PolicyModel.fromJson(json.decode(r.body));
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Policy Details"),
      ),
      body: FutureBuilder(
          future: getPolicy(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              PolicyModel policyModel = snapshot.data;
              return SingleChildScrollView(
                child: Column(children: [
                  listTile("Customer Name", policyModel.customerName),
                  listTile("Policy Number", "${policyModel.policyNo}"),
                  listTile("Policy Id", "${policyModel.policyId}"),
                  listTile("Amount Due", "${policyModel.amountDue}"),
                  listTile("Balance", "${policyModel.balance}"),
                  listTile("Amount Paid", "${policyModel.amountPaid}"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GFButton(onPressed: (){},
                    text: "Add Payment",
                      fullWidthButton: true,
                    ),
                  )
                ],),
              );
            } else {
              return Text("${snapshot.error}");
            }
          }),
    );
  }
}
