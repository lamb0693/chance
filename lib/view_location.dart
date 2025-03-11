import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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

  void updatePositions() {
    setState(() {
      qrLocations.clear();
      for (var item in widget.listRegistered) {
        var position = getPosition(item["qr"]);
        String area = position["area"];
        if (!qrLocations.containsKey(area)) {
          qrLocations[area] = [];
        }
        qrLocations[area]!.add(position);
      }
    });
  }

  Map<String, dynamic> getPosition(String qrCode) {
    Random random = Random();
    List<String> areas = ["area1", "area2", "area3", "area4"];
    return {
      "area": areas[random.nextInt(4)],
      "x": random.nextInt(100),
      "y": random.nextInt(100),
      "qr": qrCode,
    };
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
