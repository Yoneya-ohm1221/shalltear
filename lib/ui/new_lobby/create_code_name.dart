import 'package:firebase_database/firebase_database.dart';
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
  final keyController =  TextEditingController();
  FirebaseDatabase database = FirebaseDatabase.instance;

  void _onClick() async {
   await saveToDb(keyController.text);
  }

  Future<void> saveToDb(String key) async{
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("lobby/$key");

   await ref.set(
      {
        "isShow" : false,
        "members" : {
          widget.name : {
            "value" : 0
          }
        }
      }
    ).then((_) {
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
               TextField(
                maxLength: 16,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: keyController,
                decoration: const InputDecoration(
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
                onPressed: _onClick,
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
