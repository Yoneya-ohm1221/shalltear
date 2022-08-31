import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:shalltear/models/main_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokerPage extends StatefulWidget {
  final String lobbyKey;

  const PokerPage({Key? key, required this.lobbyKey}) : super(key: key);

  @override
  State<PokerPage> createState() => _PokerPageState();
}

class _PokerPageState extends State<PokerPage> {
  late final ref = FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}");
  late final refMember =
      FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}/members");
  List<MainCard> mainCard = [];
  final List _controller = [];
  late DatabaseReference databaseReference;
  String showText = "Show";

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            widget.lobbyKey,
            style: const TextStyle(
              color: Colors.pink,
            ),
          ),
          leading: const BackButton(
            color: Color.fromRGBO(225, 69, 140, 1.0),
          ),
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
                        textStyle: const TextStyle(fontSize: 16),
                        primary: const Color.fromRGBO(36, 80, 150, 1.0),
                        side: const BorderSide(
                          width: 2,
                          color: Color.fromRGBO(36, 80, 150, 1.0),
                        )),
                    child: Text(showText),
                    onPressed: () {
                      updateStatus();
                    },
                  )
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: refMember.onValue,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      mainCard.clear();
                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                      map.forEach((key, value) {
                        mainCard.add(MainCard(key, value['value']));
                        _controller.add(FlipCardController());
                      });
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: mainCard.length,
                        itemBuilder: (context, index) {
                          return buildContainer(mainCard[index].name,
                              mainCard[index].value, _controller[index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }

  Container bottomSheet(BuildContext context) {
    return Container(
        height: 250,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: 54,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(80))),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    cardPoker("0"),
                    cardPoker("1"),
                    cardPoker("2"),
                    cardPoker("3"),
                    cardPoker("5"),
                    cardPoker("8"),
                    cardPoker("13"),
                    cardPoker("coffee"),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  GestureDetector cardPoker(String number) {
    return GestureDetector(
      onTap: () {
        updateNumber(number);
      },
      child: Card(
        margin: EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        child: Container(
            color: Colors.pink[300],
            width: 160.0,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(number),
                    ],
                  ),
                  Expanded(
                      child: Center(
                    child: Text(
                      number,
                      style: TextStyle(fontSize: 50),
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(number),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
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
          front: Container(
            child: Container(
              child: Card(
                  child: Container(
                color: Colors.pink,
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )),
            ),
          ),
          back: Container(
            child: Card(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(name),
                  Expanded(
                      child: Center(
                    child: Text(value),
                  ))
                ],
              ),
            )),
          ),
        ));
  }

  void updateNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('Name');

    await refMember.update({
      name!: {"value": number}
    });
  }

  void readData() async {
    mainCard.clear();
    await ref.child("isShow").get().then((value) {
      print("sfdsf");
      handleFlip(value.value as bool);
    });

    ref.onChildChanged.listen((event) {
      //print(event.snapshot.value);
      handleFlip(event.snapshot.value as bool);
    });
  }

  void updateStatus() async{
   await ref.child("isShow").get().then((value) {
      ref.update({"isShow": !(value.value as bool)});
    });
  }

  void flipFront() {
    for (var element in _controller) {
      element.controller?.forward();
    }
    setState(() {
      showText = "Show";
    });
  }

  void flipBack() {
    for (var element in _controller) {
      element.controller?.reverse();
    }
    setState(() {
      showText = "Hidden";
    });
  }

  void handleFlip(bool status) {
    if (status == true) {
      flipFront();
    } else {
      flipBack();
    }
  }
}
