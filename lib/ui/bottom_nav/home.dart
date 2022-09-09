import 'package:animated_button/animated_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shalltear/ui/join_lobby/join_lobby_page.dart';
import 'package:shalltear/ui/new_lobby/create_code_name.dart';
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
    if (name.isNotEmpty) {
      validateName = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('Name', name);
      await getName();
    } else {
      setState(() {
        validateName = true;
        FocusManager.instance.primaryFocus?.unfocus();
      });
    }
  }

  Future<void> getName() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('Name') ?? "Bob";
    setState(() {
      txtName = name;
    });
  }

  Future<void> checkName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('Name');
    if(name ==null || name.isEmpty){
      saveName('Bob');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkName();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
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
                      style:
                          const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0)),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: sheetDia(context, nameController),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
                SizedBox(
                    height: 210,
                    width: double.maxFinite,
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                          color: const Color.fromRGBO(253, 107, 166, 1.0),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Join into the lobby",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  "Join with lobby key",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const Expanded(child: SizedBox()),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset("images/coffee.png",scale: 20),
                                    AnimatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    JoinLobbyPage(
                                                      name: txtName,
                                                    )));
                                      },
                                      duration: 70,
                                      height: 40,
                                      width: 100,
                                      enabled: true,
                                      shadowDegree: ShadowDegree.dark,
                                      color: const Color.fromRGBO(
                                          36, 80, 150, 1.0),
                                      child: const Text(
                                        'Join',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    )),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                    height: 210,
                    width: double.maxFinite,
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                          color: Color.fromRGBO(36, 80, 150, 1.0),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Create new lobby",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  "Create lobby key",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const Expanded(child: SizedBox()),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Image.asset("images/barista.png",scale: 20),
                                    AnimatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateCodeNamePage(
                                                      name: txtName,
                                                    )));
                                      },
                                      duration: 70,
                                      height: 40,
                                      width: 100,
                                      enabled: true,
                                      shadowDegree: ShadowDegree.dark,
                                      color: const Color.fromRGBO(
                                          225, 69, 140, 1.0),
                                      child: const Text(
                                        'New',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    )),
              ],
            ),
          )),
    );
  }

  SizedBox sheetDia(
      BuildContext context, TextEditingController nameController) {
    return SizedBox(
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
                    if (validateName == false) {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.done))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              maxLength: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Name Here',
                hintText: 'Enter Name Here',
                errorText: validateName ? 'Name Can\'t Be Empty' : "",
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
