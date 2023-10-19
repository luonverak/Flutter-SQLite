import 'package:flutter/material.dart';

import '../widget/input_field.dart';

class AddAndUpdateScreen extends StatelessWidget {
  AddAndUpdateScreen({
    super.key,
    required this.text,
  });
  final String text;

  TextEditingController fullname = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController age = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.photo),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
          InputField(
            hintText: 'Full Name',
            stringText: fullname,
          ),
          InputField(
            hintText: 'Gender',
            stringText: gender,
          ),
          InputField(
            hintText: 'Age',
            stringText: age,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child:
            (text == 'Save') ? const Icon(Icons.save) : const Icon(Icons.edit),
      ),
    );
  }
}
