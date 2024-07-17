import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

int i = 0;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  //추가
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bloodController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  // 회원가입 함수
  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );


      //추가
      FirebaseFirestore.instance.collection('workers').doc(nameController.text)
          .set({ 'email': emailController.text,
                  'password': passwordController.text,
                  'name': nameController.text,
                  'age': ageController.text,
                  'blood': bloodController.text,
                  'phone': phoneController.text,
          });


      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '이메일',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
              ),
              obscureText: true,
            ),


            //추가
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '이름',
              ),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: '나이',
              ),
            ),
            TextField(
              controller: bloodController,
              decoration: InputDecoration(
                labelText: '혈액형',
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: '전화번호',
              ),
            ),


            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}