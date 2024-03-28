class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.age});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        age: json["age"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
    };
  }
}
