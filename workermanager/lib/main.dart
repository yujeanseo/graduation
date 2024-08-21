import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:workermanager/login_screen.dart';
import 'package:workermanager/register_screen.dart';
import 'package:workermanager/home_screen.dart';
import 'package:workermanager/home2_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


var sort = "worker";  // 변수 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());    //runApp(SignUpPage());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // StreamBuilder를 사용하여 FirebaseAuth의 인증 상태 변경을 감지
      home: StreamBuilder<User?>(
        // FirebaseAuth.instance.authStateChanges()는 사용자 인증 상태가 변경될 때마다 스트림을 통해 알림
        stream: FirebaseAuth.instance.authStateChanges(),
        // 스트림의 데이터(인증 상태 변경)가 업데이트 될 때마다 builder 함수가 호출됩니다.
        builder: (context, snapshot) {
          // snapshot.connectionState가 active 상태인 경우, 인증 상태 변경 정보가 준비
          if (snapshot.connectionState == ConnectionState.active) {
            // user 변수에 현재 인증된 사용자 정보를 할당
            User? user = snapshot.data;
            // user가 null인 경우, 사용자가 로그아웃 상태임을 의미하므로 SignInPage()를 반환
            if (user == null) {
              return SignInPage();
            }

            // 여기부터 추가
            else{
              getDocument(user.email);


              // FirebaseFirestore.instance
              //     .collection('member')
              //     .get()
              //     .then(
              //       (querySnapshot) {
              //     print("Successfully completed");
              //     for (var docSnapshot in querySnapshot.docs) {  // 모든 데이터를 다 읽어온다
              //       //print('${docSnapshot.id} => ${docSnapshot.data()}');
              //       Map<String, dynamic> data =
              //                     documentSnapshot.data() as Map<String, dynamic>;
              //
              //
              //       // if (docSnapshot.division == 'worker') {
              //       //
              //       // }
              //     }
              //   },
              //   onError: (e) => print("Error completing: $e"),
              // );
              if (sort == "worker") {
                return HomePage(user: user);
              }
              else if (sort == "manager") {
                return Home2Page(user: user);
              }
            }
            // 여기까지 추가



            // user가 null이 아닌 경우, 사용자가 로그인 상태임을 의미하므로 HomePage()를 반환
            /////return HomePage(user: user);




          }
          // 스트림의 연결 상태가 active 상태가 아닌 경우 로딩 인디케이터를 표시
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
// 여기부터 추가
Future<void> getDocument(var em) async {
  // 참조할 문서 정의하기
  DocumentReference documentRef =
  FirebaseFirestore.instance.collection('member').doc(em);

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

    sort = data['division'];
    print(sort); // 확인
  }
}
// 여기까지 추가



////////////////
// // 앱의 메인 함수,  앱 실행의 시작점입니다.
// // void main() => runApp(MyApp());
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
// var sort = "";
//
// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // StreamBuilder를 사용하여 FirebaseAuth의 인증 상태 변경을 감지
//       home: StreamBuilder<User?>(
//         // FirebaseAuth.instance.authStateChanges()는 사용자 인증 상태가 변경될 때마다 스트림을 통해 알림
//         stream: FirebaseAuth.instance.authStateChanges(),
//         // 스트림의 데이터(인증 상태 변경)가 업데이트 될 때마다 builder 함수가 호출됩니다.
//         builder: (context, snapshot) {
//           // snapshot.connectionState가 active 상태인 경우, 인증 상태 변경 정보가 준비
//           if (snapshot.connectionState == ConnectionState.active) {
//             // user 변수에 현재 인증된 사용자 정보를 할당
//             User? user = snapshot.data;
//             // user가 null인 경우, 사용자가 로그아웃 상태임을 의미하므로 SignInPage()를 반환
//             if (user == null) {
//               return SignInPage();
//             }
//             else{
//               getDocument(user.email);
//
//
//               // FirebaseFirestore.instance
//               //     .collection('member')
//               //     .get()
//               //     .then(
//               //       (querySnapshot) {
//               //     print("Successfully completed");
//               //     for (var docSnapshot in querySnapshot.docs) {  // 모든 데이터를 다 읽어온다
//               //       //print('${docSnapshot.id} => ${docSnapshot.data()}');
//               //       Map<String, dynamic> data =
//               //                     documentSnapshot.data() as Map<String, dynamic>;
//               //
//               //
//               //       // if (docSnapshot.division == 'worker') {
//               //       //
//               //       // }
//               //     }
//               //   },
//               //   onError: (e) => print("Error completing: $e"),
//               // );
//               if (sort == "worker") {
//                 return HomePage(user: user);
//               }
//               else if (sort == "manager") {
//                 return Home2Page(user: user);
//               }
//             }
//
//
//             // user가 null이 아닌 경우, 사용자가 로그인 상태임을 의미하므로 HomePage()를 반환
//             // return HomePage(user: user);
//
//
//
//           }
//           // 스트림의 연결 상태가 active 상태가 아닌 경우 로딩 인디케이터를 표시
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
// Future<void> getDocument(var em) async {
//   // 참조할 문서 정의하기
//   DocumentReference documentRef =
//   FirebaseFirestore.instance.collection('member').doc(em);
//
//   // 비동기적으로 데이터 호출하기
//   DocumentSnapshot documentSnapshot = await documentRef.get();
//
//
//   // DocumentSnapshot의 Object를 data()를 사용하여 Map타입으로 변환하기
//   if (documentSnapshot.exists) {
//     Map<String, dynamic> data =
//     documentSnapshot.data() as Map<String, dynamic>;
//     //print(data);
//     // debugPrint(data['user'].toString()); // 데이터가 리스트인 경우 출력
//     //debugPrint(data['contents']); // 문서 데이터 출력
//     // debugPrint(data['title']); // 문서 데이터 출력
//
//     sort = data['division'];
//   }
// }
////////////////




//
// // StatelessWidget을 상속받는 MyApp 클래스를 정의합니다.
// // 이 클래스는 앱의 루트  위젯 역할을 합니다.
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // MaterialApp 위젯을 반환하여 앱의 기본적인 디자인을 설정합니다.
//     return MaterialApp(
//       // 앱의 홈 화면으로 FutureBuilder를 사용합니다.
//       // FutureBuilder는 비동기 작업의 결과에 따라 위젯을 구성할 수 있게 해줍니다.
//       home: FutureBuilder(
//         // _getLoginStatus() 함수의 결과를 기다립니다.
//         // 이 함수는 사용자의 로그인 상태를 비동기적으로 가져옵니다.
//         future: _getLoginStatus(),
//         // future가 완료되면 이 builder 함수가 실행됩니다.
//         builder: (context, snapshot) {
//           // 비동기 작업이 완료된 경우
//           if (snapshot.connectionState == ConnectionState.done) {
//             // snapshot.data가 true라면, 사용자가 로그인 상태이므로 HomeScreen을 보여줍니다.
//             // 그렇지 않다면 LoginScreen을 보여줍니다.
//             return snapshot.data == true ? HomeScreen() : LoginScreen();
//           } else {
//             // 비동기 작업이 아직 완료되지 않았다면 로딩 인디케이터를 보여줍니다.
//             return CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
//   // 비동기 함수 _getLoginStatus를 정의합니다.
//   // 이 함수는 shared_preferences를 사용하여 저장된 로그인 상태를 불러옵니다.
//   Future<bool> _getLoginStatus() async {
//     // SharedPreferences의 인스턴스를 비동기적으로 가져옵니다.
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     // 'isLoggedIn' 키를 사용하여 저장된 로그인 상태를 불러옵니다.
//     // 해당 키가 없다면 기본값으로 false를 반환합니다.
//     return prefs.getBool('isLoggedIn') ?? false;
//   }
// }
//



