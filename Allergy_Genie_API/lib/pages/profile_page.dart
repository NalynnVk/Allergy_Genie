// import 'package:allergygenieapi/models/tracking/tracking_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/add_allergen_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  // final Tracking tracking;
  final User user;
  // final Allergen allergen;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: EditProfilePage(
        user: widget.user,
        // allergen: widget.allergen,
        // allergen: widget.allergen,
        // tracking: widget.tracking,
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final User user;
  // final Allergen allergen;
  // final Tracking tracking;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 182, 193),
              Color.fromARGB(255, 173, 216, 230),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GestureDetector(
                              onTap: () => _showImagePickerDialog(context),
                              child: const CircleAvatar(
                                radius: 60,
                                // backgroundImage:
                                //     AssetImage('images/profile_image2.jpg'),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit profile picture functionality
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        _buildInputField(
                          user.name,
                          'Name',
                          Icons.person,
                          Colors.black,
                        ),
                        const SizedBox(height: 15.0),
                        _buildInputField(
                          user.phone_number,
                          'Phone',
                          Icons.phone,
                          Colors.black,
                        ),
                        // const SizedBox(height: 15.0),
                        // _buildInputField(
                        //   user.allergen!.name,
                        //   'Allergen',
                        //   Icons.no_food_outlined,
                        //   Colors.black,
                        // ),
                        // Text(
                        //   'Allergen Type: ${user.allergen!.name}',
                        //   style: const TextStyle(
                        //     color: Colors.blue,
                        //     fontSize: 15,
                        //   ),
                        // ),
                        // const SizedBox(height: 5),
                        // Text(
                        //   'Severity Level: ${user.symptom!.severity}',
                        //   style: const TextStyle(
                        //     color: Colors.blue,
                        //     fontSize: 15,
                        //   ),
                        // ),
                        // const SizedBox(height: 15.0),
                        // Text(
                        //   'Allergen Type: ${tracking.allergen!.name}',
                        //   style: const TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(height: 15.0),
                        // Text(
                        //   'Severity Level: ${tracking.symptom!.severity}',
                        //   style: const TextStyle(
                        //     color: Colors.blue,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddAllergenPage(user: user),
                              ),
                            );
                          },
                          child: const Text(
                            'Add Allergen',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFe7236a),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(300, 60),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 35, 136, 231),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size(300, 60),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String? value,
    String label,
    IconData icon,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        // Remove readOnly or set it to false
        initialValue: value ?? '', // Use an empty string if value is null
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            icon,
            color: Colors.deepPurple,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    // Implement code to save/update the user's profile information here.
    // You can use the controllers to access the user's input.
    // Ensure the data is properly saved to your database or storage.
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement camera image selection logic
                },
              ),
              ListTile(
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement gallery image selection logic
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // SALAH PAGE => med_reminder_page.dart
  // Future<void> _showAddDialog(BuildContext context) async {
  //   TimeOfDay selectedTime = TimeOfDay.now(); // Initialize selectedTime here

  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         title: const Center(child: Text('Add Meds Reminder')),
  //         content: StatefulBuilder(
  //           builder: (context, setState) {
  //             return const Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                   child: TextField(
  //                     decoration: InputDecoration(labelText: 'Allergen Type'),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                   child: TextField(
  //                     // controller: dosageController,
  //                     decoration: InputDecoration(labelText: 'Severity'),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Add logic to save the new medication reminder
  //               // ...

  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _showEditDialog(BuildContext context, User user) async {
  //   TimeOfDay selectedTime = TimeOfDay.now(); // Initialize selectedTime here

  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         title: const Center(child: Text('Edit Allergen Info')),
  //         content: StatefulBuilder(
  //           builder: (context, setState) {
  //             return const Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       labelText: 'Allergen Type',
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       labelText: 'Severity',
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Add logic to save the edited medication reminder
  //               // ...

  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
