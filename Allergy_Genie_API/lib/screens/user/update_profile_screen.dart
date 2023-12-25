import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/models/user/user_request_model.dart';
import 'package:allergygenieapi/models/user/user_response_model.dart';
import 'package:allergygenieapi/models/user/user_update_request_model.dart';
import 'package:allergygenieapi/screens/basic/login_screen.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';
import 'package:allergygenieapi/screens/user/profile_screen.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  final User user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  UpdateUserRequestModel userRequestModel = UpdateUserRequestModel();

  late TextEditingController _nameController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();

    // Set initial values if the widget.user has values
    _nameController = TextEditingController(text: widget.user.name);
    _dobController = TextEditingController(text: widget.user.date_of_birth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(user: widget.user),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    UserBloc userBloc = UserBloc();
                    UserResponseModel userResponseModel = await userBloc.update(
                        userRequestModel, widget.user.id!);

                    if (userResponseModel.isSuccess) {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(user: widget.user)),
                        );
                      }
                    } else {
                      print(userResponseModel.message);
                    }
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
