import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors
            .transparent, // Set the AppBar background color to transparent
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const EditProfilePage(),
    );
  }
}



class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<Map<String, dynamic>> allergensList = [];

  void _addNewAllergen() {
    setState(() {
      allergensList.add({'allergen': 'Select Allergen', 'severity': 1});
    });
  }

  void _saveProfile() {
    // Implement code to save/update the user's profile information here.
    // You can use the controllers to access the user's input.
    // Ensure the data is properly saved to your database or storage.
  }

  // Method to show a dialog for image selection
  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement camera image selection logic
                },
              ),
              ListTile(
                title: Text('Gallery'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 182, 193), // Pastel Pink
              Color.fromARGB(255, 173, 216, 230), // Pastel Blue
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
                              child: CircleAvatar(
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
                            nameController, 'Name', Icons.person, Colors.black),
                        // const SizedBox(height: 15.0),
                        // _buildInputField(emailController, 'Email', Icons.email,
                        //     Colors.black),
                        const SizedBox(height: 15.0),
                        _buildInputField(phoneController, 'Phone', Icons.phone,
                            Colors.black),
                        const SizedBox(height: 15.0),
                        _buildInputField(passwordController, 'Password',
                            Icons.lock, Colors.black),
                        const SizedBox(height: 20.0),
                        for (int i = 0; i < allergensList.length; i++)
                          _buildAllergenInputFields(i),
                        ElevatedButton(
                          onPressed: _addNewAllergen,
                          child: const Text(
                            'Add Allergen',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Button text color
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFe7236a), // Button color
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
                            'Update Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Button text color
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFe7236a), // Button color
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

  Widget _buildInputField(TextEditingController controller, String label,
      IconData icon, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: 'Enter your $label',
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

  Widget _buildAllergenInputFields(int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: allergensList[index]['allergen'],
                          onChanged: (String? newValue) {
                            setState(() {
                              allergensList[index]['allergen'] = newValue;
                            });
                          },
                          items: <String>[
                            'Select Allergen',
                            'Dairy products (eg: milk)',
                            'Eggs (eg: chicken eggs)',
                            'Peanuts (eg: peanut butter)',
                            'Tree nuts (eg: almonds)',
                            'Soybeans (eg: soy milk)',
                            'Wheat (eg: bread)',
                            'Seeds (eg: sesame)',
                            'Fish (eg: tuna)',
                            'Shellfish (eg: shrimp)',
                            'Sulfites (e.g., dried fruits)',
                            'Chickpeas (e.g., hummus)',
                            'Lentils (e.g., lentil soup)',
                            'Peas (e.g., green peas)',
                            'Potatoes (e.g., mashed potato)',
                            'Soy sauce (e.g., for seasoning)',
                            'Fish sauce (e.g., Asian dishes)',
                            'Shellfish extract (e.g., broth)',
                            'MSG (Monosodium glutamate)',
                            'Food dyes (e.g., Red 40)',
                            'Preservatives',
                            'Artificial sweeteners',
                            'Penicillins (eg: penicillin)',
                            'Cephalosporin (eg: cefaclor)',
                            'Sulfonamides (eg: Mafenide)',
                            'Ibuprofen (eg: Midol)',
                            'Aspirin (eg: Advil)',
                            'Acetaminophen (eg: Panadol)',
                            'ARBs (e.g., losartan)',
                            'Anticonvulsants (eg: valproic)',
                            'Insulin (eg: Humulin)',
                            'NSAIDs drugs (eg: ibuprofen)',
                            'ACE inhibitors (e.g., lisinopril)',
                            // 'Macrolides (e.g., azithromycin)',
                            // 'Tetracyclines (e.g., doxycycline)',
                            // 'Quinolones (e.g., ciprofloxacin)',
                            // 'Aminoglycosides (e.g., Amikacin)',
                            // ... (other items)
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        'Severity:',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${allergensList[index]['severity']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Slider(
              value: allergensList[index]['severity'].toDouble(),
              min: 1,
              max: 10,
              onChanged: (double value) {
                setState(() {
                  allergensList[index]['severity'] = value.round();
                });
              },
              divisions: 9,
              label: allergensList[index]['severity'].toString(),
            ),
          ],
        ),
      ),
    );
  }
}