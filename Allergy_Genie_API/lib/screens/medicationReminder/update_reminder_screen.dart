import 'package:flutter/material.dart';
import 'package:allergygenieapi/bloc/med_reminder_bloc.dart';
import 'package:allergygenieapi/bloc/medication_bloc.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_request_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_response_model.dart';
import 'package:allergygenieapi/models/med_reminder/med_reminder_update_request_model.dart';
import 'package:allergygenieapi/models/medication/list_medication_response_model.dart';
import 'package:allergygenieapi/models/medication/medication_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';
import 'package:allergygenieapi/screens/medicationReminder/list_reminder_screen.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UpdateReminderScreen extends StatefulWidget {
  final User user;
  final MedReminder medReminder;
  const UpdateReminderScreen({
    Key? key,
    required this.user,
    required this.medReminder,
  }) : super(key: key);

  @override
  State<UpdateReminderScreen> createState() => _UpdateReminderScreenState();
}

class _UpdateReminderScreenState extends State<UpdateReminderScreen> {
  UpdateMedReminderRequestModel medReminderRequestModel =
      UpdateMedReminderRequestModel();
  MedicationBloc medicationBloc = MedicationBloc();

  static const _pageSize = 10;
  final PagingController<int, Medication> _medicationPagingController =
      PagingController(firstPageKey: 1);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<List<Medication>> _medicationListFuture;

  int? _selectedMedicationId;
  int? _selectedDosage;
  int? _selectedRepitition;
  final timeReminderController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    // Initialize values for dropdowns
    _selectedMedicationId = widget.medReminder.medication!.id;
    _selectedDosage = widget.medReminder.dosageId;
    _selectedRepitition = widget.medReminder.repititonId;
    List<String> timeParts = widget.medReminder.time_reminder!.split(':');
    _selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));

    // Set initial values in the request model
    medReminderRequestModel.medication_id = _selectedMedicationId;
    medReminderRequestModel.dosage = _selectedDosage;
    medReminderRequestModel.repititon = _selectedRepitition;
    medReminderRequestModel.time_reminder = _selectedTime;

    // Initialize medication list future and paging controller
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(user: widget.user),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Medication>>(
              future: _medicationListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No allergen available.'));
                } else {
                  final medications = snapshot.data!;
                  return Column(
                    children: [
                      Container(
                        width: 300.0,
                        child: DropdownButtonFormField<int>(
                          isDense: false,
                          isExpanded: true,
                          hint: Text('Select an Allergen'),
                          value: _selectedMedicationId,
                          onChanged: (value) {
                            setState(() {
                              _selectedMedicationId = value;
                              medReminderRequestModel.medication_id =
                                  _selectedMedicationId;
                            });
                          },
                          items: medications.map((medication) {
                            return DropdownMenuItem<int>(
                              value: medication.id,
                              child: SizedBox(
                                width: 300.0,
                                child: Center(
                                  child: Text(medication.name ?? "null"),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<int>(
              value: _selectedDosage,
              onChanged: (value) {
                _selectedDosage = value;
                medReminderRequestModel.dosage = _selectedDosage;
              },
              items: [
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<int>(
              value: _selectedRepitition,
              onChanged: (value) {
                _selectedRepitition = value;
                medReminderRequestModel.repititon = _selectedRepitition;
              },
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text("Once"),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text("Daily"),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text("Weekly"),
                ),
              ],
              decoration: InputDecoration(labelText: "Repitition"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: timeReminderController,
              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() {
                    _selectedTime = selectedTime;
                    timeReminderController.text =
                        '${selectedTime.hour}:${selectedTime.minute}';
                    medReminderRequestModel.time_reminder = _selectedTime;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Select Reminder Time',
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              MedReminderBloc medReminderBloc = MedReminderBloc();
              MedReminderResponseModel medReminderResponseModel =
                  await medReminderBloc.updateMedReminder(
                      medReminderRequestModel, widget.medReminder.id!);

              if (medReminderResponseModel.isSuccess) {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ListReminderScreen(user: widget.user)),
                  );
                }

                print(medReminderResponseModel);
              } else {
                print(medReminderResponseModel.message);
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
