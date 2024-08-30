import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workermanager/firebase_options.dart';


class ScanPage extends StatefulWidget {
  //const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR 스캔"),
        actions: [
          // IconButton(
          //   //icon: Icon(Icons.navigate_before),
          //   // 로그아웃 버튼이 클릭되면 _signOut 함수를 비동기적으로 호출
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 2, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(
                            result!.format)}' + '\n' + 'Data: ${result!.code}')

                  else
                    const Text('Scan a code'),


                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {

                        _showdialog(context);

                      },
                      child: Text("send", style: TextStyle(fontSize: 20)),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}', style: TextStyle(fontSize: 20));
                              },
                            )),
                      ),

                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}', style: TextStyle(fontSize: 20));
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      ),


                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 20,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('확인'),
        content: Text('데이터를 전송하시겠습니까?'),
        actions: [

          ElevatedButton(
            child: Text("예"),
            onPressed: () {

              String? sentence = result!.code;

              List<String> parts = sentence!.split('\n');
              //name : seoyujin, age : 24, blood : O, phone : 01012345678

              String pa1 = parts[0].toString();
              String pa2 = parts[1].toString();
              String pa3 = parts[2].toString();
              String pa4 = parts[3].toString();

              String nm = pa1.substring(7);
              String ag = pa2.substring(6);
              String bl = pa3.substring(8);
              String ph = pa4.substring(8);


              final now = new DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

              // return 부분에서 now 대신 formattedDate 를 사용한다. 어차피 now 못 씀.
              //Text('$formattedDate');
              print(formattedDate);


              FirebaseFirestore.instance.collection('commute')
                  .doc(formattedDate).collection('workers').doc(nm)
                  .set({ 'name': nm,
                'age': ag,
                'blood': bl,
                'phone': ph,
              });

              Navigator.pop(context);
            },
          ),

          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('아니요')),
        ],
        elevation: 10.0,
        // backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
      ),
    );
  }
}


