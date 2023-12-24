import 'package:allergygenieapi/bloc/med_reminder_bloc.dart';
import 'package:allergygenieapi/bloc/medication_bloc.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_request_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_response_model.dart';
import 'package:allergygenieapi/models/medication/list_medication_response_model.dart';
import 'package:allergygenieapi/models/medication/medication_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddReminderPage extends StatefulWidget {
  final User user;
  const AddReminderPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TextEditingController timeReminderController = TextEditingController();
  int? selectedMedicationId;
  int selectedDosage = 1;
  // TextEditingController dosageController = TextEditingController();

  MedicationBloc medicationBloc = MedicationBloc();
  static const _pageSize = 10;
  final PagingController<int, Medication> _medicationPagingController =
      PagingController(firstPageKey: 1);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<List<Medication>> _medicationListFuture;
  int? _selectedMedicationId;

  @override
  void initState() {
    super.initState();
    _medicationListFuture = _fetchMedicationList();
    _medicationPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<List<Medication>> _fetchMedicationList() async {
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
        List<Medication> medReminderModel = response.data!;

        final isLastPage = medReminderModel.length < _pageSize;
        if (isLastPage) {
          _medicationPagingController.appendLastPage(medReminderModel);
        } else {
          final nextPageKey = pageKey + medReminderModel.length;
          _medicationPagingController.appendPage(medReminderModel, nextPageKey);
        }

        print(medReminderModel);
      } else {
        _medicationPagingController.error = response.message;
        print(response.message);
      }
    } catch (error) {
      _medicationPagingController.error = "Server Error";
    }
  }

  TimeOfDay _convertStringToTimeOfDay(String timeString) {
    final List<String> timeParts = timeString.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1].split(' ')[0]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  //   // Define a method to show the time picker
  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null && picked != timeReminderController.text) {
  //     setState(() {
  //       timeReminderController.text = picked.format(context);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: AlertDialog(
          title: Text("Medication Selection"),
          content: MedicationSelectionDialogContent(
            timeReminderController: timeReminderController,
            // dosageController: dosageController,
            selectedDosage: selectedDosage,
            selectedMedicationId: _selectedMedicationId,
            medicationListFuture: _medicationListFuture,
            onMedReminderSelected: (int? newValue) {
              setState(() {
                _selectedMedicationId = newValue;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                MedReminderBloc medReminderBloc = MedReminderBloc();
                MedReminderResponseModel responseModel =
                    await medReminderBloc.createMedReminder(
                  MedReminderRequestModel(
                    time_reminder:
                        _convertStringToTimeOfDay(timeReminderController.text),
                    // dosage: dosageController.text,
                    // dosage: selectedDosage,
                    medication_id: _selectedMedicationId, // Adjust this line
                  ),
                );
                if (responseModel.isSuccess) {
                  // Show a success SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Medication Reminder added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Delay the navigation to give time for the user to see the SnackBar
                  await Future.delayed(const Duration(seconds: 2));

                  // Navigate back to the home page
                  Navigator.pop(context);
                } else {
                  // Show an error SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Failed to add Medication Reminder: ${responseModel.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Create",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: const Color(0xFF3B4C04),
                onPrimary: const Color.fromARGB(255, 228, 226, 226),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationSelectionDialogContent extends StatelessWidget {
  const MedicationSelectionDialogContent({
    Key? key,
    required this.timeReminderController,
    // required this.dosageController,
    required this.selectedDosage,
    required this.selectedMedicationId,
    required this.medicationListFuture,
    required this.onMedReminderSelected,
  }) : super(key: key);

  final TextEditingController timeReminderController;
  // final TextEditingController dosageController;
  final int? selectedDosage;
  final int? selectedMedicationId;
  final Future<List<Medication>> medicationListFuture;
  final Function(int?) onMedReminderSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Medication>>(
            future: medicationListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No medications available.'));
              } else {
                final medications = snapshot.data!;
                return Column(
                  children: [
                    // Replace TextField with TextFormField for time
                    TextFormField(
                      controller: timeReminderController,
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          timeReminderController.text =
                              selectedTime.format(context);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Time",
                        suffixIcon: Icon(Icons.access_time),
                      ),
                    ),
                    DropdownButtonFormField<int>(
                      isDense: false,
                      isExpanded: true,
                      hint: Text('Select a medication'),
                      value: selectedMedicationId,
                      onChanged: onMedReminderSelected,
                      items: medications.map((medication) {
                        return DropdownMenuItem<int>(
                          value: medication.id,
                          child: SizedBox(
                            width: 300.0,
                            height: 70.0,
                            child: Center(
                              child: Text(medication.name ?? "null"),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // TextField(
                    //   controller: dosageController,
                    //   decoration: InputDecoration(labelText: "Dosage"),
                    // ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: selectedDosage,
                      onChanged: (value) {
                        onMedReminderSelected(value);
                      },
                      items: const [
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text("Half Tablet"),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text("One Tablet"),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text("Two Tablet"),
                        ),
                        DropdownMenuItem<int>(
                          value: 4,
                          child: Text("More Than Two Tablets"),
                        ),
                      ],
                      decoration: InputDecoration(labelText: "Dosage"),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
