import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:makeqr/scan_page.dart';

String datas = "";

/// The example application class
class MakePage extends StatefulWidget{
  @override
  State<MakePage> createState() => _MakePageState();
}

class _MakePageState extends State<MakePage> {
  bool _qrGenerated = false; //생성 버튼을 눌렀을때, 등장하게끔


  // 초기화
  @override
  void initState(){
    super.initState();

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController bloodController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();


    return MaterialApp(
      debugShowCheckedModeBanner: false, //우측상단 빨간색 DEBUG 띠 없애기
      home : Scaffold(
        appBar: AppBar(
          title: const Text("Flutter App"),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(
                  Alignment.bottomRight.x, Alignment.bottomRight.y - 0.2),
              child: FloatingActionButton(
                onPressed: () { //making,
                  setState(() {
                    _qrGenerated = !_qrGenerated;  //버튼을 누르면  qr나타나게끔 구성
                  });

                  datas = "name : " + nameController.text + "\n"
                            + "age : " + ageController.text + "\n"
                            + "blood : " + bloodController.text + "\n"
                            + "phone : " + phoneController.text + "\n";
                },
                child: const Icon(Icons.qr_code),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () { //scanning,
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRViewExample()), // ScanPage()),
                  );
                },
                child: Icon(Icons.camera_alt_outlined),

              ),
            ),
          ],
        ),

        body: Center(
          child: SingleChildScrollView(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text("QR 코드 생성 정보", style: TextStyle(fontSize: 20)
                      ,),
                  ),

                  Container(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: '이름',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelText: '나이',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: bloodController,
                      decoration: InputDecoration(
                        labelText: '혈액형',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: '전화번호',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  // 정보 입력하는 화면 아래에 qr코드 생성
                  Container(
                    child: _qrGenerated
                        ? QrImageView(
                      data : datas,
                      version: QrVersions.auto,
                      size: 250,
                    ) : const SizedBox.shrink(),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}

