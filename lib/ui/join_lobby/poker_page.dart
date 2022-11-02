import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:shalltear/models/main_card.dart';
import 'package:shalltear/ui/join_lobby/history_lobby_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokerPage extends StatefulWidget {
  final String lobbyKey;

  const PokerPage({Key? key, required this.lobbyKey}) : super(key: key);

  @override
  State<PokerPage> createState() => _PokerPageState();
}

class _PokerPageState extends State<PokerPage> {
  late Future<String> name;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CollectionReference logs =
      FirebaseFirestore.instance.collection('historyLog');
  late final ref = FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}");
  late final refMember =
      FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}/members");
  List<MainCard> mainCard = [];
  final List _controller = [];
  String selectedCard = "0";
  late DatabaseReference databaseReference;
  String showText = "Show";
  late StreamBuilder _widget;

  @override
  void initState() {
    super.initState();
    name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('Name') ?? "";
    });

    _widget = StreamBuilder(
      stream: refMember.onValue,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          mainCard.clear();
          if (snapshot.data.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            map.forEach((key, value) {
              mainCard.add(MainCard(name: key, value: value['value']));
              _controller.add(FlipCardController());
            });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          readData();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: mainCard.length,
            itemBuilder: (context, index) {
              return buildContainer(mainCard[index].name, mainCard[index].value,
                  _controller[index]);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    checkOut();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                widget.lobbyKey,
                style: const TextStyle(
                    color: Color.fromRGBO(225, 69, 140, 1.0), fontSize: 26),
              ),
              leading: IconButton(
                icon: const Icon(Icons.exit_to_app),
                color: const Color.fromRGBO(225, 69, 140, 1.0),
                onPressed: () {
                  name
                      .then((value) => {
                            if (value.isNotEmpty)
                              {refMember.child(value).remove()}
                          })
                      .then((value) => Navigator.of(context).pop());
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  color: const Color.fromRGBO(225, 69, 140, 1.0),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryLobbyPage(
                                  lobbyKey: widget.lobbyKey,
                                )));
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                  ),
                  builder: (BuildContext context) {
                    return bottomSheet(context);
                  },
                );
              },
              child: const Icon(Icons.ad_units),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        " Results",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(36, 80, 150, 1.0),
                            fontWeight: FontWeight.w500),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: const Color.fromRGBO(36, 80, 150, 1.0),
                            textStyle: const TextStyle(fontSize: 16),
                            side: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(36, 80, 150, 1.0),
                            )),
                        child: Text(showText),
                        onPressed: () {
                          updateStatus();
                          if (showText == "Show") {
                            saveHistoryLog(widget.lobbyKey);
                          }
                        },
                      )
                    ],
                  ),
                  Expanded(child: _widget)
                ],
              ),
            )),
        onWillPop: () async => false);
  }

  StatefulBuilder bottomSheet(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: 54,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(80))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                      child: GridView.count(
                    crossAxisCount: 3,
                    children: <Widget>[
                      cardPoker("0", setState),
                      cardPoker("1", setState),
                      cardPoker("2", setState),
                      cardPoker("3", setState),
                      cardPoker("5", setState),
                      cardPoker("8", setState),
                      cardPoker("13", setState),
                      cardPoker("coffee", setState),
                      cardPoker("?", setState),
                    ],
                  ))
                ],
              ),
            ));
      },
    );
  }

  GestureDetector cardPoker(String number, StateSetter setState) {
    return GestureDetector(
        onTap: () {
          updateNumber(number);
          setState(() => selectedCard = number);
        },
        child: Card(
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3))),
            child: Container(
              //
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: selectedCard == number
                          ? Colors.pink[400]!
                          : const Color.fromRGBO(222, 222, 222, 1),
                      width: 5),
                ),
              ),
              child: SizedBox(
                width: 160.0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(number,
                              style: const TextStyle(color: Colors.black45)),
                        ],
                      ),
                      Expanded(
                          child: Center(
                        child: Text(
                          number,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(number,
                              style: const TextStyle(color: Colors.black45)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Container buildContainer(String name, String value, controller) {
    return Container(
      margin: const EdgeInsets.all(0),
      width: 130,
      height: 180,
      child: FlipCard(
        fill: Fill.fillBack,
        flipOnTouch: false,
        direction: FlipDirection.HORIZONTAL,
        controller: controller,
        front: Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: Colors.pink,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  textAlign: TextAlign.center,
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        back: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(188, 188, 188, 1),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(name),
                  Expanded(
                      child: Center(
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500)),
                  ))
                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.clear();
  }

  void checkOut() async {
    ref.child("isShow").onValue.listen((event) {
      handleFlip(event.snapshot.value);
    });

    name.then((value) => {
          if (value.isNotEmpty) {refMember.child(value).onDisconnect().remove()}
        });
  }

  void updateNumber(String number) async {
    name.then((value) async => {
          await refMember.update({
            value: {"value": number}
          })
        });
  }

  void readData() async {
    await ref.child("isShow").get().then((value) async {
      handleFlip(value.value!);
    });
  }

  void updateStatus() async {
    await ref.child("isShow").get().then((value) {
      ref.update({"isShow": !(value.value as bool)});
    });
  }

  Future<void> flipFront() async {
    try {
      for (var element in _controller) {
        if (mounted) {
          element.controller?.forward();
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          showText = "Hidden";
        });
      }
    }
  }

  Future<void> flipBack() async {
    try {
      for (var element in _controller) {
        if (mounted) {
          element.controller?.reverse();
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          showText = "Show";
        });
      }
    }
  }

  void handleFlip(Object? status) async {
    if (status == true) {
      await flipFront();
    } else {
      await flipBack();
    }
  }

  Future<void> saveHistoryLog(String lobbyKey) {
    var now = DateTime.now();
    var milliseconds = now.millisecondsSinceEpoch;
    return FirebaseFirestore.instance
        .collection(lobbyKey)
        .doc()
        .set({
          "timestamp": milliseconds,
          "log": mainCard.map((e) => e.toJson()).toList()
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
