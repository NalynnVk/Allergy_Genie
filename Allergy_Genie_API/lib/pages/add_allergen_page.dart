import 'package:allergygenieapi/bloc/allergen_bloc.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/allergen/allergen_request_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_response_model.dart';
import 'package:allergygenieapi/models/allergen/list_allergen_response_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_model.dart';
import 'package:allergygenieapi/models/allergen/allergen_request_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddAllergenPage extends StatefulWidget {
  final User user;
  const AddAllergenPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddAllergenPage> createState() => _AddAllergenPageState();
}

class _AddAllergenPageState extends State<AddAllergenPage> {
  AllergenRequestModel allergenRequestModel = AllergenRequestModel();

  TextEditingController allergenController = TextEditingController();

  AllergenBloc allergenBloc = AllergenBloc();
  static const _pageSize = 10;
  final PagingController<int, Allergen> _allergenPagingController =
      PagingController(firstPageKey: 1);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<List<Allergen>> _allergenListFuture;
  int? _selectedAllergenId;

  @override
  void initState() {
    super.initState();
    _allergenListFuture = _fetchCourseList();
    _allergenPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<List<Allergen>> _fetchCourseList() async {
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

  int delayAnimationDuration = 100;

  // Inside the _AddAllergenPageState class

  late List<Allergen> _allergenList = [];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder<List<Allergen>>(
  //       future: _allergenListFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           // Loading state
  //           return CircularProgressIndicator();
  //         } else if (snapshot.hasError) {
  //           // Error state
  //           return Text('Error: ${snapshot.error}');
  //         } else {
  //           // Data loaded successfully
  //           _allergenList = snapshot.data!;

  //           return Column(
  //             children: [
  //               // Add your other widgets here
  //               DropdownButton<Allergen>(
  //                 value: _selectedAllergenId != null
  //                     ? _allergenList.firstWhere((allergen) =>
  //                         allergen.id == _selectedAllergenId)
  //                     : null,
  //                 onChanged: (Allergen? selectedAllergen) {
  //                   setState(() {
  //                     _selectedAllergenId = selectedAllergen?.id;
  //                   });
  //                 },
  //                 items: _allergenList.map((Allergen allergen) {
  //                   return DropdownMenuItem<Allergen>(
  //                     value: allergen,
  //                     child: Text(allergen.name ?? 'null'),
  //                   );
  //                 }).toList(),
  //                 hint: Text('Select Allergen'),
  //               ),
  //               // Add your other widgets here
  //             ],
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Allergen",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Allergen>>(
          future: _allergenListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              _allergenList = snapshot.data!;

              return ListView(
                children: [
                  const SizedBox(height: 10),
                  _buildDropdown(),
                  // TextFormField(
                  //   controller: allergenController,
                  //   decoration: const InputDecoration(
                  //     labelText: "Allergen Type",
                  //     // hintText: "ex: tomato",
                  //     prefixIcon: Icon(Icons.local_florist),
                  //   ),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       allergenRequestModel.name = value;
                  //     });
                  //   },
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  _addButton(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DropdownButtonFormField<Allergen>(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: InputBorder.none,
              hintText: 'Select Allergen',
            ),
            value: _selectedAllergenId != null
                ? _allergenList.firstWhere(
                    (allergen) => allergen.id == _selectedAllergenId)
                : null,
            onChanged: (Allergen? selectedAllergen) {
              setState(() {
                _selectedAllergenId = selectedAllergen?.id;

                // Update allergenRequestModel.name with the selected allergen name
                if (_selectedAllergenId != null) {
                  allergenRequestModel.name = selectedAllergen?.name ?? '';
                }
              });
            },
            items: _allergenList.map((Allergen allergen) {
              return DropdownMenuItem<Allergen>(
                value: allergen,
                child: Text(allergen.name ?? 'null'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _addButton() {
    final User user = widget.user;
    final BuildContext currentContext = context;

    return ElevatedButton(
      onPressed: () async {
        AllergenBloc allergenBloc = AllergenBloc();
        AllergenResponseModel responseModel =
            await allergenBloc.createAllergen(AllergenRequestModel());

        if (responseModel.isSuccess) {
          // Show a success SnackBar
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Allergen added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Delay the navigation to give time for the user to see the SnackBar
          await Future.delayed(const Duration(seconds: 2));

          // Navigate back to the home page
          Navigator.pop(currentContext);
        } else {
          // Show an error SnackBar
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(
              content: Text('Failed to add tracking: ${responseModel.message}'),
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
    );
  }
}
