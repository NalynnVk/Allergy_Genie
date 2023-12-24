import 'package:allergygenieapi/bloc/allergen_bloc.dart';
import 'package:allergygenieapi/bloc/symptom_bloc.dart';
import 'package:allergygenieapi/bloc/tracking_bloc.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/allergen/allergen_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_request_model.dart';
import 'package:allergygenieapi/models/allergen/list_allergen_response_model.dart';
import 'package:allergygenieapi/models/symptom/list_symptom_response_model.dart';
import 'package:allergygenieapi/models/symptom/symptom_model.dart';
import 'package:allergygenieapi/models/symptom/symptom_request_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_response_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddTrackingPage extends StatefulWidget {
  final User user;

  const AddTrackingPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddTrackingPage> createState() => _AddTrackingPageState();
}

class _AddTrackingPageState extends State<AddTrackingPage> {
  SymptomRequestModel symptomRequestModel = SymptomRequestModel();
  AllergenRequestModel allergenRequestModel = AllergenRequestModel();

  int? _selectedAllergenId;
  int? _selectedSymptomId;
  int selectedSeverity = 1;
  TextEditingController descriptionController = TextEditingController();

  late final List<Symptom> symptoms;
  List<Symptom> _selectedSymptoms = [];
  late final Function(List<int>?) onSymptomsSelected;

  SymptomBloc symptomBloc = SymptomBloc();
  AllergenBloc allergenBloc = AllergenBloc();

  static const _pageSize = 10;
  final PagingController<int, Allergen> _allergenPagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, Symptom> _symptomPagingController =
      PagingController(firstPageKey: 1);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<List<Allergen>> _allergenListFuture;
  late Future<List<Symptom>> _symptomListFuture;

  @override
  void initState() {
    super.initState();
    _allergenListFuture = _fetchAllergenList();
    _symptomListFuture = _fetchSymptomList();

    _allergenPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _symptomPagingController.addPageRequestListener((pageKey) {
      _fetchSymptomPage(pageKey);
    });
  }

  Future<List<Allergen>> _fetchAllergenList() async {
    try {
      final ListAllergenResponseModel response =
          await allergenBloc.getListAllergen();

      if (response.statusCode == HttpResponse.HTTP_OK) {
        return response.data ?? [];
      } else {
        throw Exception(response.message);
      }
    } catch (error) {
      throw Exception("Server Error");
    }
  }

  Future<List<Symptom>> _fetchSymptomList() async {
    try {
      final ListSymptomResponseModel response =
          await symptomBloc.getListSymptom();

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
    _allergenPagingController.refresh();
    _symptomPagingController.refresh();

    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final ListAllergenResponseModel response =
          await allergenBloc.getListAllergen();

      if (response.statusCode == HttpResponse.HTTP_OK) {
        List<Allergen> allergenModel = response.data!;

        final isLastPage = allergenModel.length < _pageSize;
        if (isLastPage) {
          _allergenPagingController.appendLastPage(allergenModel);
        } else {
          final nextPageKey = pageKey + allergenModel.length;
          _allergenPagingController.appendPage(allergenModel, nextPageKey);
        }

        print(allergenModel);
      } else {
        _allergenPagingController.error = response.message;
        print(response.message);
      }
    } catch (error) {
      _allergenPagingController.error = "Server Error";
    }
  }

  Future<void> _fetchSymptomPage(int pageKey) async {
    try {
      final ListSymptomResponseModel response =
          await symptomBloc.getListSymptom();

      if (response.statusCode == HttpResponse.HTTP_OK) {
        List<Symptom> symptomModel = response.data!;

        final isLastPage = symptomModel.length < _pageSize;
        if (isLastPage) {
          _symptomPagingController.appendLastPage(symptomModel);
        } else {
          final nextPageKey = pageKey + symptomModel.length;
          _symptomPagingController.appendPage(symptomModel, nextPageKey);
        }

        print(symptomModel);
      } else {
        _symptomPagingController.error = response.message;
        print(response.message);
      }
    } catch (error) {
      _symptomPagingController.error = "Server Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Tracking",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: AlertDialog(
          surfaceTintColor: Colors.white,
          title: Text("Add Tracking Form"),
          content: TrackingDialogContent(
            selectedSymptomId: _selectedSymptomId,
            selectedAllergenId: _selectedAllergenId,
            symptomListFuture: _symptomListFuture,
            allergenListFuture: _allergenListFuture,
            selectedSeverity: selectedSeverity,
            selectedDescription: descriptionController.text,
            onAllergenSelected: (int? newValue) {
              setState(() {
                _selectedAllergenId = newValue;
              });
            },
            onSymptomSelected: (int? newValue) {
              setState(() {
                _selectedSymptomId = newValue;
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
            // Add your logic for handling form submission here
            // TextButton(
            //   onPressed: () {
            //     // Get the entered values from the controllers
            //     String description = descriptionController.text;

            //     Navigator.of(context).pop(); // Close the dialog
            //     navigateTo(
            //       context,
            //       HomePage(
            //         user: widget.user,
            //         symptom_id: _selectedSymptomId,
            //         allergen_id: _selectedAllergenId,
            //         severity: selectedSeverity,
            //         description: selectedDescription,
            //       ),
            //     );
            //   },
            //   child: Text("Submit"),
            // ),
            TextButton(
              onPressed: () async {
                try {
                  // Get the entered values from the controllers
                  String description = descriptionController.text;

                  // Check if required fields are not empty
                  if (_selectedSymptomId == null ||
                      _selectedAllergenId == null) {
                    // Show an error message or handle the case where required fields are not selected
                    return;
                  }

                  // Create your TrackingRequestModel
                  TrackingRequestModel requestModel = TrackingRequestModel(
                    symptom_id: _selectedSymptomId,
                    allergen_id: _selectedAllergenId,
                  );

                  // Call your API method to add tracking data
                  TrackingResponseModel response =
                      await TrackingBloc().createTracking(requestModel);

                  // Check the API response
                  if (response.statusCode == HttpResponse.HTTP_CREATED) {
                    // Successfully added the record
                    print("Record added successfully!");
                  } else {
                    // Handle the case where the API request failed
                    print("Failed to add record. Error: ${response.message}");
                  }

                  // Close the dialog
                  Navigator.of(context).pop();
                } catch (error) {
                  // Handle any unexpected errors
                  print("An error occurred: $error");
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingDialogContent extends StatefulWidget {
  const TrackingDialogContent({
    Key? key,
    required this.selectedSymptomId,
    required this.selectedAllergenId,
    required this.selectedSeverity,
    required this.selectedDescription,
    required this.symptomListFuture,
    required this.allergenListFuture,
    required this.onSymptomSelected,
    required this.onAllergenSelected,
  }) : super(key: key);

  final int? selectedSymptomId;
  final int? selectedAllergenId;
  final int selectedSeverity;
  final String selectedDescription;

  final Future<List<Allergen>> allergenListFuture;
  final Future<List<Symptom>> symptomListFuture;

  final Function(int?) onAllergenSelected;
  final Function(int?) onSymptomSelected;

  @override
  State<TrackingDialogContent> createState() => _TrackingDialogContentState();
}

class _TrackingDialogContentState extends State<TrackingDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<List<Symptom>>(
          future: widget.symptomListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No symptoms available.'));
            } else {
              final symptoms = snapshot.data!;
              return Column(
                children: [
                  Container(
                    width: 300.0,
                    height: 100.0,
                    child: DropdownButtonFormField<int>(
                      isDense: false,
                      isExpanded: true,
                      hint: const Text('Select a symptom'),
                      value: widget.selectedSymptomId,
                      onChanged: widget.onSymptomSelected,
                      items: symptoms.map((symptom) {
                        return DropdownMenuItem<int>(
                          value: symptom.id,
                          child: SizedBox(
                            width: 300.0,
                            height: 70.0,
                            child: Center(
                              child: Text(symptom.name ?? "null"),
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
        // const SizedBox(height: 10),
        FutureBuilder<List<Allergen>>(
          future: widget.allergenListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No allergens available.'));
            } else {
              final allergens = snapshot.data!;
              return Column(
                children: [
                  Container(
                    width: 300.0,
                    height: 100.0,
                    child: DropdownButtonFormField<int>(
                      isDense: false,
                      isExpanded: true,
                      hint: const Text('Select an allergen'),
                      value: widget.selectedAllergenId,
                      onChanged: widget.onAllergenSelected,
                      items: allergens.map((allergen) {
                        return DropdownMenuItem<int>(
                          value: allergen.id,
                          child: SizedBox(
                            width: 300.0,
                            height: 70.0,
                            child: Center(
                              child: Text(allergen.name ?? "null"),
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
        DropdownButtonFormField<int>(
          value: widget.selectedSeverity,
          onChanged: (value) {
            widget.onSymptomSelected(value);
          },
          items: const [
            DropdownMenuItem<int>(
              value: 1,
              child: Text("Mild to Moderate"),
            ),
            DropdownMenuItem<int>(
              value: 2,
              child: Text("Severe"),
            ),
          ],
          decoration: const InputDecoration(labelText: "Severity"),
        ),
        TextField(
          controller: TextEditingController(text: widget.selectedDescription),
          decoration: InputDecoration(labelText: "Description"),
        ),
      ],
    );
  }
}
