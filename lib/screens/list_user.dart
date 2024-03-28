import 'package:flutter/material.dart';
import 'package:user_management/models/user.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({super.key});

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  final List<UserModel> users = [
    UserModel(
        id: '1', name: 'John Doe', email: 'john.doe@example.com', age: 30),
    UserModel(
        id: '2', name: 'Jane Smith', email: 'jane.smith@example.com', age: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Users'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          UserModel user = users[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(user.name[0]),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Text("${user.age} years old"),
          );
        },
      ),
    );
  }
}
