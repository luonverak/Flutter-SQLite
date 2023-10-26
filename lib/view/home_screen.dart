import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../controller/controller.dart';
import '../model/person.dart';
import 'add_screen.dart';
import 'update_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Person>>? list;

  late PersonController db;
  Future refresh() async {
    db = PersonController();
    setState(() {
      list = db.getPersonData();
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  var item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL Flutter'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 700,
            width: double.infinity,
            child: FutureBuilder<List<Person>>(
              future: list,
              builder: (context, AsyncSnapshot<List<Person>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Icon(
                      Icons.info,
                      color: Colors.red,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var per = snapshot.data![index];
                      item = per;
                      return Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(per.image),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  per.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('age: ${per.age}'),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                      text: 'Update',
                                      person: per,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  title: 'Delete',
                                  desc: 'Are you sur for delete?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    await PersonController()
                                        .deletePersonData(per.id)
                                        .whenComplete(
                                          () => refresh(),
                                        );
                                  },
                                ).show();
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScreen(
                text: 'Save',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
