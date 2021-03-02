import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gene_deliver/models/comment_model.dart';
import 'package:gene_deliver/models/delivery_model.dart';
import 'package:gene_deliver/models/search_result_model.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message, textColor: Colors.white, backgroundColor: Colors.black);
}

Future<List<DeliveryModel>> fetchMyDeliveries(http.Client client, url) async {
  DefaultCacheManager manager = new DefaultCacheManager();
  manager.emptyCache();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.get(spkToken);

  final response = await client.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${token}',
  });

  return parseDeliveries(response.body);
}

List<DeliveryModel> parseDeliveries(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  List<DeliveryModel> list = parsed
      .map<DeliveryModel>((json) => new DeliveryModel.fromJson(json))
      .toList();
  return list;
}

///comments
Future<List<CommentModel>> fetchDeliveryComments(
    http.Client client, url) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.get(spkToken);

  final response = await client.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${token}',
  });
  // print(response.body);
  return parseComments(response.body);
}

List<CommentModel> parseComments(String responseBody) {
  print(responseBody);

  List<CommentModel> comments = new List<CommentModel>();
  List<dynamic> parsedJson = jsonDecode(responseBody);

  for (int i = 0; i < parsedJson.length; i++) {
    CommentModel commentModel = new CommentModel(
        parsedJson[i]["id"],
        parsedJson[i]["deliveryID"],
        parsedJson[i]["callTime"],
        parsedJson[i]["comment"]);
    comments.add(commentModel);
  }

  return comments;
}

Widget listTile(String titleText, String subtitleText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Material(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "$titleText",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "$subtitleText",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        )),
  );
}

Future<List<SearchResultModel>> fetchSearchResults(String q) async {
  http.Client client = new http.Client();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.get(spkToken);

  final response = await client.post(policySearchUrl, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${token}'},
      body: json.encode({"searchString": "$q"}
    ));

  return parseSearchResults(response.body);
}

List<SearchResultModel> parseSearchResults(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  List<SearchResultModel> list = parsed
      .map<SearchResultModel>((json) => new SearchResultModel.fromJson(json))
      .toList();
  return list;
}
