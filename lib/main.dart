import 'dart:io';
import 'package:cisco/register_qr.dart';
import 'package:cisco/view_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<Map<String, dynamic>> listRegistered = []; // 등록된 기기 리스트
  String deviceInfo = "등록된 기기 없음"; // 등록된 기기 개수 표시

  void updateDeviceInfo() {
    setState(() {
      deviceInfo = listRegistered.isEmpty
          ? "등록된 기기 없음"
          : "등록된 기기 수: ${listRegistered.length}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              'images/main_image.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.grey[300],
            child: Text(
              deviceInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildWideButton(context, "QR 등록", Colors.blue, () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterQRPage(listRegistered: listRegistered),
                    ),
                  );
                  updateDeviceInfo(); // QR 등록 후 등록 개수 업데이트
                }),
                buildWideButton(context, "지도로 이동", Colors.green, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        ViewLocationPage(listRegistered: listRegistered),
                    ),
                  );
                }),
                buildWideButton(context, "나가기", Colors.red, () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

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



