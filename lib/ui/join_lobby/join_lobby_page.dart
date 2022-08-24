import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class JoinLobbyPage extends StatefulWidget {
  final String name;

  const JoinLobbyPage({Key? key, required this.name}) : super(key: key);

  @override
  State<JoinLobbyPage> createState() => _JoinLobbyPageState();
}

class _JoinLobbyPageState extends State<JoinLobbyPage> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final keyController = TextEditingController();
  bool validate = false;

  void _onClick() async {
    saveToDb(keyController.text);
  }

  Future<void> saveToDb(String key) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("lobby/$key/");

    final snapshot = await ref.get();
    if (snapshot.exists) {
      await ref
          .child("members/${widget.name}")
          .update({"value": 0}).then((_) => {
                setState(() {
                  validate = false;
                }),
                _btnController.success()
              });
    } else {
      setState(() {
        validate = true;
      });
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const BackButton(
          color: Color.fromRGBO(225, 69, 140, 1.0),
        ),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Join into the lobby!",
              style: TextStyle(
                  fontSize: 36,
                  color: Color.fromRGBO(225, 69, 140, 1.0),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Text("Hi, ${widget.name}"),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLength: 16,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: keyController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Lobby key',
                hintText: 'Lobby key',
                errorText: validate ? 'Not found lobby!! ' : "",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: _onClick,
              color: Color.fromRGBO(225, 69, 140, 1.0),
              child: const Text('Join lobby',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      )),
    );
  }
}
