import 'package:flutter/material.dart';

class AllergenPage extends StatefulWidget {
  const AllergenPage({super.key});

  @override
  State<AllergenPage> createState() => _AllergenPageState();
}

class _AllergenPageState extends State<AllergenPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

// import 'package:allergygenieapi/bloc/allergen_bloc.dart';
// import 'package:allergygenieapi/helpers/http_response.dart';
// import 'package:allergygenieapi/models/allergen/allergen_model.dart';
// import 'package:allergygenieapi/models/allergen/list_allergen_response_model.dart';
// import 'package:allergygenieapi/models/user/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class AllergenPage extends StatefulWidget {
//   final User user;

//   const AllergenPage({Key? key, required this.user}) : super(key: key);

//   @override
//   State<AllergenPage> createState() => _AllergenPageState();
// }

// class _AllergenPageState extends State<AllergenPage> {
//   AllergenBloc allergenBloc = AllergenBloc();
//   static const _pageSize = 10;
//   final PagingController<int, Allergen> _allergenPagingController =
//       PagingController(firstPageKey: 1);

//   RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   late Future<List<Allergen>> _allergenListFuture;
//   int? _selectedAllergend;

//   @override
//   void initState() {
//     super.initState();
//     _allergenListFuture = _fetchCourseList();
//     _allergenPagingController.addPageRequestListener((pageKey) {
//       _fetchPage(pageKey);
//     });
//   }

//   Future<List<Allergen>> _fetchCourseList() async {
//     try {
//       final ListAllergenResponseModel response =
//           await allergenBloc.getListAllergen();

//       if (response.statusCode == HttpResponse.HTTP_OK) {
//         return response.data ?? [];
//       } else {
//         throw Exception(response.message);
//       }
//     } catch (error) {
//       throw Exception("Server Error");
//     }
//   }

//   void _onRefresh() async {
//     _allergenPagingController.refresh();
//     _refreshController.refreshCompleted();
//   }

//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       final ListAllergenResponseModel response =
//           await allergenBloc.getListAllergen();

//       if (response.statusCode == HttpResponse.HTTP_OK) {
//         List<Allergen> allergenModel = response.data!;

//         final isLastPage = allergenModel.length < _pageSize;
//         if (isLastPage) {
//           _allergenPagingController.appendLastPage(allergenModel);
//         } else {
//           final nextPageKey = pageKey + allergenModel.length;
//           _allergenPagingController.appendPage(allergenModel, nextPageKey);
//         }

//         print(allergenModel);
//       } else {
//         _allergenPagingController.error = response.message;
//         print(response.message);
//       }
//     } catch (error) {
//       _allergenPagingController.error = "Server Error";
//     }
//   }

//   int delayAnimationDuration = 100;

//   late List<Allergen> _allergenList = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 2.0,
//         title: Text('Allergen Page'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               // Refresh action
//               _onRefresh();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<List<Allergen>>(
//           future: _allergenListFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             } else {
//               _allergenList = snapshot.data!;

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // _buildDropdown(),
//                   const SizedBox(height: 16.0),
//                   Expanded(
//                     child: _buildAllergenForm(),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildAllergenForm() {
//     return _selectedAllergenId != null
//         ? _buildEditAllergenForm()
//         : _buildAddAllergenForm();
//   }

//   // Widget _buildDropdown() {
//   //   return Container(
//   //     width: double.infinity,
//   //     decoration: BoxDecoration(
//   //       border: Border.all(
//   //         color: Colors.grey,
//   //         width: 1.0,
//   //       ),
//   //       borderRadius: BorderRadius.circular(10.0),
//   //     ),
//   //     child: Padding(
//   //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//   //       child: DropdownButtonFormField<Medication>(
//   //         isExpanded: true,
//   //         decoration: const InputDecoration(
//   //           border: InputBorder.none,
//   //           hintText: 'Select Medication',
//   //         ),
//   //         value: _selectedMedicationId != null
//   //             ? _medicationList.firstWhere(
//   //                 (medication) => medication.id == _selectedMedicationId)
//   //             : null,
//   //         onChanged: (Medication? selectedMedication) {
//   //           setState(() {
//   //             _selectedMedicationId = selectedMedication?.id;
//   //           });
//   //         },
//   //         items: _medicationList.map((Medication medication) {
//   //           return DropdownMenuItem<Medication>(
//   //             value: medication,
//   //             child: Text(medication.name ?? 'null'),
//   //           );
//   //         }).toList(),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildAddAllergenForm() {
//     TimeOfDay selectedTime = TimeOfDay.now(); // Initialize selectedTime here
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         // const Text(
//         //   'Add Allergen',
//         //   style: TextStyle(
//         //     fontSize: 20.0,
//         //     fontWeight: FontWeight.bold,
//         //   ),
//         // ),
//         const SizedBox(height: 16.0),
//         ListTile(
//           title: const Text(
//             'Time:',
//             style: TextStyle(
//               fontSize: 18.0,
//             ),
//           ),
//           trailing: TextButton(
//             onPressed: () async {
//               final selectedNewTime = await showTimePicker(
//                 context: context,
//                 initialTime: selectedTime,
//               );
//               if (selectedNewTime != null) {
//                 setState(() {
//                   selectedTime = selectedNewTime;
//                 });
//               }
//             },
//             child: Text(
//               selectedTime.format(context),
//               style: const TextStyle(
//                 fontSize: 18.0,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         _buildDropdownSelector(),
//         const SizedBox(height: 16.0),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.grey,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Dosage',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         ElevatedButton(
//           onPressed: () {
//             // Add logic to save the new medication reminder
//             // ...

//             // Optionally, you can navigate back to the previous screen
//             Navigator.of(context).pop();
//           },
//           style: ElevatedButton.styleFrom(
//             primary: Colors.blue, // background color
//             onPrimary: Colors.white, // text color
//           ),
//           child: const Text('Save Allergen'),
//         ),
//         const SizedBox(height: 16.0),
//       ],
//     );
//   }

//   Widget _buildEditAllergenForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         const Text(
//           'Edit Allergen',
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         _buildDropdownSelector(),
//         const SizedBox(height: 16.0),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.grey,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Dosage',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         ElevatedButton(
//           onPressed: () {
//             // Add logic to save the edited medication reminder
//             // ...

//             // Optionally, you can navigate back to the previous screen
//             Navigator.of(context).pop();
//           },
//           style: ElevatedButton.styleFrom(
//             primary: Colors.green, // background color
//             onPrimary: Colors.white, // text color
//           ),
//           child: const Text('Save Allergen'),
//         ),
//         const SizedBox(height: 16.0),
//       ],
//     );
//   }

//   Widget _buildDropdownSelector() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.grey,
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: DropdownButtonFormField<Allergen>(
//           isExpanded: true,
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             hintText: 'Select Allergen',
//           ),
//           value: _selectedAllergenId != null
//               ? _allergenList
//                   .firstWhere((allergen) => allergen.id == _selectedAllergenId)
//               : null,
//           onChanged: (Allergen? selectedAllergen) {
//             setState(() {
//               _selectedAllergenId = selectedAllergen?.id;
//             });
//           },
//           items: _allergenList.map((Allergen allergen) {
//             return DropdownMenuItem<Allergen>(
//               value: allergen,
//               child: Text(allergen.name ?? 'null'),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }