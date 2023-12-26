import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/home_page.dart';
import 'package:allergygenieapi/public_components/custom_dialog.dart';
import 'package:allergygenieapi/screens/basic/homepage_screen.dart';
import 'package:allergygenieapi/screens/insight/list_insight_screen.dart';
import 'package:allergygenieapi/screens/medicationReminder/list_reminder_screen.dart';
import 'package:allergygenieapi/screens/user/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  final User user;
  const AppDrawer({super.key, required this.user});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: const EdgeInsets.only(left: 20),
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigate to the desired page when the avatar is tapped
              //     // Navigator.pushReplacement(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //     builder: (context) => ProfilePage(user: widget.user),
              //     //   ),
              //     // );
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(right: 10.0),
              //     child: Align(
              //       alignment: Alignment.topRight,
              //       child: CircleAvatar(
              //         radius: 40,
              //         backgroundColor: Colors.transparent,
              //         backgroundImage: AssetImage('images/AllergyGenieLogo.png'),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Medication Info'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ListReminderScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Insight'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ListInsightScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Logout',
              style: TextStyle(color: kDanger),
            ),
            onTap: () async {
              // Navigator.pop(context);
              print("logout");
              UserBloc userBloc = UserBloc();
              CustomDialog.show(context,
                  dismissOnTouchOutside: false,
                  description: "Logging you out...",
                  center: ThemeSpinner.spinner());
              await userBloc.signOut(context);
            },
          ),
          ListTile(
            onTap: () {
              _openDialerWithNumber();
            },
            leading: const Icon(Iconsax.alarm5),
            title: const Text(
              "Emergency Contact",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black, // Text color
                fontSize: 18, // Text size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            onTap: () {
                
            },
            leading: const Icon(Iconsax.alarm5),
            title: const Text(
              "Care Plan",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black, // Text color
                fontSize: 18, // Text size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _openDialerWithNumber() async {
  // Replace '0182896587' with your specific emergency number
  String phoneNumber = '999';

  String url = 'tel:$phoneNumber';

  try {
    await launch(url);
  } catch (error) {
    print('Error opening dialer: $error');
    // Handle error as needed
  }
}
