import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String txtName = "";
  bool validateName = false;

  Future<void> saveName(String name) async {
    if(name.isNotEmpty){
      validateName = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('Name', name);
      await getName();
    }else{
      setState(() {
        validateName = true;
        FocusManager.instance.primaryFocus?.unfocus();
      });
    }
  }

  Future<void> getName() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('Name') ?? "Jordan";
    setState(() {
        txtName  = name;
    });
  }


  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    getName();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Poker Hunter",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                "Planing story time ",
                style: TextStyle(color: Colors.black45),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    txtName,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: sheetDia(context, nameController),
                              );
                            });
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              SizedBox(
                height: 220,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text("Join >  ")],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 220,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text("New >  ")],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Container sheetDia(
      BuildContext context, TextEditingController nameController) {
    return Container(
      height: 165,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
              const Text("Enter Your Name"),
              IconButton(
                  onPressed: () {
                    saveName(nameController.text);
                    if(validateName == false){
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.done))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Name Here',
                hintText: 'Enter Name Here',
                errorText: validateName ? 'Name Can\'t Be Empty' : "" ,
              ),
              controller: nameController,
              autofocus: false,
            ),
          )
        ],
      ),
    );
  }
}
