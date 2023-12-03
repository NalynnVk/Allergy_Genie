import 'package:allergygenieapi/bloc/tracking_bloc.dart';
import 'package:allergygenieapi/bloc/user_bloc.dart';
import 'package:allergygenieapi/constant.dart';
import 'package:allergygenieapi/helpers/http_response.dart';
import 'package:allergygenieapi/log_in.dart';
import 'package:allergygenieapi/models/tracking/list_tracking_response_model.dart';
import 'package:allergygenieapi/models/tracking/tracking_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/allergic_event.dart';
import 'package:allergygenieapi/pages/care_plan_page.dart';
import 'package:allergygenieapi/pages/emergency_contact_page.dart';
import 'package:allergygenieapi/pages/insight_page.dart';
import 'package:allergygenieapi/pages/med_reminder_page.dart';
import 'package:allergygenieapi/pages/profile_page.dart';
import 'package:allergygenieapi/pages/report_page.dart';
import 'package:allergygenieapi/public_components/empty_list.dart';
import 'package:allergygenieapi/public_components/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  // DateTime today = DateTime.now();
  DateTime? _selectedDay;
  // store the events created
  Map<DateTime, List<Event>> events = {};
  // TextEditingController _eventController = TextEditingController();

  // TextEditingController _severityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // String? _selectedSymptomCategory; // Added for symptom category
  // String? _selectedFoodMedication;

  late final ValueNotifier<List<Event>> _selectedEvents;
  // int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    _trackingPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, _selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime? day) {
    return events[day ?? DateTime(2000)] ?? [];
  }

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

  // @override
  // void initState() {
  //   super.initState();
  //   _trackingPagingController.addPageRequestListener((pageKey) {
  //     _fetchPage(pageKey);
  //   });
  // }

  int delayAnimationDuration = 100;
  int _currentIndex = 0;

  // final List<Widget> _pages = [
  //   HomePageContent(), // Placeholder for your home page content
  //   MedReminderPage(),
  //   ReportPage(),
  //   InsightPage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 35.0,
        title: const Padding(
          padding:
              EdgeInsets.symmetric(), // Adjust the horizontal padding as needed
          child: Text('Allergy Genie'),
        ),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              child: IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  size: 30,
                ), // Set the size of the icon
                onPressed: () {
                  // Navigate to admin profile settings page
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ));
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigate to ProfilePage when the username is tapped
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ));
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Display User Profile Picture
                    // CircleAvatar(
                    //   backgroundImage:
                    //       NetworkImage(widget.user.profilePicture ?? ''),
                    //   radius: 30,
                    // ),
                    SizedBox(height: 10),
                    // Display User Name
                    Text(
                      'Davikah Sharma',
                      // widget.user.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.perm_contact_cal_rounded),
              title: const Text(
                'Contacts',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  //pushReplacement - buang given existing back button
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginPage();
                    },
                  ),
                );
              },
              leading: const Icon(Icons.logout),
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 325.0),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 27.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const CarePlanPage();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.share),
                title: const Text(
                  "Share Care Plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 27.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const EmergencyContactPage();
                      },
                    ),
                  );
                },
                leading: const Icon(Iconsax.alarm5),
                title: const Text(
                  "Emergency Contact",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text("Event Name"),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _descriptionController,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // store the event name into the map
                      events.addAll({
                        _selectedDay!: [
                          Event(_descriptionController.text)
                        ] //allergic_event.dart
                      });
                      Navigator.of(context).pop();
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
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

          // Navigation logic based on index
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomePage(user: widget.user);
                  },
                ),
              );
              break;
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MedReminderPage(user: widget.user);
                  },
                ),
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ReportPage(user: widget.user);
                  },
                ),
              );
              break;
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return InsightPage(user: widget.user);
                  },
                ),
              );
              break;
          }
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
    );
  }

  // CALENDAR
  Widget calendar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 24),
            ),
            firstDay: DateTime.utc(2000, 01, 01),
            lastDay: DateTime.utc(2060, 01, 01),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
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
              setState(
                () {
                  _focusedDay = focusedDay;
                },
              );
            },
          ),
          const SizedBox(height: 8.0),
          // Expanded(
          //   child: ValueListenableBuilder<List<Event>>(
          //     valueListenable: _selectedEvents,
          //     builder: (context, value, _) {
          //       return ListView.builder(
          //         itemCount: value.length,
          //         itemBuilder: (context, index) {
          //           return Container(
          //             margin:
          //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          //             decoration: BoxDecoration(
          //               border: Border.all(),
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             child: ListTile(
          //               onTap: () => print(""),
          //               title: Text('${value[index]}'),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
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

