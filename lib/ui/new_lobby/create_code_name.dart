import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreateCodeNamePage extends StatefulWidget {
  final String name;
  const CreateCodeNamePage({Key? key, required this.name}) : super(key: key);

  @override
  State<CreateCodeNamePage> createState() => _CreateCodeNamePageState();
}

class _CreateCodeNamePageState extends State<CreateCodeNamePage> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  void _doSomething() async {
    Timer(const Duration(seconds: 3), () {
      _btnController.success();
    });
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
                "Create new lobby!",
                style: TextStyle(
                  fontSize: 36,
                  color: Color.fromRGBO(36, 80, 150, 1.0),
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Hi, ${widget.name}"
              ),
              const SizedBox(
                height: 20,
              ),
              const TextField(
                maxLength: 16,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lobby key',
                  hintText: 'Lobby key',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundedLoadingButton(
                controller: _btnController,
                onPressed: _doSomething,
                color: const Color.fromRGBO(36, 80, 150, 1.0),
                child: const Text('Create lobby', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        )
      ),
    );
  }
}
