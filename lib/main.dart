import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'qr_scanner.dart'; // QR 스캐너 페이지 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deviceInfo = "등록된 기기 없음"; // QR 코드 스캔 결과 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // 상단 이미지 추가
          Expanded(
            flex: 3, // 화면의 3/5 차지
            child: Image.asset(
              'images/main_image.jpg', // assets 폴더에 이미지 추가 필요
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // 등록 기기 정보 표시
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.grey[300], // 배경색 추가
            child: Text(
              deviceInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // 하단 버튼 영역
          Expanded(
            flex: 2, // 화면의 2/5 차지
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildWideButton(context, "QR 등록", Colors.blue, () async {
                  final scannedData = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QRScannerPage()),
                  );

                  // QR 코드 결과를 받아와 등록 기기 정보 업데이트
                  if (scannedData != null) {
                    setState(() {
                      deviceInfo = "등록된 기기: $scannedData";
                    });
                  }
                }),
                buildWideButton(context, "지도로 이동", Colors.green, () {
                  // 지도 화면 이동 기능 추가 가능
                }),
                buildWideButton(context, "나가기", Colors.red, () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop(); // 안드로이드에서는 이걸로 앱 종료
                  } else if (Platform.isIOS) {
                    exit(0); // iOS에서는 강제 종료 (Apple 가이드라인상 권장되지 않음)
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 공통 버튼 생성 함수
  Widget buildWideButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}


