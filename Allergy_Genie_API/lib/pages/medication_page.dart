import 'package:allergygenieapi/bloc/med_reminder_bloc.dart';
import 'package:allergygenieapi/bloc/medication_bloc.dart';
import 'package:allergygenieapi/helpers/general_method.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_request_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_response_model.dart';
import 'package:allergygenieapi/models/medication/list_medication_response_model.dart';
import 'package:allergygenieapi/models/medication/medication_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/med_reminder_page.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MedicationPage extends StatefulWidget {
  static const routeName = '/medicationreminder'; // dian line 13
  final User user;

  const MedicationPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  final formKey = GlobalKey<FormState>(); // dian line 21
  MedReminderRequestModel medreminderRequestModel =
      MedReminderRequestModel(); // dian line 22

  MedicationBloc medicationBloc = MedicationBloc();
  static const _pageSize = 10;
  final PagingController<int, Medication> _medicationPagingController =
      PagingController(firstPageKey: 1);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<List<Medication>> _medicationListFuture;
  int? _selectedMedicationId;

  bool _isLoading = false; // dian line 84
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // dian line 85

  @override
  void initState() {
    super.initState();
    _medicationListFuture = _fetchCourseList();
    _medicationPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<List<Medication>> _fetchCourseList() async {
    try {
      final ListMedicationResponseModel response =
          await medicationBloc.getListMedication();

      if (response.statusCode == HttpResponse.HTTP_OK) {
        return response.data ?? [];
      } else {
        throw Exception(response.message);
      }
    } catch (error) {
      throw Exception("Server Error");
    }
  }

  void _onRefresh() async {
    _medicationPagingController.refresh();
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final ListMedicationResponseModel response =
          await medicationBloc.getListMedication();

      if (response.statusCode == HttpResponse.HTTP_OK) {
        List<Medication> medicationModel = response.data!;

        final isLastPage = medicationModel.length < _pageSize;
        if (isLastPage) {
          _medicationPagingController.appendLastPage(medicationModel);
        } else {
          final nextPageKey = pageKey + medicationModel.length;
          _medicationPagingController.appendPage(medicationModel, nextPageKey);
        }

        print(medicationModel);
      } else {
        _medicationPagingController.error = response.message;
        print(response.message);
      }
    } catch (error) {
      _medicationPagingController.error = "Server Error";
    }
  }

  int delayAnimationDuration = 100;

  late List<Medication> _medicationList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Medication Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh action
              _onRefresh();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Medication>>(
          future: _medicationListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              _medicationList = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // _buildDropdown(),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: _buildMedicationForm(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMedicationForm() {
    return _selectedMedicationId != null
        ? _buildEditMedicationForm()
        : _buildAddMedicationForm();
  }

  // Widget _buildDropdown() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: Colors.grey,
  //         width: 1.0,
  //       ),
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: DropdownButtonFormField<Medication>(
  //         isExpanded: true,
  //         decoration: const InputDecoration(
  //           border: InputBorder.none,
  //           hintText: 'Select Medication',
  //         ),
  //         value: _selectedMedicationId != null
  //             ? _medicationList.firstWhere(
  //                 (medication) => medication.id == _selectedMedicationId)
  //             : null,
  //         onChanged: (Medication? selectedMedication) {
  //           setState(() {
  //             _selectedMedicationId = selectedMedication?.id;
  //           });
  //         },
  //         items: _medicationList.map((Medication medication) {
  //           return DropdownMenuItem<Medication>(
  //             value: medication,
  //             child: Text(medication.name ?? 'null'),
  //           );
  //         }).toList(),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAddMedicationForm() {
    TimeOfDay selectedTime = TimeOfDay.now(); // Initialize selectedTime here
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // const Text(
        //   'Add Medication',
        //   style: TextStyle(
        //     fontSize: 20.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        const SizedBox(height: 16.0),
        ListTile(
          title: const Text(
            'Time:',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          trailing: TextButton(
            onPressed: () async {
              final selectedNewTime = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (selectedNewTime != null) {
                setState(() {
                  selectedTime = selectedNewTime;
                });
              }
            },
            child: Text(
              selectedTime.format(context),
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        _buildDropdownSelector(),
        const SizedBox(height: 16.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Dosage',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Add logic to save the new medication reminder
            // ...

            // Optionally, you can navigate back to the previous screen
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // background color
            onPrimary: Colors.white, // text color
          ),
          child: const Text('Save Medication'),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildEditMedicationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Edit Medication',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        _buildDropdownSelector(),
        const SizedBox(height: 16.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Dosage',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // ElevatedButton(
        //   onPressed: () async {
        //     MedReminderBloc medreminderBloc =
        //         MedReminderBloc(); // dian line 380
        //     MedReminderResponseModel medReminderResponseModel =
        //         await medreminderBloc
        //             .createMedReminder(MedReminderRequestModel);

        //     if (medReminderResponseModel.isSuccess) {
        //       if (mounted) {
        //         navigateTo(
        //             context,
        //             MedReminderPage(
        //               user: medReminderResponseModel.data!,
        //             ));
        //       }

        //       print(medReminderResponseModel);
        //     } else {
        //       print(medReminderResponseModel.message);
        //     }
        //   },
        //   style: ElevatedButton.styleFrom(
        //     minimumSize: const Size(300, 60),
        //     primary: Theme.of(context).highlightColor,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(30.0),
        //     ),
        //     elevation: 8,
        //   ),
        //   child: const Text(
        //     'Save Medication Reminder',
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDropdownSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<Medication>(
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Select Medication',
          ),
          value: _selectedMedicationId != null
              ? _medicationList.firstWhere(
                  (medication) => medication.id == _selectedMedicationId)
              : null,
          onChanged: (Medication? selectedMedication) {
            setState(() {
              _selectedMedicationId = selectedMedication?.id;
            });
          },
          items: _medicationList.map((Medication medication) {
            return DropdownMenuItem<Medication>(
              value: medication,
              child: Text(medication.name ?? 'null'),
            );
          }).toList(),
        ),
      ),
    );
  }
}
