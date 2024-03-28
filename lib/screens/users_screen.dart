import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_management/db_service/db_service.dart';
import 'package:user_management/models/user.dart';
import 'package:user_management/widget/user_cart.dart';
import 'package:uuid/uuid.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final dbService = DbService();
  late Future<List<UserModel>> usersFuture;

  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final ageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usersFuture = dbService.getUser();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    emailTextController.dispose();
    ageTextController.dispose();
    super.dispose();
  }

  void showUserBottomSheet(String funcName, VoidCallback? onSavePressed) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('User Info:'),
                TextField(
                  controller: nameTextController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'User Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                TextField(
                  controller: ageTextController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Age',
                    hintText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                TextField(
                  controller: emailTextController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(onPressed: onSavePressed, child: Text(funcName))
              ],
            ),
          ),
        );
      },
    );
  }

  void addUser() {
    showUserBottomSheet('Create', () async {
      final String name = nameTextController.text;
      final String email = emailTextController.text;
      final String ageText = ageTextController.text;

      int? age = int.tryParse(ageText);
      if (name.isEmpty || email.isEmpty || age == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Please fill in all fields with valid information.')),
        );
        return;
      }

      final userModel = UserModel(
        id: Uuid().v4(),
        name: name,
        email: email,
        age: age,
      );

      try {
        await dbService.insertUser(userModel);

        setState(() {
          usersFuture = dbService.getUser();
          emailTextController.clear();
          nameTextController.clear();
          ageTextController.clear();
        });
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding user: $e')),
        );
      }
    });
  }

  void editUser(UserModel userModel) {
    emailTextController.text = userModel.email;
    nameTextController.text = userModel.name;
    ageTextController.text = '${userModel.age}';
    showUserBottomSheet('Edit', () {
      final name = nameTextController.text;
      final age = int.parse(ageTextController.text);
      final email = emailTextController.text;

      final userModelUpdate =
          UserModel(id: userModel.id, name: name, email: email, age: age);
      dbService.updateUser(userModelUpdate);
      setState(() {
        usersFuture = dbService.getUser();
        emailTextController.clear();
        nameTextController.clear();
        ageTextController.clear();
      });
      Navigator.of(context).pop();
    });
  }

  void deleteUser(UserModel userModel) async {
    try {
      await dbService.deleteUser(userModel);

      setState(() {
        usersFuture = dbService.getUser();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Management'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Cannot load user list'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final List<UserModel> userList = snapshot.data!;
            if (userList.isEmpty) {
              return Center(child: Text('No users found!'));
            }
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return UserCart(
                  userModel: userList[index],
                  onEditPressed: editUser,
                  onDeletePressed: deleteUser,
                );
              },
            );
          } else {
            return Center(child: Text('No users found!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addUser();
        },
      ),
    );
  }
}
