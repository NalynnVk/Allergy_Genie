import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


// class SignUp extends StatelessWidget {
//   const SignUp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Allergy Genie',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.deepPurple,
//         highlightColor: Colors.pink,
//         fontFamily: 'Roboto',
//       ),
//       home: const SignUpPage(),
//     );
//   }
// }

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key});

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final List<Map<String, dynamic>> allergensList = [];

//   String dropdownValue = 'Allergen';

//   void _addNewAllergen() {
//     setState(() {
//       allergensList.add({'allergen': 'Select Allergen', 'severity': 1});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(255, 194, 182, 255),
//               Color.fromARGB(255, 255, 91, 146),
//             ],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(32.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'images/AllergyGenieLogo.png',
//                     height: 100,
//                   ),
//                   const SizedBox(height: 20.0),
//                   _buildInputField(nameController, 'Name', Icons.person),
//                   const SizedBox(height: 15.0),
//                   _buildInputField(
//                       dobController, 'Date of Birth', Icons.date_range),
//                   const SizedBox(height: 15.0),
//                   _buildInputField(
//                       phoneController, 'Phone Number', Icons.phone),
//                   const SizedBox(height: 15.0),
//                   _buildInputField(passwordController, 'Password', Icons.lock),
//                   const SizedBox(height: 20.0),
//                   for (int i = 0; i < allergensList.length; i++)
//                     _buildAllergenInputFields(i),
//                   // ElevatedButton(
//                   //   onPressed: _addNewAllergen,
//                   //   child: const Text(
//                   //     'Add Allergen',
//                   //     style: TextStyle(
//                   //       fontSize: 20,
//                   //       fontWeight: FontWeight.bold,
//                   //     ),
//                   //   ),
//                   //   style: ElevatedButton.styleFrom(
//                   //     primary: Theme.of(context).highlightColor,
//                   //     shape: RoundedRectangleBorder(
//                   //       borderRadius: BorderRadius.circular(30.0),
//                   //     ),
//                   //     minimumSize: const Size(300, 60),
//                   //     padding: const EdgeInsets.symmetric(vertical: 16),
//                   //   ),
//                   // ),
//                   // const SizedBox(height: 20.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle sign-up logic here
//                     },
//                     child: const Text(
//                       'Sign Up',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(300, 60),
//                       primary: Theme.of(context).highlightColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       elevation: 8,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(
//                           builder: (BuildContext context) {
//                             return LoginPage();
//                           },
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Already have an account? Sign In',
//                       style:
//                           TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                     ),
//                     style: TextButton.styleFrom(
//                       primary: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(
//       TextEditingController controller, String label, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.text,
//         decoration: InputDecoration(
//           hintText: 'Enter your $label',
//           labelText: label,
//           fillColor: Colors.white,
//           filled: true,
//           prefixIcon: Icon(
//             icon,
//             color: Theme.of(context).primaryColor,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30.0),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         onTap: () async {
//           if (label == 'Date of Birth') {
//             // Show date picker when the text field is tapped
//             DateTime? pickedDate = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(1900),
//               lastDate: DateTime.now(),
//               builder: (BuildContext context, Widget? child) {
//                 return Theme(
//                   data: ThemeData.light().copyWith(
//                     primaryColor:
//                         Colors.deepPurple, // Set your desired color here
//                     colorScheme:
//                         const ColorScheme.light(primary: Colors.deepPurple),
//                     buttonTheme: const ButtonThemeData(
//                         textTheme: ButtonTextTheme.primary),
//                   ),
//                   child: child!,
//                 );
//               },
//             );
//             if (pickedDate != null && pickedDate != DateTime.now()) {
//               // Update the text field with the selected date
//               controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//             }
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildAllergenInputFields(int index) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 1,
//                     blurRadius: 2,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: DropdownButton<String>(
//                           value: allergensList[index]['allergen'],
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               allergensList[index]['allergen'] = newValue;
//                             });
//                           },
//                           items: <String>[
//                             'Select Allergen',
//                             'Dairy products (eg: milk)',
//                             'Eggs (eg: chicken eggs)',
//                             'Peanuts (eg: peanut butter)',
//                             'Tree nuts (eg: almonds)',
//                             'Soybeans (eg: soy milk)',
//                             'Wheat (eg: bread)',
//                             'Seeds (eg: sesame)',
//                             'Fish (eg: tuna)',
//                             'Shellfish (eg: shrimp)',
//                             'Sulfites (e.g., dried fruits)',
//                             'Chickpeas (e.g., hummus)',
//                             'Lentils (e.g., lentil soup)',
//                             'Peas (e.g., green peas)',
//                             'Potatoes (e.g., mashed potato)',
//                             'Soy sauce (e.g., for seasoning)',
//                             'Fish sauce (e.g., Asian dishes)',
//                             'Shellfish extract (e.g., broth)',
//                             'MSG (Monosodium glutamate)',
//                             'Food dyes (e.g., Red 40)',
//                             'Preservatives',
//                             'Artificial sweeteners',
//                             'Penicillins (eg: penicillin)',
//                             'Cephalosporin (eg: cefaclor)',
//                             'Sulfonamides (eg: Mafenide)',
//                             'Ibuprofen (eg: Midol)',
//                             'Aspirin (eg: Advil)',
//                             'Acetaminophen (eg: Panadol)',
//                             'ARBs (e.g., losartan)',
//                             'Anticonvulsants (eg: valproic)',
//                             'Insulin (eg: Humulin)',
//                             'NSAIDs drugs (eg: ibuprofen)',
//                             'ACE inhibitors (e.g., lisinopril)',
//                             // 'Macrolides (e.g., azithromycin)',
//                             // 'Tetracyclines (e.g., doxycycline)',
//                             // 'Quinolones (e.g., ciprofloxacin)',
//                             // 'Aminoglycosides (e.g., Amikacin)',
//                             // ... (other items)
//                           ].map<DropdownMenuItem<String>>(
//                             (String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             },
//                           ).toList(),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const SizedBox(width: 10),
//                       const Text(
//                         'Severity:',
//                         style: TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '${allergensList[index]['severity']}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).highlightColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Slider(
//               value: allergensList[index]['severity'].toDouble(),
//               min: 1,
//               max: 10,
//               onChanged: (double value) {
//                 setState(() {
//                   allergensList[index]['severity'] = value.round();
//                 });
//               },
//               divisions: 9,
//               label: allergensList[index]['severity'].toString(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
