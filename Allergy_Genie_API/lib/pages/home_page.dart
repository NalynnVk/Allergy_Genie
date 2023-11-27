import 'package:allergygenieapi/bloc/tracking_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
import 'package:allergygenieapi/public_components/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user})
      : super(key: key); // IMPORTANT!!
  // const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // CALENDAR START
  DateTime today = DateTime.now();
  // DateTime? _selectedDay;
  // DateTime _focusedDay = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(
      () {
        today = day;
      },
    );
  }

  // CALENDAR END

  int _currentIndex = 0;
  TrackingBloc trackingBloc = TrackingBloc();
  late Future<User?> _user;
  UserBloc userBloc = UserBloc();
  static const _pageSize = 10;
  final PagingController<int, Tracking> _trackingPagingController =
      PagingController(firstPageKey: 1);

  // For refresher
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // add calendar

  void _onRefresh() async {
    // monitor network fetch

    _trackingPagingController.refresh();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    //Call API
    final ListTrackingResponseModel response =
        await trackingBloc.getListTracking();

    // If success
    if (response.statusCode == HttpResponse.HTTP_OK) {
      List<Tracking> trackingModel = response.data!;

      // Compare the lenght with the page size to know either already last page or not
      final isLastPage = trackingModel.length < _pageSize;
      if (isLastPage) {
        _trackingPagingController.appendLastPage(trackingModel);
      } else {
        final nextPageKey = pageKey + trackingModel.length;
        _trackingPagingController.appendPage(trackingModel, nextPageKey);
      }

      print(trackingModel);
    } else {
      _trackingPagingController.error = response.message;
      print(response.message);
    }
    // } catch (error) {
    //   _vegetablePagingController.error = "Server Error";
    // }
  }

  void callbackRefresh() {
    _onRefresh();
  }

  @override
  void initState() {
    super.initState();
    _trackingPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  int delayAnimationDuration = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: const WaterDropMaterialHeader(
          backgroundColor: kPrimaryColor,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.difference_outlined),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insight',
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Display the dialog when the FAB is pressed
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AddTrackingDialog();
      //       },
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  // CALENDAR
  Widget calendar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            child: TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 24),
              ),
              // selectedDayPredicate: (day) => isSameDay(day, today),
              // focusedDay: today,
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2060, 01, 01),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue, // blue
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue, // blue
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // CARD LIST
  Widget trackingList({required BuildContext context, required tracking}) =>
      Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card Widgets
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 8),
                                  // Text('Symptom category: Skin-related Symptoms'),
                                  // Text('Allergen type: Fish (eg: tuna)'),
                                  // Text('Severity number: 2'),
                                  // Text('Notes: Rashes around the arm'),
                                  Text(
                                    'Symptom Category: ${tracking.symptom!.name}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Allergen Type: ${tracking.allergen!.name}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Severity Level: ${tracking.symptom!.severity}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Description: ${tracking.symptom!.description}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

// ADD TRACKING START

// class AddTrackingDialog extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _AddTrackingDialogState();
//   }
// }

// class _AddTrackingDialogState extends State<AddTrackingDialog> {
//   // Controller for text fields
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
//               decoration: InputDecoration(labelText: 'Symptom Category'),
//             ),
//             TextField(
//               controller: allergenTypeController,
//               decoration: InputDecoration(labelText: 'Allergen Type'),
//             ),
//             TextField(
//               controller: severityController,
//               decoration: InputDecoration(labelText: 'Symptom Severity'),
//             ),
//             TextField(
//               controller: descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
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
//         TextButton(
//           onPressed: () {
//             // Save logic here
//             // Access the text field values using the controllers
//             String symptomCategory = symptomCategoryController.text;
//             String allergenType = allergenTypeController.text;
//             String severity = severityController.text;
//             String description = descriptionController.text;

//             // Add your logic to save the data
//             // You may want to call a function in your _HomePageState
//             // to handle the saving of the data
//             // Example: widget.saveTracking(symptomCategory, allergenType, severity, description);

//             // Close the dialog
//             Navigator.of(context).pop();
//           },
//           child: Text('Save'),
//         ),
//       ],
//     );
//   }
// }

// ADD TRACKING END

//   Widget buildBody(
//     required BuildContext context,
//   required Tracking tracking,

//   ) async => const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Card Widgets
//           Card(
//             margin: EdgeInsets.all(8),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                       tracking.name!,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                 ],
//               ),
//             ),
//           ),
//           // TrackingTile Widget
//           // SizedBox(height: 16),
//           // TrackingTile(
//           //   symptomCategory: 'Skin-related Symptoms',
//           //   allergenType: 'Fish (e.g., tuna)',
//           //   severityNumber: 2,
//           //   additionalNotes: 'Rashes around the arm',
//           // ),
//           // SizedBox(height: 10),
//           // TrackingTile(
//           //   symptomCategory: 'Skin-related Symptoms',
//           //   allergenType: 'Eggs (e.g., chicken eggs)',
//           //   severityNumber: 5,
//           //   additionalNotes: 'Rashes around the arm',
//           // ),
//         ],
//       ),
//     );
// }

// TrackingTile Widget
// class TrackingTile extends StatelessWidget {
//   final String symptomCategory;
//   final String allergenType;
//   final int severityNumber;
//   final String additionalNotes;

//   const TrackingTile({
//     required this.symptomCategory,
//     required this.allergenType,
//     required this.severityNumber,
//     required this.additionalNotes,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text('Symptom Category: $symptomCategory'),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Allergen Type: $allergenType'),
//           Text('Severity Number: $severityNumber'),
//           Text('Additional Notes: $additionalNotes'),
//         ],
//       ),
//       tileColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     );
//   }
// }
