import 'package:flutter/material.dart';

class RegisterQRPage extends StatefulWidget {
  const RegisterQRPage({super.key});

  @override
  State<RegisterQRPage> createState() => _RegisterQRPageState();
}

class _RegisterQRPageState extends State<RegisterQRPage> {
  List<Map<String, dynamic>> listRegistered = [];
  int? selectedImageIndex;

  void registerMachine() {
    if (selectedImageIndex != null && listRegistered.length < 6) {
      setState(() {
        listRegistered.add({"image": selectedImageIndex!, "qr": "00000000"});
      });
    }
  }

  void removeMachine(int index) {
    setState(() {
      listRegistered.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Register QR"),
      ),
      body: Container(
        color: Colors.blueGrey[50], // 은은한 파스텔톤 배경색
        child: Column(
          children: [
            // 등록된 기계 목록
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
                    SizedBox(height: 15,),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(flex: 1, child: Text("대상", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 5, child: Text("QR", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text("삭제", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                        child: ListView.builder(
                          itemCount: listRegistered.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                    children: [
                                      Expanded(flex: 1,
                                          child: Image.asset(
                                              "images/image${listRegistered[index]["image"]}.png",
                                              width: 50)),
                                      Expanded(flex: 5,
                                          child: Text(listRegistered[index]["qr"],
                                            textAlign: TextAlign.center, style: TextStyle(fontSize: 20),)),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: const Icon(
                                              Icons.delete, color: Colors.red),
                                          onPressed: () => removeMachine(index),
                                        ),
                                      ),
                                    ]
                                ),
                                SizedBox(height: 10,),
                              ],
                            );
                          },
                        )
                    )
                  ],
                ),
              ),
            ),

            // 기계 등록 부분
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
                    SizedBox(height: 20,),
                    Wrap(
                      spacing: 20.0,
                      children: List.generate(6, (index) {
                        return IconButton(
                          icon: Image.asset("images/image${index + 1}.png", width: 50),
                          onPressed: () {
                            setState(() {
                              selectedImageIndex = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectedImageIndex != null
                            ? Image.asset("images/image$selectedImageIndex.png", width: 80)
                            : Container(width: 80, height: 50, color: Colors.grey[300]),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: registerMachine,
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
