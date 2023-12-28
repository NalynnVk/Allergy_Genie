import 'package:allergygenieapi/models/tracking/tracking_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_update_request_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:allergygenieapi/bloc/allergen_bloc.dart';
import 'package:allergygenieapi/bloc/symptom_bloc.dart';
import 'package:allergygenieapi/bloc/tracking_bloc.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/allergen/allergen_model.dart';
import 'package:allergygenieapi/models/allergen/list_allergen_response_model.dart';
import 'package:allergygenieapi/models/symptom/list_symptom_response_model.dart';
import 'package:allergygenieapi/models/symptom/symptom_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_response_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/screens/basic/homepage_screen.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';

class UpdateTrackingScreen extends StatefulWidget {
  final User user;
  final Tracking tracking;
  const UpdateTrackingScreen({
    Key? key,
    required this.user,
    required this.tracking,
  }) : super(key: key);

  @override
  State<UpdateTrackingScreen> createState() => _UpdateTrackingScreenState();
}

class _UpdateTrackingScreenState extends State<UpdateTrackingScreen> {
  UpdateTrackingRequestModel trackingRequestModel =
      UpdateTrackingRequestModel();
  AllergenBloc allergenBloc = AllergenBloc();
  SymptomBloc symptomBloc = SymptomBloc();

  static const _pageSize = 10;
  final PagingController<int, Allergen> _allergenPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, Symptom> _symptomPagingController =
      PagingController(firstPageKey: 1);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<List<Allergen>> _allergenListFuture;
  late Future<List<Symptom>> _symptomListFuture;

  int? _selectedSymptomId;
  int? _selectedAllergenId;
  int? _selectedSeverity;
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize values for dropdowns
    _selectedSymptomId = widget.tracking.symptom!.id;
    _selectedAllergenId = widget.tracking.allergen!.id;
    _selectedSeverity = widget.tracking.severityId;

    // Set initial values in the request model
    trackingRequestModel.symptom_id = _selectedSymptomId;
    trackingRequestModel.allergen_id = _selectedAllergenId;
    trackingRequestModel.severity = _selectedSeverity;
    trackingRequestModel.notes = widget.tracking.notes;

    // Initialize allergen & symptom list future and paging controller
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Tracking'),
      ),
      drawer: AppDrawer(user: widget.user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<List<Symptom>>(
              future: _symptomListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No symptom available.'));
                } else {
                  final symptoms = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    isDense: false,
                    isExpanded: true,
                    hint: Text('Select a Symptom'),
                    value: _selectedSymptomId,
                    onChanged: (value) {
                      setState(() {
                        _selectedSymptomId = value;
                        trackingRequestModel.symptom_id = _selectedSymptomId;
                      });
                    },
                    items: symptoms.map((symptom) {
                      return DropdownMenuItem<int>(
                        value: symptom.id,
                        child: Text(symptom.name ?? "null"),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            FutureBuilder<List<Allergen>>(
              future: _allergenListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No allergen available.'));
                } else {
                  final allergens = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    isDense: false,
                    isExpanded: true,
                    hint: Text('Select an Allergen'),
                    value: _selectedAllergenId,
                    onChanged: (value) {
                      setState(() {
                        _selectedAllergenId = value;
                        trackingRequestModel.allergen_id = _selectedAllergenId;
                      });
                    },
                    items: allergens.map((allergen) {
                      return DropdownMenuItem<int>(
                        value: allergen.id,
                        child: Text(allergen.name ?? "null"),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedSeverity,
              onChanged: (value) {
                _selectedSeverity = value;
                trackingRequestModel.severity = _selectedSeverity;
              },
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text("Mild"),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text("Severe"),
                ),
              ],
              decoration: InputDecoration(labelText: "Severity"),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Notes'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notes';
                }
              },
              onEditingComplete: () {
                setState(() {
                  trackingRequestModel.notes = _descriptionController.text;
                });
              },
              onChanged: (value) {
                setState(() {
                  trackingRequestModel.notes = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                TrackingBloc trackingBloc = TrackingBloc();
                TrackingResponseModel trackingResponseModel = await trackingBloc
                    .updateTracking(trackingRequestModel, widget.tracking.id!);

                if (trackingResponseModel.isSuccess) {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(user: widget.user)),
                    );
                  }

                  print(trackingResponseModel);
                } else {
                  print(trackingResponseModel.message);
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
