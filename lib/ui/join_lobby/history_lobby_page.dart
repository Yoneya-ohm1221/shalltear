import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shalltear/models/history.dart';
import 'package:shalltear/models/main_card.dart';

class HistoryLobbyPage extends StatefulWidget {
  final String lobbyKey;

  const HistoryLobbyPage({Key? key, required this.lobbyKey}) : super(key: key);

  @override
  State<HistoryLobbyPage> createState() => _HistoryLobbyPageState();
}

class _HistoryLobbyPageState extends State<HistoryLobbyPage> {
  late final ref =
      FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}/historyLog");
  late StreamBuilder _widget;
  List<History> historyLog = [];
  String a = "22";

  final List<String> entries = <String>['Awfww: 80', 'Awfww: 80', 'Awfww: 80', 'Awfww: 80', 'Awfww: 80', 'Aww: 80', 'Awfww: 80'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    super.initState();
    _widget = StreamBuilder(
      stream: ref.onValue,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> map =
              jsonDecode(jsonEncode(snapshot.data.snapshot.value));
          historyLog.clear();
          map.forEach((key, value) {
            var data = jsonDecode(jsonEncode(value));
            historyLog.add(History.fromJson(data));
          });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: historyLog.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(8),
              height: 120,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(historyLog[index].dateTime),
                    Wrap(
                      children: [
                        for ( var i in entries ) Text(i.toString())
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    //print(historyLog[0].dateTime);
  }


  ListView listView() => ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return Card(
                child: Container(
                  width: 200,
                  child: Center(
                    child: Text(entries[index]),
                  ),
                )
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("${widget.lobbyKey} history",
              style: const TextStyle(color: Color.fromRGBO(225, 69, 140, 1.0))),
          leading: const BackButton(
            color: Color.fromRGBO(225, 69, 140, 1.0),
          ),
        ),
        body: _widget);
  }
}
