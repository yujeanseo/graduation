import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workermanager/home_screen.dart';
import 'package:workermanager/home2_screen.dart';
import 'package:workermanager/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


var sort = "";  // 변수 추가

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // 사용자 이메일과 비밀번호 입력을 위한 TextEditingController 인스턴스 생성
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // FirebaseAuth 인스턴스를 사용하여 인증 처리
  final _auth = FirebaseAuth.instance;

  // 사용자에게 로그인 상태 또는 오류 메시지를 표시하기 위한 문자열 변수
  String _statusMessage = '';

  // 비동기 로그인 처리 메서드
  Future<void> _signIn() async {
    try {
      // 이메일과 비밀번호를 사용하여 사용자 로그인 시도
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 로그인 성공 시 이메일 인증 여부 확인
      if (userCredential.user != null) {
        if (!userCredential.user!.emailVerified) {
          // 이메일 인증이 완료되지 않은 경우 사용자에게 메시지 표시
          setState(() {
            _statusMessage = '이메일 인증이 완료되지 않았습니다. 이메일을 확인해주세요.';
          });
        } else {
          // 이메일 인증이 완료된 경우 로그인 성공 처리
          setState(() {
            _statusMessage = '로그인 성공!';

            getDocument(_emailController.text);
            if (sort == "worker") {
              //return HomePage(user: user);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomePage(user: userCredential.user!)));
            }
            else if (sort == "manager") {
              //return Home2Page(user: user);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Home2Page(user: userCredential.user!)));
            }

            // 홈 화면으로 이동
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => HomePage(user: userCredential.user!)));
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      // 여기부터 추가
      // logger.e(e);
      String message = '';

      if (e.code == 'invalid-credential') {  //invalid-credential
        message = '계정이 존재하지 않습니다.';
      } else if (e.code == 'wrong-password') {
        message = '비밀번호를 확인하세요';
      } else if (e.code == 'invalid-email') {
        message = '이메일을 확인하세요.';
      }

      print(e.code);
      print(message);

      /*
      final snackBar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.deepOrange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      */


      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //     backgroundColor: Colors.deepOrange,
      //   ),
      // );
      // 여기까지 추가



      // FirebaseAuth에서 발생하는 예외 처리 및 오류 메시지 표시
      setState(() {
        _statusMessage = message ?? '로그인 실패';  // e.message ?? '로그인 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp과 Scaffold를 사용하여 로그인 페이지 UI 구성
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Sign In")),
        body: SingleChildScrollView(
          // 스크롤 가능한 컨테이너 내에 로그인 폼 구성
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // 이메일 입력 필드
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "이메일"),
                ),
              ),
              // 비밀번호 입력 필드 (텍스트 가림 처리)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "비밀번호"),
                  obscureText: true,
                ),
              ),
              // 로그인 버튼
              ElevatedButton(
                onPressed: _signIn,
                child: Text("로그인"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()), //RegisterPage
                  );
                },
                child: Text('회원가입'),
              ),

              SizedBox(height: 20),
              // 로그인 상태 또는 오류 메시지 표시
              Text(_statusMessage),
            ],
          ),
        ),
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
// class SignInPage extends StatefulWidget {
//   @override
//   _SignInPageState createState() => _SignInPageState();
// }
//
// class _SignInPageState extends State<SignInPage> {
//   // 사용자 이메일과 비밀번호 입력을 위한 TextEditingController 인스턴스 생성
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   // FirebaseAuth 인스턴스를 사용하여 인증 처리
//   final _auth = FirebaseAuth.instance;
//
//   // 사용자에게 로그인 상태 또는 오류 메시지를 표시하기 위한 문자열 변수
//   String _statusMessage = '';
//
//   // 비동기 로그인 처리 메서드
//   Future<void> _signIn() async {
//     try {
//       // 이메일과 비밀번호를 사용하여 사용자 로그인 시도
//       final UserCredential userCredential =
//       await _auth.signInWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//
//
//       // 홈 화면으로 이동
//       // Navigator.of(context).push(MaterialPageRoute(
//       //     builder: (context) => HomePage(user: userCredential.user!)));
//
//
//       // 로그인 성공 시 이메일 인증 여부 확인
//       if (userCredential.user != null) {
//         if (!userCredential.user!.emailVerified) {
//           // 이메일 인증이 완료되지 않은 경우 사용자에게 메시지 표시
//           setState(() {
//             _statusMessage = '이메일 인증이 완료되지 않았습니다. 이메일을 확인해주세요.';
//           });
//         } else {
//           // 이메일 인증이 완료된 경우 로그인 성공 처리
//           setState(() {
//             _statusMessage = '로그인 성공!';
//             // 홈 화면으로 이동
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => HomePage(user: userCredential.user!)));
//           });
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       // FirebaseAuth에서 발생하는 예외 처리 및 오류 메시지 표시
//       setState(() {
//         _statusMessage = e.message ?? '로그인 실패';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // MaterialApp과 Scaffold를 사용하여 로그인 페이지 UI 구성
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Sign In")),
//         body: SingleChildScrollView(
//           // 스크롤 가능한 컨테이너 내에 로그인 폼 구성
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               // 이메일 입력 필드
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: "Email"),
//                 ),
//               ),
//               // 비밀번호 입력 필드 (텍스트 가림 처리)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(labelText: "Password"),
//                   obscureText: true,
//                 ),
//               ),
//               // 로그인 버튼
//               ElevatedButton(
//                 onPressed: _signIn,
//                 child: Text("로그인"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignUpPage()), //RegisterPage
//                   );
//                 },
//                 child: Text('회원가입'),
//               ),
//               SizedBox(height: 20),
//               // 로그인 상태 또는 오류 메시지 표시
//               Text(_statusMessage),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
/////////////////





//
// // StatelessWidget을 상속받는 LoginScreen 클래스를 정의합니다.
// // 이 클래스는 로그인 화면을 구성하는 위젯입니다.
// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Scaffold 위젯을 반환하여 기본적인 앱의 레이아웃 구조를 제공합니다.
//     return Scaffold(
//       // AppBar를 사용하여 앱의 상단에 타이틀 바를 생성합니다.
//       appBar: AppBar(
//         title: Text('Login Screen'), // 타이틀 바에 표시될 텍스트입니다.
//       ),
//       // Scaffold의 body에는 로그인 버튼을 중앙에 배치합니다.
//       body: Center(
//         // ElevatedButton을 사용하여 로그인 버튼을 생성합니다.
//         child: ElevatedButton(
//           child: Text('Login'), // 버튼에 표시될 텍스트입니다.
//           onPressed: () async { // 버튼이 클릭되었을 때 실행될 콜백 함수입니다.
//             // SharedPreferences의 인스턴스를 비동기적으로 가져옵니다.
//             final SharedPreferences prefs = await SharedPreferences.getInstance();
//             // 'isLoggedIn' 키에 대해 true 값을 저장하여 사용자가 로그인했음을 표시합니다.
//             await prefs.setBool('isLoggedIn', true);
//             // 로그인 후, Navigator를 사용하여 HomeScreen으로 화면을 전환합니다.
//             // pushReplacement를 사용하여 현재 화면을 HomeScreen으로 교체합니다.
//             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
//           },
//         ),
//       ),
//     );
//   }
// }
//
