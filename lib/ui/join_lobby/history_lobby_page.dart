import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
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

  @override
  void initState() {
    super.initState();
    //test();
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

        return Padding(
          padding: const EdgeInsets.only(
            bottom: 0,
          ),
          child: GroupedListView<dynamic, String>(
            elements: historyLog,
            groupBy: (element) => element.date,
            order: GroupedListOrder.DESC,
            groupSeparatorBuilder: (String groupByValue) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 2, top: 2),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.pinkAccent,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Colors.pinkAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                          groupByValue,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
            itemBuilder: (context, dynamic element) => Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
              child: Card(
                child: ClipPath(
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3))),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4, right: 4, top: 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.pinkAccent, width: 5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(" History",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              Text(element.time,
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13))
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Wrap(
                            children: [
                              for (var data in element.log) cardList(data)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    //print(historyLog[0].dateTime);
  }

  Card cardList(MainCard data) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.pinkAccent,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                data.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                data.value,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("${widget.lobbyKey} history",
              style: const TextStyle(color: Colors.pinkAccent)),
          leading: const BackButton(
            color: Colors.pinkAccent,
          ),
        ),
        body: _widget);
  }

}

