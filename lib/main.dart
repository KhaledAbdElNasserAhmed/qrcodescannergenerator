import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';
import 'package:qrcode/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';


void main() {
  Wakelock.enable();
  debugPaintSizeEnabled = false;
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MaterialApp(

    home: HomePage2(),
    debugShowCheckedModeBanner: false,

  ));
}

class HomePage2 extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String qr;
  String temp;
  bool camState = false;

  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    Wakelock.enable();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                    'https://mostation.net/App/AppBg.jpg'),
              ),
            ),
            Expanded(
              flex: 1,
                child: camState
                    ? Center(
                        child: SizedBox(
                          child: QrCamera(
                            cameraFacing:CameraFacing.FRONT ,
                            onError: (context, error) => Text(
                              error.toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                            qrCodeCallback: (code) {
                              /* showDialog(
                              context: context,
                              builder: (context) {

                                Future.delayed(Duration(seconds: 5), () {
                                  Navigator.of(context).pop();
                                });
                                return AlertDialog(
                                  title: Text('Welcome Doctor' + qr ),
                                );
                              });*/

                              CollectionReference doctors = FirebaseFirestore
                                  .instance
                                  .collection("doctors");
                              if (qr == null) {
                                qr = code;
                                temp = qr;
                                doctors.add(
                                    {'name': qr, 'dateadded': DateTime.now()});

                                showGeneralDialog(
                                  barrierLabel: "Label",
                                  barrierDismissible: true,
                                  barrierColor: Colors.black.withOpacity(0.4),
                                  transitionDuration:
                                  Duration(milliseconds: 700),
                                  context: context,
                                  pageBuilder: (context, anim1, anim2) {
                                    Future.delayed(Duration(seconds: 5), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return Center(
                                      child: Container(
                                        height: height/3,
                                        child: SizedBox.expand(
                                            child: Material(
                                              child: Center(
                                                child: Text(
                                                  'Welcome $qr',
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight: FontWeight.w900,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: 40),
                                                ),
                                              ),
                                            )),
                                        margin: EdgeInsets.only(
                                            top: 25,
                                            left: 12,
                                            right: 12,
                                            bottom: 25),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                          BorderRadius.circular(40),
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    return SlideTransition(
                                      position: Tween(
                                          begin: Offset(0, true ? -1 : 1),
                                          end: Offset(0, 0))
                                          .animate(anim1),
                                      child: child,
                                    );
                                  },
                                );
                              }

                              if (qr != null && code != temp) {
                                qr = code;
                                temp = qr;
                                doctors.add(
                                    {'name': qr, 'dateadded': DateTime.now()});

                                showGeneralDialog(
                                  barrierLabel: "Label",
                                  barrierDismissible: true,
                                  barrierColor: Colors.black.withOpacity(0.4),
                                  transitionDuration:
                                      Duration(milliseconds: 700),
                                  context: context,
                                  pageBuilder: (context, anim1, anim2) {
                                    Future.delayed(Duration(seconds: 5), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return Center(
                                      child: Container(
                                        height: height/3,
                                        child: SizedBox.expand(
                                            child: Material(
                                          child: Center(
                                            child: Text(
                                              'Welcome $qr',
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 40),
                                            ),
                                          ),
                                        )),
                                        margin: EdgeInsets.only(
                                            top: 25,
                                            left: 12,
                                            right: 12,
                                            bottom: 25),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    return SlideTransition(
                                      position: Tween(
                                              begin: Offset(0, true ? -1 : 1),
                                              end: Offset(0, 0))
                                          .animate(anim1),
                                      child: child,
                                    );
                                  },
                                );
                              }
                              ;

                              setState(() {
                                // showDialog(context: context , builder: (BuildContext context) { return Container(height: 10.0 , width: 10.0, color: Colors.white,);});
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: Colors.orange,
                                    width: 10.0,
                                    style: BorderStyle.solid),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(child: Text("Camera inactive"))),
          ],
        ),
      ),
      floatingActionButton:  Opacity (
        opacity: !camState ? 1 : 0,
        child: FloatingActionButton(
            child: Text(
              "press me",
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              setState(() {
                camState = !camState;
              });
            }),
      ),
    );
  }
}

void _showAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Wifi"),
            content: Text("Wifi not detected. Please activate it."),
          ));
}

class PopUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PopUpState();
}

class PopUpState extends State<PopUp> with TickerProviderStateMixin {
  AnimationController controller;
  double _bottom = 0, _fromTop = 300, _screenHeight, _containerHeight = 300;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener(() {
        Timer.periodic(Duration(milliseconds: 15), (timer) {
          if (_bottom < _screenHeight - _fromTop - _containerHeight) {
            _bottom += 1;
            setState(() {});
          }
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: _bottom,
            left: 0,
            right: 0,
            child: Container(height: _containerHeight, color: Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
