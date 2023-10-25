import 'dart:io';

import 'package:flutter/material.dart';

import '../controller/controller.dart';
import '../model/person.dart';
import 'add_update.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Person>>? list;

  late PersonController db;

  getRefresh() {
    db = PersonController();
    setState(() {
      list = db.getPersonData();
    });
  }

  @override
  void initState() {
    getRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Flutter'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 600,
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
                      return Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: FileImage(
                                  File(per.image),
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
                                      builder: (context) =>
                                          const AddAndUpdateScreen(
                                              text: 'Update'),
                                    ));
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddAndUpdateScreen(text: 'Save'),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
