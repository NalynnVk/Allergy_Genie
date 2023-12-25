import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';
import 'package:allergygenieapi/screens/user/update_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(user: widget.user),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Name: ${widget.user.name}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Date of Birth: ${widget.user.date_of_birth}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Use Navigator.push and then to handle auto-refresh
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(user: widget.user)),
              );
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }
}
