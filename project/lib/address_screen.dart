// 관리자 홈에서 주소 입력 버튼 누르면 주소 검색하는 화면 (완료)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workermanager/login_screen.dart';
import 'package:workermanager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kpostal/kpostal.dart';
import 'package:intl/intl.dart';


// 주소 입력하는 창 만드는데서 문제 발생
// (웹뷰? 연결이 제대로 안되는 문제 발생)
// 이런 오류 발생 -> net:ERR_CLEARTEXT_NOT_PERMITTED
// android/app/src/main/AndroidManifest.xml에서
// <application>안에
// android:enableOnBackInvokedCallback="true"
// android:usesCleartextTraffic="true"
// 얘네 두개 추가해줬더니 된다


// 근로자 페이지


String datas = '';
String name = '';
String email = '';
String age = '';
String blood = '';
String phone = '';


class AddressPage extends StatefulWidget {

  // 사용자 정보를 담고 있는 User 객체를 final로 선언
  //final User user;

  // 생성자에서 user를 필수 인자로 받음. required 키워드로 null이 아닌 값을 보장
  //AddressPage({required this.user});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final addressController = TextEditingController();
  bool _qrGenerated = false; //생성 버튼을 눌렀을때, 등장하게끔


  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';


  // 초기화
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("근로지 입력"),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   // 로그아웃 버튼이 클릭되면 _signOut 함수를 비동기적으로 호출
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KpostalView(
                        useLocalServer: true,
                        localPort: 29460,
                        // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                        callback: (Kpostal result) {
                          setState(() {
                            this.postCode = result.postCode;
                            this.address = result.address;
                            this.latitude = result.latitude.toString();
                            this.longitude = result.longitude.toString();
                            this.kakaoLatitude = result.kakaoLatitude.toString();
                            this.kakaoLongitude =
                                result.kakaoLongitude.toString();
                          });
                        },
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue)),
                child: Text(
                  '주소 검색',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Text('우편번호',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('result: ${this.postCode}'),
                    Text('주소',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('result: ${this.address}'),
                    Text('위도경도', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('위도: ${this.latitude}'),
                    Text('경도: ${this.longitude}'),
                    // Text('through KAKAO Geocoder',
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                    // Text(
                    //     'latitude: ${this.kakaoLatitude} / longitude: ${this.kakaoLongitude}'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {

                  _showdialog(context);

                  // final now = new DateTime.now();
                  // String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  //
                  // FirebaseFirestore.instance.collection('address')
                  //     .doc(formattedDate)
                  //     .set({ 'postcode': this.postCode,
                  //   'address': this.address,
                  //   'latitude': this.latitude,
                  //   'longitude': this.longitude,
                  // });
                },
                child: Text("근로지 주소 저장"),
              ),












              // TextField(
              //   controller: addressController,
              //   decoration: InputDecoration(labelText: "이메일"),
              // ),
              // // 추가
              // ElevatedButton(
              //   onPressed: () {
              //
              //
              //
              //
              //   },
              //   child: Text("주소 검색", style: TextStyle(fontSize: 20)),
              // ),


              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _signOut 함수는 로그아웃을 처리하는 비동기 함수
  Future<void> _signOut(BuildContext context) async {
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

  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('확인'),
        content: Text('주소를 저장하시겠습니까?'),
        actions: [

          ElevatedButton(
            child: Text("예"),
            onPressed: () {

              final now = new DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

              FirebaseFirestore.instance.collection('address')
                  .doc(formattedDate)
                  .set({ 'postcode': this.postCode,
                'address': this.address,
                'latitude': this.latitude,
                'longitude': this.longitude,
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

// 여기부터 추가
Future<void> getWorDocument() async {

  print('home_screen에 getD() 안에 user 실행 전');

  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user != null) {
      email = user.email!;
      // print(email);
    }
  });

  print('home_screen에 getD() 안에 user 실행 후');

  print(email);

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

    // sort = data['division'];
    // print("main.dart ${sort}"); // 확인

    datas = "name : " + data['name'] + "\n"
        + "age : " + data['age'] + "\n"
        + "blood : " + data['blood'] + "\n"
        + "phone : " + data['phone'] + "\n";

    print(datas);

    name = data['name'];

    print('home_screen에 getD() 실행 완');

  }
}

