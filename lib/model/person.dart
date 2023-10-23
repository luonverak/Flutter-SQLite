class Person {
  final int id;
  final String name;
  final String sex;
  final int age;
  final String image;

  Person(
      {required this.id,
      required this.name,
      required this.sex,
      required this.age,
      required this.image});
  Map<String, dynamic> fromJson() {
    return {
      'id': id,
      'name': name,
      'sex': sex,
      'age': age,
      'image': image,
    };
  }

  Person.toJson(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sex = res['sex'],
        age = res['age'],
        image = res['image'];
}
