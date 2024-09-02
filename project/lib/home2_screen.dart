// main.dart -> 관리자 홈 (완료)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workermanager/login_screen.dart';
import 'package:workermanager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workermanager/scan_page.dart';
import 'package:workermanager/address_screen.dart';
import 'package:workermanager/readdata_page.dart';
import 'package:workermanager/connection_page.dart';
import 'package:workermanager/list_page.dart';


// 관리자 페이지

String datas = '';
String name = '';
String email = '';
String age = '';
String blood = '';
String phone = '';

// String greet = '안녕하세요';
// String logSuc = '로그인에 성공하였습니다.';


class Home2Page extends StatefulWidget {

  // 사용자 정보를 담고 있는 User 객체를 final로 선언
  final User user;

  // 생성자에서 user를 필수 인자로 받음. required 키워드로 null이 아닌 값을 보장
  Home2Page({required this.user});

  @override
  State<Home2Page> createState() => _Home2PageState();
}

class _Home2PageState extends State<Home2Page> {

  bool _qrGenerated = false; //생성 버튼을 눌렀을때, 등장하게끔

  // 초기화
  @override
  void initState(){
    super.initState();

    // greet = '안녕하세요';
    // logSuc = '로그인에 성공하였습니다.';

    // getDocument()로 버튼 눌렀을 때 한 번만 했더니 QR이 생성버튼 두번 눌러야 제대로 나온다
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user != null) {
        email = user.email!;
        // print('initState() 안에 '+email);
      }
    });

    getManDocument();

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false, //우측상단 빨간색 DEBUG 띠 없애기
      home : Scaffold(
        appBar: AppBar(
          title: Text("로그인 성공"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              // 로그아웃 버튼이 클릭되면 _signOut 함수를 비동기적으로 호출
              onPressed: () async {
                await _sign2Out(context);
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 사용자의 이메일을 화면에 표시
                Text("환영합니다, ${name} 관리자님!", style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text("로그인에 성공하였습니다.", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                // 로그아웃 버튼을 배치 클릭 시 _signOut 함수를 호출
                ElevatedButton(
                  onPressed: () {
                    _sign2Out(context);
                  },
                  child: Text("로그아웃"),
                ),

                SizedBox(height: 10),
                // 추가
                // ElevatedButton(
                //   onPressed: () {
                //
                //     getManDocument();
                //     _showdialog(context);
                //
                //     // greet = '환영합니다';
                //     // logSuc = '';
                //
                //     // setState(() {
                //     //   _qrGenerated = !_qrGenerated;  //버튼을 누르면  qr나타나게끔 구성
                //     // });
                //     // getDocument() 가 여기 있으니 처음 QR생성하면 제대로 생성되지 않는 문제 발생
                //
                //   },
                //   child: Text("qr코드 생성"),
                // ),
                // // 정보 입력하는 화면 아래에 qr코드 생성
                // Container(
                //   child: _qrGenerated
                //       ? QrImageView(
                //     data : datas,
                //     version: QrVersions.auto,
                //     size: 250,
                //   ) : const SizedBox.shrink(),
                // ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScanPage()));
                  },
                  child: Text("QR코드 스캔"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListPage()));
                  },
                  child: Text("근로자 통근 목록 보기"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddressPage()));
                  },
                  child: Text("근로지 주소 입력"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReaddataPage()));
                  },
                  child: Text("데이터 확인하기"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConnectionPage()));
                  },
                  child: Text("esp32 연결 확인하기"),
                ),

                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _signOut 함수는 로그아웃을 처리하는 비동기 함수
  Future<void> _sign2Out(BuildContext context) async {
    try {
      // FirebaseAuth의 signOut 메서드를 호출하여 사용자를 로그아웃
      await FirebaseAuth.instance.signOut();
      // 로그아웃 후 현재 페이지를 종료하고 이전 화면으로 돌아감


      // Navigator.of(context).pop();  // 이전 화면이 없나 안뜬다
      // Navigator.pop(context);  //이걸로 수정 -> 얘도 안된다

      // 얘로 수정함
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SignInPage()));
      // 얘로 하면 로그인 페이지로 넘어가지긴 한다



      // 이것도 한 번 해보기
      // 회원 탈퇴 시 기존 스택에 쌓아둔 페이지 다 날리고 메인 화면으로 이동
      // Navigator.of(context).pushAndRemoveUntil(
      //     CupertinoPageRoute(builder: (context) => MyApp()),
      //         (route) => false
      // );
      // 여기까지



    } catch (e) {
      // 로그아웃 과정에서 오류가 발생한 경우 사용자에게 알림을 제공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("로그아웃 중 오류가 발생했습니다."),
        ),
      );
    }
  }

  // Future<dynamic> _showdialog(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: Text('확인'),
  //       content: Text('가입 시 입력된 정보로 QR코드를 생성하시겠습니까?'),
  //       actions: [
  //
  //         ElevatedButton(
  //           child: Text("QR 생성"),
  //           onPressed: () {
  //
  //             // getWorDocument();
  //
  //             // greet = '환영합니다';
  //             // logSuc = '';
  //
  //             setState(() {
  //               // getWorDocument();
  //               // _qrGenerated = !_qrGenerated;  //버튼을 누르면  qr나타나게끔 구성
  //               _qrGenerated = true;
  //             });
  //
  //             Navigator.pop(context);
  //           },
  //         ),
  //
  //         ElevatedButton(
  //           child: Text('QR 삭제'),
  //           onPressed: (){
  //             setState(() {
  //               // _qrGenerated = !_qrGenerated;  //버튼을 누르면  qr나타나게끔 구성
  //               _qrGenerated = false;
  //             });
  //
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //       elevation: 10.0,
  //       // backgroundColor: Colors.pink,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(32)),
  //       ),
  //     ),
  //   );
  // }

}


// 여기부터 추가
Future<void> getManDocument() async {

  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
        if (user != null) {
          email = user.email!;
          // print(email);
        }
      });

  // print(email);

  // 참조할 문서 정의하기
  DocumentReference documentRef =
  FirebaseFirestore.instance.collection('member').doc(email);

  // 비동기적으로 데이터 호출하기
  DocumentSnapshot documentSnapshot = await documentRef.get();


  // DocumentSnapshot의 Object를 data()를 사용하여 Map타입으로 변환하기
  if (documentSnapshot.exists) {
    Map<String, dynamic> data =
    documentSnapshot.data() as Map<String, dynamic>;
    //print(data);
    // debugPrint(data['user'].toString()); // 데이터가 리스트인 경우 출력
    //debugPrint(data['contents']); // 문서 데이터 출력
    // debugPrint(data['title']); // 문서 데이터 출력

    // sort = await data['division'];
    // print("login_screen.dart getDocument ${sort}"); // 확인

    datas = "name : " + data['name'] + "\n"
        + "age : " + data['age'] + "\n"
        + "blood : " + data['blood'] + "\n"
        + "phone : " + data['phone'] + "\n";

    // print(datas);

    name = data['name'];

  }
}

