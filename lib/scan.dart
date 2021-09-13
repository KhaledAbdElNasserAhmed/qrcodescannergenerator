import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakelock/wakelock.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';


class ScanPage extends StatefulWidget {

  @override

  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference doctors = FirebaseFirestore.instance.collection("doctors");

  String qrCodeResult = "Not Yet Scanned";
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(

      appBar: AppBar(
        title: Text("Scanner"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                Wakelock.enable();

                String codeSanner = await BarcodeScanner.scan();    //barcode scnner
                setState(() async{

                  qrCodeResult = codeSanner;

                  await doctors.add({
                    'name': codeSanner,
                    'dateadded' : DateTime.now()
                  });

                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 10), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          title: Text('Welcome ' + codeSanner ),
                        );
                      });
                });

                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }


              },
              child: Text(
                "Open Scanner",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            )
          ],
        ),
      ),
    );
  }

  //its quite simple as that you can use try and catch staatements too for platform exception
}
