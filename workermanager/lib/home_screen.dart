import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workermanager/login_screen.dart';
import 'package:workermanager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';


// 근로자 페이지


class HomePage extends StatelessWidget {
  // 사용자 정보를 담고 있는 User 객체를 final로 선언
  final User user;

  // 생성자에서 user를 필수 인자로 받음. required 키워드로 null이 아닌 값을 보장
  HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인 성공"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            // 로그아웃 버튼이 클릭되면 _signOut 함수를 비동기적으로 호출
            onPressed: () async {
              await _signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 사용자의 이메일을 화면에 표시
            Text("1환영합니다, ${user.email}!", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text("로그인에 성공하였습니다.", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            // 로그아웃 버튼을 배치 클릭 시 _signOut 함수를 호출
            ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text("로그아웃"),
            ),
          ],
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


    } catch (e) {
      // 로그아웃 과정에서 오류가 발생한 경우 사용자에게 알림을 제공
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("로그아웃 중 오류가 발생했습니다."),
        ),
      );
    }
  }
}





//
// // StatelessWidget을 상속받는 HomeScreen 클래스를 정의합니다.
// // 이 클래스는 앱의 홈 화면을 구성하는 위젯입니다.
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Scaffold 위젯을 사용하여 기본적인 앱 레이아웃을 제공합니다.
//     return Scaffold(
//       // AppBar를 사용하여 화면 상단에 앱 바를 생성합니다.
//       appBar: AppBar(
//         title: Text('Home Screen'), // 앱 바에 표시될 타이틀입니다.
//       ),
//       // Scaffold의 body에서 로그아웃 버튼을 중앙에 배치합니다.
//       body: Center(
//         // ElevatedButton을 사용하여 로그아웃 버튼을 생성합니다.
//         child: ElevatedButton(
//           child: Text('Logout'), // 버튼에 표시될 텍스트입니다.
//           onPressed: () async { // 버튼이 클릭되었을 때 실행될 콜백 함수입니다.
//             // SharedPreferences의 인스턴스를 비동기적으로 가져옵니다.
//             final SharedPreferences prefs = await SharedPreferences.getInstance();
//             // 'isLoggedIn' 키에 대해 false 값을 저장하여 사용자가 로그아웃했음을 표시합니다.
//             await prefs.setBool('isLoggedIn', false);
//             // 로그아웃 후, Navigator를 사용하여 LoginScreen으로 화면을 전환합니다.
//             // pushReplacement를 사용하여 현재 화면을 LoginScreen으로 교체합니다.
//             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
//           },
//         ),
//       ),
//     );
//   }
// }
//
