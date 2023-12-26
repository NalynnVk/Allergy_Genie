import 'package:allergygenieapi/bloc/allergen_bloc.dart';
import 'package:allergygenieapi/bloc/allergic_bloc.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/allergen/allergen_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_request_model.dart';
import 'package:allergygenieapi/models/allergen/list_allergen_response_model.dart';
import 'package:allergygenieapi/models/patient/allergic_model.dart';
import 'package:allergygenieapi/models/patient/allergic_request_model.dart';
import 'package:allergygenieapi/models/patient/allergic_response_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/screens/default/navigation.dart';
import 'package:allergygenieapi/screens/user/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StoreAllergicScreen extends StatefulWidget {
  final User user;
  const StoreAllergicScreen({super.key, required this.user});

  @override
  State<StoreAllergicScreen> createState() => _StoreAllergicScreenState();
}

class _StoreAllergicScreenState extends State<StoreAllergicScreen> {
  AllergicRequestModel allergicRequestModel = AllergicRequestModel();

  AllergenBloc allergenBloc = AllergenBloc();

  static const _pageSize = 10;
  final PagingController<int, Allergen> _allergenPagingController =
      PagingController(firstPageKey: 1);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<List<Allergen>> _allergenListFuture;

  int? _selectedAllergenId;
  int? _selectedSeverity;

  @override
  void initState() {
    super.initState();
    _allergenListFuture = _fetchAllergenList();

    _allergenPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
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

  void _onRefresh() async {
    _allergenPagingController.refresh();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(user: widget.user),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Allergen>>(
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
                  return Column(
                    children: [
                      Container(
                        width: 300.0,
                        child: DropdownButtonFormField<int>(
                          isDense: false,
                          isExpanded: true,
                          hint: Text('Select an Allergen'),
                          value: _selectedAllergenId,
                          onChanged: (value) {
                            setState(() {
                              _selectedAllergenId = value;
                              allergicRequestModel.allergen_id =
                                  _selectedAllergenId;
                            });
                          },
                          items: allergens.map((allergen) {
                            return DropdownMenuItem<int>(
                              value: allergen.id,
                              child: SizedBox(
                                width: 300.0,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<int>(
              value: _selectedSeverity,
              onChanged: (value) {
                _selectedSeverity = value;
                allergicRequestModel.severity = _selectedSeverity;
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
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              AllergicBloc allergicBloc = AllergicBloc();
              AllergicResponseModel allergicResponseModel =
                  await allergicBloc.createAllergic(allergicRequestModel);

              if (allergicResponseModel.isSuccess) {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: widget.user)),
                  );
                }

                print(allergicResponseModel);
              } else {
                print(allergicResponseModel.message);
              }
            },
            child: Text('Add Tracking'),
          ),
        ],
      ),
    );
  }
}
