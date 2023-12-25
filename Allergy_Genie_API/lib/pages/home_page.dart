import 'package:allergygenieapi/bloc/tracking_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/add_tracking_page.dart';
import 'package:allergygenieapi/pages/widgets/base_page.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/tracking'; // dian line 13
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>(); // dian line 21
  TrackingRequestModel trackingRequestModel =
      TrackingRequestModel(); // dian line 22
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  int _currentIndex = 0;
  TrackingBloc trackingBloc = TrackingBloc();
  late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  static const _pageSize = 10;
  final PagingController<int, Tracking> _trackingPagingController =
      PagingController(firstPageKey: 1);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _trackingPagingController.refresh();
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    final ListTrackingResponseModel response =
        await trackingBloc.getListTracking();

    if (response.statusCode == HttpResponse.HTTP_OK) {
      List<Tracking> trackingModel = response.data!;

      final isLastPage = trackingModel.length < _pageSize;
      if (isLastPage) {
        _trackingPagingController.appendLastPage(trackingModel);
      } else {
        final nextPageKey = pageKey + trackingModel.length;
        _trackingPagingController.appendPage(trackingModel, nextPageKey);
      }
    } else {
      _trackingPagingController.error = response.message;
    }
  }

  void callbackRefresh() {
    _onRefresh();
  }

  bool _isLoading = false; // dian line 84
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // dian line 85

  @override
  void initState() {
    super.initState();
    _trackingPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      body: BasePage(
        user: widget.user,
        body: SmartRefresher(
          controller: _refreshController,
          header: const WaterDropMaterialHeader(
            backgroundColor: Colors.grey,
          ),
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: calendar(),
              ),
              PagedSliverList<int, Tracking>(
                pagingController: _trackingPagingController,
                builderDelegate: PagedChildBuilderDelegate<Tracking>(
                  firstPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return ThemeSpinner.spinner();
                  },
                  noItemsFoundIndicatorBuilder: (context) => const EmptyList(
                    icon: Icons.menu_book,
                    title: "No Allergy Tracking Details",
                    query: '',
                  ),
                  animateTransitions: true,
                  itemBuilder: (context, tracking, index) {
                    return trackingList(
                      context: context,
                      tracking: tracking,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 65.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTrackingPage(user: user),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget calendar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
            child: TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 24),
              ),
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2060, 01, 01),
              onDaySelected: _onDaySelected,
            ),
          ),
        ],
      ),
    );
  }

  Widget trackingList(
          {required BuildContext context, required Tracking tracking}) =>
      GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tracking.symptom!.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Allergen Type: ${tracking.allergen!.name}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                // Text(
                //   // 'Severity Level: ${tracking.symptom!.severity}',
                //   style: const TextStyle(
                //     color: Colors.blue,
                //     fontSize: 15,
                //   ),
                // ),
                const SizedBox(height: 5),
                Text(
                  'Description: ${tracking.symptom!.description}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

// class AddTrackingDialog extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _AddTrackingDialogState();
//   }
// }

// class _AddTrackingDialogState extends State<AddTrackingDialog> {
//   TextEditingController symptomCategoryController = TextEditingController();
//   TextEditingController allergenTypeController = TextEditingController();
//   TextEditingController severityController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add Tracking'),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               controller: symptomCategoryController,
//               decoration: const InputDecoration(labelText: 'Symptom Category'),
//             ),
//             TextField(
//               controller: allergenTypeController,
//               decoration: const InputDecoration(labelText: 'Allergen Type'),
//             ),
//             TextField(
//               controller: severityController,
//               decoration: const InputDecoration(labelText: 'Symptom Severity'),
//             ),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Cancel'),
//         ),
//         // TextButton(
//         //   onPressed: () async {
//         //     String symptomCategory = symptomCategoryController.text;
//         //     String allergenType = allergenTypeController.text;
//         //     String severity = severityController.text;
//         //     String description = descriptionController.text;

//         //     // Add your logic to save the data
//         //     // ...

//         //     Navigator.of(context).pop();

//         //     TrackingBloc trackingBloc = TrackingBloc(); // dian line 380
//         //     TrackingResponseModel trackingResponseModel =
//         //         await trackingBloc.createTracking(TrackingRequestModel());

//         //     if (trackingResponseModel.isSuccess) {
//         //       if (mounted) {
//         //         navigateTo(
//         //             context,
//         //             HomePage(
//         //               tracking: trackingResponseModel.data!,
//         //             ));
//         //       }

//         //       print(trackingResponseModel);
//         //     } else {
//         //       print(trackingResponseModel.message);
//         //     }
//         //   },
//         //   child: Text('Save'),
//         // ),
//       ],
//     );
//   }
// }

class ThemeSpinner {
  static Widget spinner() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    );
  }
}
