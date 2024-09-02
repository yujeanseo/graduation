// 앱-esp32 블루투스 통신 (진행 중)
// esp32 검색하는 페이지

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
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:workermanager/device_page.dart';


final title = 'BLE Set Notification';


class ConnectionPage extends StatefulWidget {
  //MyHomePage({Key? key, required this.title}) : super(key: key);
  //final String title;

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    // 블루투스 초기화
    initBle();
  }

  void initBle() {
    // BLE 스캔 상태 얻기 위한 리스너
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  /*
  스캔 시작/정지 함수
  */
  scan() async {
    if (!_isScanning) {
      // 스캔 중이 아니라면
      // 기존에 스캔된 리스트 삭제
      scanResultList.clear();
      // 스캔 시작, 제한 시간 4초
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      // 스캔 결과 리스너
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        // UI 갱신
        setState(() {});
      });
    } else {
      // 스캔 중이라면 스캔 정지
      flutterBlue.stopScan();
    }
  }

  /*
   여기서부터는 장치별 출력용 함수들
  */
  /*  장치의 신호값 위젯  */
  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    return Text(name);
  }

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap(ScanResult r) {
    // 단순히 이름만 출력
    print('${r.device.name}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
    );
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        /* 장치 리스트 출력 */
        child: ListView.separated(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
      /* 장치 검색 or 검색 중지  */
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}