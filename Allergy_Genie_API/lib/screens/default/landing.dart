import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/screens/basic/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'images/AllergyGenieLogo.png',
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 160.0),
              width: 200.0,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the login screen when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
