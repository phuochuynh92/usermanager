import 'package:flutter/material.dart';
import 'package:user_management/models/user.dart';

class UserCart extends StatelessWidget {
  final UserModel userModel;
  final Function(UserModel userModel)? onEditPressed;
  final Function(UserModel userModel)? onDeletePressed;

  const UserCart({
    super.key,
    required this.userModel,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        color: Colors.amberAccent,
        child: ListTile(
          leading: Icon(Icons.people),
          title: Text('${userModel.name} -- ${userModel.age}'),
          subtitle: Text(userModel.email),
          trailing: Container(
            // Specify a fixed width for the trailing widget.
            // Adjust the width as needed to fit your icons.
            width: 96,
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // Required to constrain space for Row children
              children: [
                IconButton(
                  onPressed: () => onEditPressed?.call(userModel),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => onDeletePressed?.call(userModel),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
