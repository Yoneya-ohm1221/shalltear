import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
  late final refMember = FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}/members");
   List<MainCard> mainCard = [];

  late DatabaseReference databaseReference;
  @override
  Widget build(BuildContext context) {
    readData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
      body: StreamBuilder(
        stream: refMember.onValue,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            mainCard.clear();
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            map.forEach((key, value) {
            mainCard.add(MainCard(key, value['value']));
            });
            return  GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: mainCard.length,
              itemBuilder: (context, index) {
                return buildContainer(mainCard[index].name,mainCard[index].value);
              },
            );
          }
          else {
            return CircularProgressIndicator();
          }
        },

      )
      );
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

  Container buildContainer(String name, String value) {
    return Container(
      margin: const EdgeInsets.all(0),
      width: 130,
      height: 180,
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
    );
  }

  void updateNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('Name');
    await refMember.update({
      name!: {"value": number}
    });
  }

  void readData() async{
    mainCard.clear();

  }
}
