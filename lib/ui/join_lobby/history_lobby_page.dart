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

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  void initState() {
    super.initState();
    test();
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
        return ListView(
          children: [
            Container(
              color: Colors.red,
              height: 150.0,
              width: double.infinity,
              child: Center(
                  child: Text("2", style: const TextStyle(fontSize: 20.0))),
            ),
            FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  } else {
                    return SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                          shrinkWrap:true,
                          itemCount: snapshot.data.length,
                          itemBuilder:
                              (BuildContext context, int mistakeIdIndex) {
                            return ListView(
                              shrinkWrap:true,
                              children: [
                                Text(snapshot
                                    .data[mistakeIdIndex].issueDescription),
                                // this is where the problems begin
                                ListView.builder(
                                    shrinkWrap:true,
                                    itemCount: snapshot.data[mistakeIdIndex]
                                        .replacements.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(snapshot.data[mistakeIdIndex]
                                          .replacements[index]);
                                    }),
                              ],
                            );
                          }),
                    );
                  }
                }),
          ],
        );
      },
    );

    //print(historyLog[0].dateTime);
  }

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

  void test() {
    var snapshot = ref.onValue.listen((event) {
      print(event.snapshot.value);
    });




  }
}
