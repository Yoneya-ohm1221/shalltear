import 'dart:convert';

MainCard mainCardFromJson(String str) => MainCard.fromJson(json.decode(str));
String mainCardToJson(MainCard data) => json.encode(data.toJson());

class MainCard{
  String name;
  String value;


  MainCard({required this.name,required this.value});

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };

  factory MainCard.fromJson(Map<String, dynamic> json) => MainCard(
    name: json["name"],
    value: json["value"],
  );

}