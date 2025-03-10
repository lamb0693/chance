import 'package:cisco/qr_scanner.dart';
import 'package:flutter/material.dart';

class RegisterQRPage extends StatefulWidget {
  final List<Map<String, dynamic>> listRegistered;
  const RegisterQRPage({super.key, required this.listRegistered});

  @override
  State<RegisterQRPage> createState() => _RegisterQRPageState();
}

class _RegisterQRPageState extends State<RegisterQRPage> {
  int? selectedImageIndex;

  void registerMachine(String qrData) {
    if (selectedImageIndex != null && widget.listRegistered.length < 6) {
      setState(() {
        widget.listRegistered.add({"image": selectedImageIndex!, "qr": qrData});
      });
    }
  }

  void removeMachine(int index) {
    setState(() {
      widget.listRegistered.removeAt(index);
    });
  }

  Future<void> scanQRCode() async {
    final qrData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerPage()),
    );
    if (qrData != null) {
      registerMachine(qrData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Register QR"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 홈으로 돌아가기
          },
        ),
      ),
      body: Container(
        color: Colors.blueGrey[50],
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text("등록된 기계", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.listRegistered.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Image.asset(
                                          "images/image${widget.listRegistered[index]["image"]}.png",
                                          width: 50)),
                                  Expanded(
                                      flex: 5,
                                      child: Text(widget.listRegistered[index]["qr"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20))),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => removeMachine(index),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(2, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text("기계 등록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 5.0,
                      children: List.generate(6, (index) {
                        return IconButton(
                          icon: Image.asset("images/image${index + 1}.png", width: 40),
                          onPressed: () {
                            setState(() {
                              selectedImageIndex = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectedImageIndex != null
                            ? Image.asset("images/image$selectedImageIndex.png", width: 60)
                            : Container(width: 60, height: 50, color: Colors.grey[300]),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: scanQRCode,
                          child: const Text("QR 등록"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

