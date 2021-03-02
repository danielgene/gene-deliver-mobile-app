import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gene_deliver/other/constants.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePad extends StatefulWidget {
  final int deliveryId;

  const SignaturePad(this.deliveryId);

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState.clear();
  }

  bool showProgressloading = false;

  void _handleSaveButtonPressed() async {
    setState(() {
      showProgressloading = true;
    });

    final data = await signatureGlobalKey.currentState.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(bytes.buffer.asUint8List());

    if (data != null) {
      Dio dio = new Dio();

      String endLocation;
      String endAddress;

      try {
        Position position; position = await Geolocator.getCurrentPosition(  desiredAccuracy: LocationAccuracy.high);

        if (position == null) {
          position = await Geolocator.getLastKnownPosition();
        }

        final coordinates = new Coordinates(position.latitude, position.longitude);

        print(coordinates.latitude);
        print(coordinates.longitude);

        List<Address> addresses;
        Address first;
        addresses =  await Geocoder.local.findAddressesFromCoordinates(coordinates);
        endAddress = addresses.first.addressLine;
        endLocation = "${position.latitude.toString()}" + " , " + "${position.longitude.toString()}";
        print(endLocation);

      } on Exception catch (e) {
        endLocation = "0000 , 0000";
        endAddress = "Unable to find current address";
        Fluttertoast.showToast(msg: "Location not found");
      }

      FormData formData = new FormData.fromMap({
        "deliveryId": widget.deliveryId,
        "startAddress": "test start address",
        "endAddress": endAddress,
        "startLocation": "",
        "endLocation": endLocation,
        "SignatureFile": await MultipartFile.fromFile(file.path,
            filename: "upload-file.png"),
      });

      try {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

        print(urlDeliveryConfirmation.replaceAll('api/', ''));

        var response = await dio.post(
            urlDeliveryConfirmation.replaceAll('api/', ''),
            options: Options(contentType: 'multipart/form-data'),
            data: formData);

        setState(() {
          showProgressloading = false;
        });

        if (response.statusCode == 201) {
          showAlertDialog(context, "Process has completed succesfully", () {
            Navigator.pop(context);
            Navigator.pop(context, "completed");
          });
        } else {
          showAlertDialog(context, "Something went wrong please try again", () {
            Navigator.pop(context);
          });
        }
      } catch (e) {
        setState(() {
          showProgressloading = false;
        });

        showAlertDialog(context, "Something went wrong please try again", () {
          Navigator.pop(context);
        });

        print(e.toString());
      }
    } else {
      setState(() {
        showProgressloading = false;
      });

      showAlertDialog(context, "Something went wrong please try again", () {
        Navigator.pop(context);
      });

      //Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  showAlertDialog(BuildContext context, String message, Function function) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: function,
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Alert",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Text("${message}"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgressloading,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Sign Pad"),
          ),
          body: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          child: SfSignaturePad(
                              key: signatureGlobalKey,
                              backgroundColor: Colors.white,
                              strokeColor: Colors.black,
                              minimumStrokeWidth: 1.0,
                              maximumStrokeWidth: 4.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)))),
                  SizedBox(height: 10),
                  Row(children: <Widget>[
                    GFButton(
                      child: Text('Proceed'),
                      onPressed: _handleSaveButtonPressed,
                    ),
                    GFButton(
                      color: Colors.red,
                      child: Text('Clear'),
                      onPressed: _handleClearButtonPressed,
                    )
                  ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
          )),
    );
  }
}
