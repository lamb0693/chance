import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewLocationPage extends StatefulWidget {
  final List<Map<String, dynamic>> listRegistered;

  const ViewLocationPage({super.key, required this.listRegistered});

  @override
  State<ViewLocationPage> createState() => _ViewLocationPageState();
}

class _ViewLocationPageState extends State<ViewLocationPage> {
  String selectedArea = "area1";
  Map<String, List<Map<String, dynamic>>> qrLocations = {};

  @override
  void initState() {
    super.initState();
    updatePositions();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      updatePositions();
    });
  }

  // void updatePositions() {
  //   setState(() {
  //     qrLocations.clear();
  //     for (var item in widget.listRegistered) {
  //       var position = getPosition(item["qr"]);
  //       String area = position["area"];
  //       if (!qrLocations.containsKey(area)) {
  //         qrLocations[area] = [];
  //       }
  //       qrLocations[area]!.add(position);
  //     }
  //   });
  // }

  void updatePositions() async {
    Map<String, List<Map<String, dynamic>>> newQrLocations = {};

    //test용
    //widget.listRegistered.add({"qr":"2222"});
    //widget.listRegistered.add({"qr":"1111"});

    for (var item in widget.listRegistered) {
      var position = await getPosition(item["qr"]);
      if (position != null) {
        String area = position["area"];
        if (!newQrLocations.containsKey(area)) {
          newQrLocations[area] = [];
        }
        newQrLocations[area]!.add(position);
      }
    }

    setState(() {
      qrLocations = newQrLocations;
    });

    //test용
    //widget.listRegistered.clear();
  }

  // Map<String, dynamic> getPosition(String qrCode) {
  //   Random random = Random();
  //   List<String> areas = ["area1", "area2", "area3", "area4"];
  //   return {
  //     "area": areas[random.nextInt(4)],
  //     "x": random.nextInt(100),
  //     "y": random.nextInt(100),
  //     "qr": qrCode,
  //   };
  // }

  Future<Map<String, dynamic>?> getPosition(String qrCode) async {
    final String apiUrl = "http://localhost:8082/api/position/getPositionByQR/$qrCode";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          "area": "area${data["area"]}", // area 값을 문자열로 변환
          "x": (data["x"] * 100).toInt(), // 정수 픽셀 값으로 변환
          "y": (data["y"] * 100).toInt(),
          "qr": qrCode,
        };
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Location")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var area in ["area1", "area2", "area3", "area4"])
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedArea = area;
                    });
                  },
                  child: Text(area.toUpperCase()),
                ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Image.asset("images/$selectedArea.jpg", fit: BoxFit.cover, width: double.infinity),
                if (qrLocations.containsKey(selectedArea))
                  ...qrLocations[selectedArea]!.map((pos) {
                    return Positioned(
                      left: pos["x"].toDouble(),
                      top: pos["y"].toDouble(),
                      child: Icon(Icons.location_on, color: Colors.red, size: 24),
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
