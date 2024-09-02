// 관리자가 오늘 통근한 근로자 리스트 날짜>명단 볼 수 있는 화면
// 여기서는 명단 보인다 (진행 중)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workermanager/address_screen.dart';
import 'package:workermanager/login_screen.dart';
import 'package:workermanager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kpostal/kpostal.dart';
import 'package:intl/intl.dart';
import 'package:workermanager/Model.dart';


// 근로자 페이지

String name = '';
String email = '';
String age = '';
String blood = '';
String phone = '';

String whatday = '';



// class ListData {
//   final String name;
//   final String age;
//   final String blood;
//   final String phone;
//
//   ListData(this.name, this.age, this.blood, this.phone);
// }
class ListTitle extends StatelessWidget {
  ListTitle(this._data);
  final ListData _data;

  @override
  Widget build(BuildContext context) {
    // (w) ListTile 기본형.
    return ListTile(
      title: Text(_data.name),
      subtitle: Text("나이 : ${_data.age}, 혈액형 : ${_data.blood}, 전화번호 : ${_data.phone}"),
    );
  }
}

// class ListDatas {
//   final int count;
//   final String title;
//   final bool isInterest;
//
//   ListDatas(this.count, this.title, this.isInterest);
// }
// class DemoListTile extends StatelessWidget {
//   DemoListTile(this._data);
//
//   final ListDatas _data;
//
//   @override
//   Widget build(BuildContext context) {
//     // (w) ListTile 기본형.
//     return ListTile(
//       title: Text(_data.title),
//       subtitle: Text("조회수 ${_data.count}"),
//     );
//   }
// }

// List<List<String>> list = [];
// final List<ListData> content = [];
List<ListData> content = [];
// final List<ListDatas> contents = [];

class List2Page extends StatefulWidget {
  const List2Page({super.key, required this.ldata});

  // final ListData ldata;
  final DateList ldata;

  @override
  State<List2Page> createState() => _List2PageState();
}



class _List2PageState extends State<List2Page> {


  // 초기화
  @override
  void initState(){
    super.initState();

    // whatday = this.ldata;
    whatday = widget.ldata.date;
  }

  @override
  Widget build(BuildContext context) {
    print(whatday);
    // content.clear();
    print('before getList');
    getListDocument();
    print('after getList');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Builder ListView Page'),
      ),
      body: SafeArea(
        // ListView.builder - ListView Data 연결.
        child: ListView.builder(

          itemCount: content.length,
          itemBuilder: (BuildContext context, int index) {

            // return Card(
            //   child: ListTile(
            //     title: Text(content[index].name),
            //     // leading argument는 앱바에서 왼쪽에 아이콘 넣을때 사용했던 걔임
            //     // leading: SizedBox(
            //     //   height: 50,
            //     //   width: 50,
            //     //   child: Image.asset(content[index].imgPath),
            //     // ),
            //     onTap: (){
            //       // debugPrint(animalData[index].name);
            //       //Navigator.of(context).push(MaterialPageRoute(
            //       //    builder: (context) => AnimalPage(animal: animalData[index],)
            //       //);
            //     },
            //   ),
            // );

            // whatday = widget.ldata.date;

            print('itemBuilder In');

            return ListTitle(content[index]);

          },
        ),
      ),
    );
  }
}

// 여기부터 추가
Future<void> getListDocument() async {

  // FirebaseFirestore.instance.collection('commute')
  //     .doc(formattedDate).collection('workers').doc(nm)
  //     .set({ 'name': nm,
  //   'age': ag,
  //   'blood': bl,
  //   'phone': ph,
  // });

  // for(int i = 0; i < 8; i++) {
  //   datas.add(ListDatas(i, 'Swift${i}', true));
  // }

  print('getListDocument() In');

  final now = new DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Map<String, dynamic> gab = Map();
  var num = 0;

  FirebaseFirestore.instance
      .collection('commute').doc(whatday).collection('workers')
      .get()
      .then(
        (querySnapshot) {
      print("Successfully completed");
      int i = 0;

      num = querySnapshot.docs.length;
      print(num);
      if(content.length < num){
        for (var docSnapshot in querySnapshot.docs) {  // 모든 데이터를 다 읽어온다


          print('${docSnapshot.id} => ${docSnapshot.data()}');
          gab = docSnapshot.data() as Map<String, dynamic>;
          print('${docSnapshot.id} => ${gab['name']}');
          print('${docSnapshot.id} => ${gab['age']}');
          print('${docSnapshot.id} => ${gab['blood']}');
          print('${docSnapshot.id} => ${gab['phone']}');


          name = gab['name'].toString();
          age = gab['age'].toString();
          blood = gab['blood'].toString();
          phone = gab['phone'].toString();
          print(name + age + blood + phone);


          content.add(ListData(name, age, blood, phone));
          // content.add(ListData(gab['name'],gab['age'], gab['blood'], gab['phone']));
          print('${content[i].age}, ${content[i].blood}');
          print(content[i]);
          print(content[i].age.runtimeType);
          i += 1;

          print(gab.runtimeType);
          print(name.runtimeType);
          print(age.runtimeType);
          print(blood.runtimeType);
          print(phone.runtimeType);
          print(content.runtimeType);



        }
      }


      print(content);
    },
    onError: (e) => print("Error completing: $e"),
  );
}
