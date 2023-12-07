import 'package:allergygenieapi/log_in.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/care_plan_page.dart';
// import 'package:allergygenieapi/pages/emergency_contact_page.dart';
import 'package:allergygenieapi/pages/home_page.dart';
import 'package:allergygenieapi/pages/insight_page.dart';
import 'package:allergygenieapi/pages/med_reminder_page.dart';
import 'package:allergygenieapi/pages/profile_page.dart';
import 'package:allergygenieapi/pages/report_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class BasePage extends StatefulWidget {
  final User user;
  final Widget body;
  const BasePage({Key? key, required this.user, required this.body})
      : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

int _currentIndex = 0;

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title
        titleSpacing: 0.0, // Adjust the spacing around the title as needed
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            'images/AllergyGenieLogo.png',
            height: 60,
          ),
        ),
        backgroundColor: Colors.blue,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
        //     child: SizedBox(
        //       child: IconButton(
        //         icon: const Icon(
        //           Icons.account_circle,
        //           size: 30,
        //         ), // Set the size of the icon
        //         onPressed: () {
        //           // Navigate to admin profile settings page
        //           Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => ProfilePage(),
        //           ));
        //         },
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: widget.body,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigate to ProfilePage when the username is tapped
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(user: widget.user),
                  ));
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Display User Profile Picture
                    // CircleAvatar(
                    //   backgroundImage:
                    //       NetworkImage(widget.user.profilePicture ?? ''),
                    //   radius: 30,
                    // ),
                    SizedBox(height: 10),
                    // Display User Name
                    Text(
                      'Davikah Sharma',
                      // widget.user.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.perm_contact_cal_rounded),
              title: const Text(
                'Contacts',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  //pushReplacement - buang given existing back button
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginPage();
                    },
                  ),
                );
              },
              leading: const Icon(Icons.logout),
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 335.0),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 27.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const CarePlanPage();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.share),
                title: const Text(
                  "Share Care Plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 27.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  _openDialerWithNumber();
                },
                leading: const Icon(Iconsax.alarm5),
                title: const Text(
                  "Emergency Contact",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigation logic based on index
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomePage(user: widget.user);
                  },
                ),
              );
              break;
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MedReminderPage(user: widget.user);
                  },
                ),
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ReportPage(user: widget.user);
                  },
                ),
              );
              break;
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return InsightPage(user: widget.user);
                  },
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.difference_outlined),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insight',
          ),
        ],
      ),
    );
  }
}

// void _makeEmergencyCall() async {
//   // Replace '0182896587' with your specific emergency number
//   String phoneNumber = '0182896587';

//   try {
//     await FlutterPhoneDirectCaller.callNumber(phoneNumber);
//   } catch (error) {
//     print('Error making the call: $error');
//     // Handle error as needed
//   }
// }

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
