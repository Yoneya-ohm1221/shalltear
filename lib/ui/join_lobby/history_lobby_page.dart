import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
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
  late final CollectionReference logs =
      FirebaseFirestore.instance.collection(widget.lobbyKey);
  List<History> historyLog = [];


  @override
  void initState() {
    super.initState();

  }

  GroupedListView<dynamic, String> groupedListView() {
    return GroupedListView<dynamic, String>(
      elements: historyLog,
      groupBy: (element) => getDate(element.timestamp),
      groupComparator: (value1, value2) => value2.compareTo(value1),
      groupSeparatorBuilder: (String groupByValue) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2, top: 2),
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
                  child: Text(groupByValue,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        );
      },
      itemBuilder: (context, dynamic element) {
        return Padding(
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
                          Text(getTime(element.timestamp),
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
        );
      },
      // order: GroupedListOrder.DESC, // optional
    );
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
        body: FutureBuilder(
          future: initData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (historyLog.isNotEmpty) {
                return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: groupedListView());
              } else {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.hourglass_empty,
                        size: 100,
                        color: Colors.black26,
                      ),
                      Text(
                        "History is empty",
                        style: TextStyle(
                            color: Colors.black26, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                );
              }
            }
          },
        )

    );
  }

  Future<void> _refreshData() async {
    List<History> _tempHistoryLog =[];
    await logs
        .orderBy('timestamp', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var data = jsonDecode(jsonEncode(doc.data()));
        _tempHistoryLog.add(History.fromJson(data));
      }
    });

    setState(() {
      historyLog.clear();
      historyLog.addAll(_tempHistoryLog);
    });
  }

  Future<void> initData() async {
    await logs
        .orderBy('timestamp', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      historyLog.clear();
      for (var doc in querySnapshot.docs) {
        var data = jsonDecode(jsonEncode(doc.data()));
        historyLog.add(History.fromJson(data));
      }
    });
  }

  String getDate(int milliseconds) {
    var currentDate = DateFormat('dd/MM/yyy')
        .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    return currentDate;
  }

  String getTime(int milliseconds) {
    var currentTime = DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    return currentTime;
  }
}
