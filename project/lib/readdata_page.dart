// 파이어스토어의 값 변화를 실시간으로 감지하여 값 읽어오는 페이지 (진행 중)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workermanager/login_screen.dart';
import 'package:workermanager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//데이터 변화 감지

String datas = '';
String name = '';
String email = '';
String age = '';
String blood = '';
String phone = '';


class ReaddataPage extends StatefulWidget {
  @override
  State<ReaddataPage> createState() => _ReaddataPageState();
}

class _ReaddataPageState extends State<ReaddataPage> {


  // 초기화
  @override
  void initState(){
    super.initState();
  }

  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('emergency').snapshots();

  // FirebaseFirestore.instance.collection('commute')
  //     .doc(formattedDate).collection('workers').doc(nm)
  //     .set({ 'name': nm,
  // 'age': ag,
  // 'blood': bl,
  // 'phone': ph,
  // });

  // FirebaseFirestore.collection('messeges').doc('state').set(
  // {'sender': loggedInUser.email,
  // 'text': messageText}
  // );


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('emergency').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ));
        }

        final messages = snapshot.data?.docs;
        List<Text> messageWidgets = [];

        for (var message in messages!) {
          final messageText = message.data()?['state'];
          final messageSender = message.data()['prestate'];
          final messageWidget =
          Text('$messageText from $messageSender');
          messageWidgets.add(messageWidget);
        }

        return Column(
          children: messageWidgets,
        );
      },
    );




    // return StreamBuilder<QuerySnapshot>(
    //   stream: _usersStream,
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return const Text('Something went wrong');
    //     }
    //
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Text("Loading");
    //     }
    //
    //     // if (snapshot.hasData) {
    //     //   return _buildList()
    //     // }
    //     // else if (snapshot.hasError) {
    //     //   const Text('No data avaible right now');
    //     // }
    //     // return Center(child: CircularProgressIndicator());
    //
    //
    //
    //     // 여기부터 추가
    //
    //     // final docRef = FirebaseFirestore.instance.collection("emergency").doc("state");
    //     // docRef.snapshots().listen(
    //     //       (event) {
    //     //     final source = (event.metadata.hasPendingWrites) ? "Local" : "Server";
    //     //     print("$source data: ${event.data()}");
    //     //   },
    //     //   onError: (error) => print("Listen failed: $error"),
    //     // );
    //
    //     FirebaseFirestore.instance
    //         .collection("emergency")
    //         .where("state", isEqualTo: "0")
    //         .snapshots()
    //         .listen((event) {
    //       for (var change in event.docChanges) {
    //         switch (change.type) {
    //           case DocumentChangeType.added:
    //             print("New City: ${change.doc.data()}");
    //             break;
    //           case DocumentChangeType.modified:
    //             print("Modified City: ${change.doc.data()}");
    //             break;
    //           case DocumentChangeType.removed:
    //             print("Removed City: ${change.doc.data()}");
    //             break;
    //         }
    //       }
    //     });
    //
    //
    //     // return StreamBuilder<QuerySnapshot>(
    //     //   stream: FirebaseFirestore.instance.collection('emergency').snapshots(),
    //     //   builder: (context, snapshot) {
    //     //     if (!snapshot.hasData) {
    //     //       return Center(
    //     //           child: CircularProgressIndicator(
    //     //             backgroundColor: Colors.lightBlueAccent,
    //     //           ));
    //     //     }
    //     //
    //     //     final messages = snapshot.data.docs;
    //     //     List<Text> messageWidgets = [];
    //     //
    //     //     for (var message in messages) {
    //     //       final messageText = message.data()['text'];
    //     //       final messageSender = message.data()['sender'];
    //     //       final messageWidget =
    //     //       Text('$messageText from $messageSender');
    //     //       messageWidgets.add(messageWidget);
    //     //     }
    //     //
    //     //     return Column(
    //     //       children: messageWidgets,
    //     //     );
    //     //   },
    //     // ),
    //
    //
    //
    //     // final commentsRef = FirebaseFirestore.instance.collection("emergency");
    //     // commentsRef.onChildChanged.listen((event) {
    //     //   // A comment has changed; use the key to determine if we are displaying this
    //     //   // comment and if so displayed the changed comment.
    //     // });
    //
    //
    //     // StreamBuilder(
    //     //     stream: FirebaseFirestore.instance.collection("emergency").snapshots(),
    //     //     builder: ((context, snapshot) {
    //     //       return Container(
    //     //         child: ElevatedButton(
    //     //           onPressed: () {
    //     //             // Navigator.of(context).push(MaterialPageRoute(
    //     //             //     builder: (context) => AddressPage()));
    //     //
    //     //             if(snapshot != null){
    //     //               Map<String, dynamic> data =
    //     //               snapshot.data() as Map<String, dynamic>;
    //     //             }
    //     //
    //     //
    //     //           },
    //     //           child: Text("데이터 확인하기"),
    //     //         ),
    //     //       );
    //     //     }));
    //
    //
    //     // 여기까지 추가
    //
    //     return ListView(
    //       children: snapshot.data!.docs
    //           .map((DocumentSnapshot document) {
    //         Map<String, dynamic> data =
    //         document.data()! as Map<String, dynamic>;
    //         return ListTile(
    //           title: Text(data['full_name']),
    //           subtitle: Text(data['company']),
    //         );
    //       })
    //           .toList()
    //           .cast(),
    //     );
    //   },
    // );
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

              // FirebaseFirestore.instance.collection('address')
              //     .doc(formattedDate)
              //     .set({ 'postcode': this.postCode,
              //   'address': this.address,
              //   'latitude': this.latitude,
              //   'longitude': this.longitude,
              // });

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

