import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/helpers/general_method.dart';
import 'package:allergygenieapi/models/user/login_request_model.dart';
import 'package:allergygenieapi/models/user/user_response_model.dart';
import 'package:allergygenieapi/sign_up.dart';
import 'package:allergygenieapi/pages/home_page.dart';
import 'package:flutter/material.dart';

// Login Page
class LoginPage extends StatefulWidget {
  static const routeName = '/login'; // dian line 13
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>(); // dian line 21
  LoginRequestModel loginRequestModel = LoginRequestModel(); // dian line 22
  String? selectedUserType = 'User';

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false; // dian line 84
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // dian line 85

  @override // dian line 87
  void initState() {
    // dian line 88
    super.initState(); // dian line 89
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 152, 255, 226),
              Color.fromARGB(255, 162, 143, 255),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/AllergyGenieLogo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType:
                          TextInputType.phone, // Use phone keyboard type
                      onEditingComplete: () {
                        setState(() {
                          loginRequestModel.phone_number = phoneController.text;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          loginRequestModel.phone_number = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        labelText: 'Phone Number',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      onEditingComplete: () {
                        setState(() {
                          loginRequestModel.password = passwordController.text;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          loginRequestModel.password = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        UserBloc userBloc = UserBloc(); // dian line 380
                        UserResponseModel userResponseModel =
                            await userBloc.login(loginRequestModel);

                        if (userResponseModel.isSuccess) {
                          if (mounted) {
                            navigateTo(
                                context,
                                HomePage(
                                  user: userResponseModel.data!,
                                ));
                          }

                          print(userResponseModel);
                        } else {
                          print(userResponseModel.message);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 60),
                        primary: Theme.of(context).highlightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SignUp();
                          },
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size(200, 30),
                      primary: Colors.white,
                    ),
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
