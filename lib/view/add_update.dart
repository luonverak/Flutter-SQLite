import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_storage/model/person.dart';
import 'package:local_storage/view/home_screen.dart';

import '../controller/controller.dart';
import '../widget/input_field.dart';

class AddAndUpdateScreen extends StatefulWidget {
  const AddAndUpdateScreen({super.key, required this.text, this.person});
  final String text;
  final Person? person;

  @override
  State<AddAndUpdateScreen> createState() => _AddAndUpdateScreenState();
}

class _AddAndUpdateScreenState extends State<AddAndUpdateScreen> {
  File? _file;

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
        title: Text(widget.text),
        actions: [
          IconButton(
            onPressed: () async {
              openGallery();
            },
            icon: const Icon(Icons.photo),
          ),
          IconButton(
            onPressed: () async {
              openCamera();
            },
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
                  borderRadius: BorderRadius.circular(100),
                  image: (_file != null)
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_file!),
                        )
                      : const DecorationImage(
                          image: AssetImage('asset/images/user.png'),
                        ),
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
        onPressed: () async {
          (widget.text == 'Save') ? save() : update();
        },
        child: (widget.text == 'Save')
            ? const Icon(Icons.add)
            : const Icon(
                Icons.edit,
              ),
      ),
    );
  }

  void save() async {
    await PersonController()
        .insertData(
          Person(
            id: Random().nextInt(10000),
            name: fullname.text,
            sex: gender.text,
            age: int.parse(age.text),
            image: _file!.path,
          ),
        )
        .whenComplete(() => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false));
  }

  void update() async {
    await PersonController()
        .updatePersonData(Person(
          id: widget.person!.id,
          name: fullname.text,
          sex: gender.text,
          age: int.parse(age.text),
          image: _file == null ? widget.person!.image : _file!.path,
        ))
        .whenComplete(() => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false));
  }

  Future openGallery() async {
    final fileChoose =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _file = File(fileChoose!.path);
    });
  }

  Future openCamera() async {
    final fileChoose =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _file = File(fileChoose!.path);
    });
  }
}
