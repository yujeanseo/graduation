// register페이지 참고

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workermanager/home_screen.dart';
import 'package:workermanager/login_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

enum Char { Worker, Manager }  // 추가

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _statusMessage = '';

  var annement = '';
  var loginment = '';

  // 여기부터 추가
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Char _char = Char.Worker;
  var job = "worker";
  // 여기까지 추가


  // _signUp() 위에서 회원가입 코드입니다.
  Future<void> _signUp() async {
    try {
      // Firebase Auth를 사용하여 새로운 사용자 계정 생성
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // 이메일 인증 메일 보내기
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        setState(() {
          _statusMessage = '인증 이메일이 발송되었습니다. 이메일을 확인해주세요.';

          annement = '이메일 인증 후에 로그인하기';
          loginment = '로그인하러 가기';

        });
      }

      // 여기부터 추가
      FirebaseFirestore.instance.collection('member').doc(_emailController.text)
          .set({ 'email': _emailController.text,
        'password': _passwordController.text,
        'name': nameController.text,
        'age': ageController.text,
        'blood': bloodController.text,
        'phone': phoneController.text,
        'division' : job,
      });
      // 여기까지 추가



    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = e.message ?? '회원가입 실패';
      });
    }
  }


  // 여기부터 추가
  Future<void> _login() async {
    //Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignInPage()));
  }
  // 여기까지 추가

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Sign Up")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[


              // 여기부터 추가
              RadioListTile(
                  title: Text("근로자"),
                  value: Char.Worker,
                  groupValue: _char,
                  onChanged: (Char? value) {
                    setState(() {
                      _char = value!;
                      // showToast("Worker");
                      job = "worker";
                    });
                  },
              ),
              RadioListTile(
                title: Text("관리자"),
                value: Char.Manager,
                groupValue: _char,
                onChanged: (Char? value) {
                  setState(() {
                    _char = value!;
                    // showToast("Worker");
                    job = "manager";
                  });
                },
              ),
              // 여기까지 추가


              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "이메일"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "비밀번호"),
                  obscureText: true,
                ),
              ),


              // 여기부터 추가
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "이름"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: "나이"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: bloodController,
                  decoration: InputDecoration(labelText: "혈액형"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "전화번호"),
                ),
              ),
              // 여기까지 추가




              ElevatedButton(
                onPressed: _signUp,
                child: Text("회원 가입"),
              ),
              SizedBox(height: 20),
              Text(_statusMessage),

              Text(annement),  //"이메일 인증 후에 로그인하기"
              SizedBox(height: 15),
              // 여기부터 추가
              ElevatedButton(
                onPressed: _login,
                child: Text(loginment),  //"로그인하러 가기"
              ),
              SizedBox(height: 40),
              // 여기까지 추가
            ],
          ),
        ),
      ),
    );
  }
}


















////////////////
// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   String _statusMessage = '';
//
//   // _signUp() 위에서 회원가입 코드입니다.
//   Future<void> _signUp() async {
//     try {
//       // Firebase Auth를 사용하여 새로운 사용자 계정 생성
//       final UserCredential userCredential =
//       await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       // 이메일 인증 메일 보내기
//       if (userCredential.user != null && !userCredential.user!.emailVerified) {
//         await userCredential.user!.sendEmailVerification();
//         setState(() {
//           _statusMessage = '인증 이메일이 발송되었습니다. 이메일을 확인해주세요.';
//         });
//
//       }
//       Navigator.pop(context);
//
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _statusMessage = e.message ?? '회원가입 실패';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Sign Up")),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: "Email"),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(labelText: "Password"),
//                   obscureText: true,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: _signUp,
//                 child: Text("회원가입"),
//               ),
//               SizedBox(height: 20),
//               Text(_statusMessage),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
///////////////////////











//
// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }
//
//
// enum Char { Worker, Manager }
//
//
// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//
//   //추가
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController bloodController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//
//
//   Char _char = Char.Worker;
//   var job = "";
//
//   // 회원가입 함수
//   Future<void> register() async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//
//
//       //추가
//       FirebaseFirestore.instance.collection('member').doc(emailController.text)
//           .set({ 'email': emailController.text,
//         'password': passwordController.text,
//         'name': nameController.text,
//         'age': ageController.text,
//         'blood': bloodController.text,
//         'phone': phoneController.text,
//         'division' : job,
//       });
//
//
//       Navigator.pop(context);
//       // Navigator.of(context).push(MaterialPageRoute(
//       //     builder: (context) => HomePage(user: userCredential.user!)));
//
//     } on FirebaseAuthException catch (e) {
//       print('Failed with error code: ${e.code}');
//       print(e.message);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('회원가입'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               RadioListTile(
//                   title: Text("근로자"),
//                   value: Char.Worker,
//                   groupValue: _char,
//                   onChanged: (Char? value) {
//                     setState(() {
//                       _char = value!;
//                       // showToast("Worker");
//                       job = "worker";
//                     });
//                   },
//               ),
//               RadioListTile(
//                 title: Text("관리자"),
//                 value: Char.Manager,
//                 groupValue: _char,
//                 onChanged: (Char? value) {
//                   setState(() {
//                     _char = value!;
//                     // showToast("Worker");
//                     job = "manager";
//                   });
//                 },
//               ),
//
//
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: '이메일',
//                 ),
//               ),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: '비밀번호',
//                 ),
//                 obscureText: true,
//               ),
//
//
//               //추가
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: '이름',
//                 ),
//               ),
//               TextField(
//                 controller: ageController,
//                 decoration: InputDecoration(
//                   labelText: '나이',
//                 ),
//               ),
//               TextField(
//                 controller: bloodController,
//                 decoration: InputDecoration(
//                   labelText: '혈액형',
//                 ),
//               ),
//               TextField(
//                 controller: phoneController,
//                 decoration: InputDecoration(
//                   labelText: '전화번호',
//                 ),
//               ),
//
//
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: register,
//                 child: Text('회원가입 완료'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }