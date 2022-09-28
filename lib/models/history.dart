import 'dart:convert';
import 'package:shalltear/models/main_card.dart';


History historyFromJson(String str) => History.fromJson(json.decode(str));
String historyToJson(History data) => json.encode(data.toJson());

class History{
   String date;
   String time;
   List<MainCard> log;


   History({required this.date,required this.time,required this.log});

   factory History.fromJson(Map<String, dynamic> json) => History(
      date: json["date"],
      time: json["time"],
      log: List<MainCard>.from(json["log"].map((x) => MainCard.fromJson(x))),
   );

   Map<String, dynamic> toJson() => {
      "date": date,
      "time" : time,
      "log": List<dynamic>.from(log.map((x) => x.toJson())),
   };

}