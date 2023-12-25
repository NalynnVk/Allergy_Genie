import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/models/user/user_request_model.dart';
import 'package:allergygenieapi/models/user/user_response_model.dart';
import 'package:allergygenieapi/screens/basic/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  UserRequestModel userRequestModel = UserRequestModel();

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override // dian line 87
  void initState() {
    // dian line 88
    super.initState(); // dian line 89
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                },
                onEditingComplete: () {
                  setState(() {
                    userRequestModel.name = _nameController.text;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    userRequestModel.name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              // You can use a date picker library or implement your own
              // For simplicity, we will use a simple TextFormField for DOB
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                },
                onEditingComplete: () {
                  setState(() {
                    userRequestModel.date_of_birth = _dobController.text;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    userRequestModel.date_of_birth = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                },
                onEditingComplete: () {
                  setState(() {
                    userRequestModel.password = _passwordController.text;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    userRequestModel.password = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                },
                onEditingComplete: () {
                  setState(() {
                    userRequestModel.phone_number = _phoneNumberController.text;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    userRequestModel.phone_number = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Validate the form before processing
                  if (_formKey.currentState!.validate()) {
                    print('Name: ${_nameController.text}');
                    print('Date of Birth: ${_dobController.text}');
                    print('Password: ${_passwordController.text}');
                    print('Phone Number: ${_phoneNumberController.text}');

                    UserBloc userBloc = UserBloc(); // dian line 380
                    UserResponseModel userResponseModel =
                        await userBloc.register(userRequestModel);

                    if (userResponseModel.isSuccess) {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      }

                      print(userResponseModel);
                    } else {
                      print(userResponseModel.message);
                    }
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
