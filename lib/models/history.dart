import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shalltear/models/main_card.dart';


History historyFromJson(String str) => History.fromJson(json.decode(str));
String historyToJson(History data) => json.encode(data.toJson());

class History{
   String dateTime;
   List<MainCard> log;

   History({required this.dateTime,required this.log});

   factory History.fromJson(Map<String, dynamic> json) => History(
      dateTime: json["dateTime"],
      log: List<MainCard>.from(json["log"].map((x) => MainCard.fromJson(x))),
   );

   Map<String, dynamic> toJson() => {
      "dateTime": dateTime,
      "log": List<dynamic>.from(log.map((x) => x.toJson())),
   };

}