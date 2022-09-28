import 'dart:convert';
import 'package:shalltear/models/main_card.dart';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  int timestamp;
  List<MainCard> log;

  History({required this.log, required this.timestamp});

  factory History.fromJson(Map<String, dynamic> json) => History(
        timestamp: json["timestamp"],
        log: List<MainCard>.from(json["log"].map((x) => MainCard.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "log": List<dynamic>.from(log.map((x) => x.toJson())),
      };
}
