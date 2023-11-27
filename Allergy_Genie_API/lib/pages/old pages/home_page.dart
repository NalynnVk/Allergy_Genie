import 'package:allergygenieapi/models/tracking/tracking_request_model.dart';
import 'package:allergygenieapi/pages/tracking/number_stepper.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:allergygenieapi/pages/old%20pages/log_symptom.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/homepage'; // dian line 13
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // 1. Consistent color scheme and typography
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 16.0),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
      ),
      home: const MyHomePage(title: 'Allergy Genie'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>(); // dian line 21
  TrackingRequestModel trackingRequestModel =
      TrackingRequestModel(); // dian line 22
  DateTime today = DateTime.now();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  late CalendarFormat _calendarFormat;

  Map<DateTime, List<Event>> events = {};
  // TextEditingController _symptomCategoryController = TextEditingController();
  TextEditingController _severityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String? _selectedSymptomCategory; // Added for symptom category
  String? _selectedFoodMedication;

  late final ValueNotifier<List<Event>> _selectedEvents;
  int _currentTabIndex = 0;

  bool _isLoading = false; // dian line 84
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // dian line 85

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _calendarFormat = CalendarFormat.month; // Initialize _calendarFormat here
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
  }

  List<Event> _getEventsForDay(DateTime? day) {
    return events[day ?? DateTime(2000)] ?? [];
  }

  Future<void> _openEventDetails(Event event) async {
    final updatedEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(event: event),
      ),
    );

    if (updatedEvent != null) {
      _updateEvent(updatedEvent);
    }
  }

  void _createEvent() {
    showDialog(
      context: context,
      builder: (context) {
        int _severity = 0; // Initial severity value
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          scrollable: true,
          title: const Center(
            child: Text(
              "Health Journal",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  // Symptom Category Dropdown
                  value: _selectedSymptomCategory,
                  items: const [
                    DropdownMenuItem(
                      value: 'Skin-related Symptoms',
                      child: Text('Skin-related Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Nasal Symptoms',
                      child: Text('Nasal Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Ocular Symptoms',
                      child: Text('Ocular Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Gastrointestinal Symptoms',
                      child: Text('Gastrointestinal Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Respiratory Symptoms',
                      child: Text('Respiratory Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Oral Symptoms',
                      child: Text('Oral Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Cardiovascular Symptoms',
                      child: Text('Cardiovascular Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Systemic Symptoms',
                      child: Text('Systemic Symptoms'),
                    ),
                    DropdownMenuItem(
                      value: 'Anaphylaxis Symptoms',
                      child: Text('Anaphylaxis Symptoms'),
                    ),
                    // Add all other symptom category options here
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSymptomCategory = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Symptom Category',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedFoodMedication,
                  items: const [
                    DropdownMenuItem(
                      value: 'Dairy products (eg: milk)',
                      child: Text('Dairy products (eg: milk)'),
                    ),
                    DropdownMenuItem(
                      value: 'Eggs (eg: chicken eggs)',
                      child: Text('Eggs (eg: chicken eggs)'),
                    ),
                    DropdownMenuItem(
                      value: 'Tree nuts (eg: almonds)',
                      child: Text('Tree nuts (eg: almonds)'),
                    ),
                    DropdownMenuItem(
                      value: 'Soybeans (eg: soy milk)',
                      child: Text('Soybeans (eg: soy milk)'),
                    ),
                    DropdownMenuItem(
                      value: 'Wheat (eg: bread)',
                      child: Text('Wheat (eg: bread)'),
                    ),
                    DropdownMenuItem(
                      value: 'Seeds (eg: sesame)',
                      child: Text('Seeds (eg: sesame)'),
                    ),
                    DropdownMenuItem(
                      value: 'Fish (eg: tuna)',
                      child: Text('Fish (eg: tuna)'),
                    ),
                    DropdownMenuItem(
                      value: 'Shellfish (eg: shrimp)',
                      child: Text('Shellfish (eg: shrimp)'),
                    ),
                    DropdownMenuItem(
                      value: 'Sulfites (e.g., dried fruits)',
                      child: Text('Sulfites (e.g., dried fruits)'),
                    ),
                    DropdownMenuItem(
                      value: 'Chickpeas (e.g., hummus)',
                      child: Text('Chickpeas (e.g., hummus)'),
                    ),
                    DropdownMenuItem(
                      value: 'Lentils (e.g., lentil soup)',
                      child: Text('Lentils (e.g., lentil soup)'),
                    ),
                    DropdownMenuItem(
                      value: 'Peas (e.g., green peas)',
                      child: Text('Peas (e.g., green peas)'),
                    ),
                    DropdownMenuItem(
                      value: 'Potatoes (e.g., mashed potato)',
                      child: Text('Potatoes (e.g., mashed potato)'),
                    ),
                    DropdownMenuItem(
                      value: 'Soy sauce (e.g., for seasoning)',
                      child: Text('Soy sauce (e.g., for seasoning)'),
                    ),
                    DropdownMenuItem(
                      value: 'Fish sauce (e.g., Asian dishes)',
                      child: Text(
                        'Fish sauce (e.g., Asian dishes)',
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Shellfish extract (e.g., broth)',
                      child: Text('Shellfish extract (e.g., broth)'),
                    ),
                    DropdownMenuItem(
                      value: 'MSG (Monosodium glutamate)',
                      child: Text('MSG (Monosodium glutamate)'),
                    ),
                    DropdownMenuItem(
                      value: 'Food dyes (e.g., Red 40)',
                      child: Text('Food dyes (e.g., Red 40)'),
                    ),
                    DropdownMenuItem(
                      value: 'Preservatives',
                      child: Text('Preservatives'),
                    ),
                    DropdownMenuItem(
                      value: 'Artificial sweeteners',
                      child: Text('Artificial sweeteners'),
                    ),
                    DropdownMenuItem(
                      value: 'Penicillins (eg: penicillin)',
                      child: Text('Penicillins (eg: penicillin)'),
                    ),
                    DropdownMenuItem(
                      value: 'Cephalosporin (eg: cefaclor)',
                      child: Text('Cephalosporin (eg: cefaclor)'),
                    ),
                    DropdownMenuItem(
                      value: 'Sulfonamides (eg: Mafenide)',
                      child: Text('Sulfonamides (eg: Mafenide)'),
                    ),
                    DropdownMenuItem(
                      value: 'Ibuprofen (eg: Midol)',
                      child: Text('Ibuprofen (eg: Midol)'),
                    ),
                    DropdownMenuItem(
                      value: 'Aspirin (eg: Advil)',
                      child: Text('Aspirin (eg: Advil)'),
                    ),
                    DropdownMenuItem(
                      value: 'ARBs (e.g., losartan)',
                      child: Text('ARBs (e.g., losartan)'),
                    ),
                    DropdownMenuItem(
                      value: 'Acetaminophen (eg: Panadol)',
                      child: Text('Acetaminophen (eg: Panadol)'),
                    ),
                    DropdownMenuItem(
                      value: 'Anticonvulsants (eg: valproic)',
                      child: Text('Anticonvulsants (eg: valproic)'),
                    ),
                    DropdownMenuItem(
                      value: 'Insulin (eg: Humulin)',
                      child: Text('Insulin (eg: Humulin)'),
                    ),
                    DropdownMenuItem(
                      value: 'NSAIDs drugs (eg: ibuprofen)',
                      child: Text('NSAIDs drugs (eg: ibuprofen)'),
                    ),
                    DropdownMenuItem(
                      value: 'ACE inhibitors (e.g., lisinopril)',
                      child: Text('ACE inhibitors (e.g., lisinopril)'),
                    ),
                    // ... other unique items
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFoodMedication = value;
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Food / Medication'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Symptom Severity (0-10)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 124, 124, 124),
                  ),
                ),
                const SizedBox(height: 10),
                NumberStepper(
                  // Replace TextField with NumberStepper
                  initialValue: _severity,
                  min: 0,
                  max: 10,
                  step: 1,
                  onChanged: (value) {
                    setState(() {
                      _severity = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  // TrackingBloc trackingBloc = TrackingBloc();
                  // TrackingResponseModel trackingResponseModel =
                  //     await trackingBloc.getListTracking(trackingRequestModel);
                  // if (TrackingResponseModel.isSuccess) {
                  //   if (mounted) {
                  //     navigateTo(context, HomePage());
                  //   }

                  //   print(trackingResponseModel);
                  // } else {
                  //   print(trackingResponseModel.message);
                  // }
                  if (_selectedDay != null &&
                      _selectedFoodMedication != null &&
                      _descriptionController.text.isNotEmpty &&
                      _selectedSymptomCategory != null) {
                    final Event newEvent = Event(
                      foodOrMedication: _selectedFoodMedication!,
                      notes: _descriptionController.text,
                      severity: _severity, // Use the updated severity value
                      timestamp: DateTime.now(),
                      symptomCategory: _selectedSymptomCategory!,
                    );

                    _addEvent(newEvent);
                    Navigator.of(context).pop();
                    _selectedEvents.value = _getEventsForDay(_selectedDay);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Colors.deepPurple, // Set the button color to pink // blue
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(child: Text("Save")),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addEvent(Event event) {
    setState(() {
      events[_selectedDay!] = [...(events[_selectedDay!] ?? []), event];
    });
  }

  void _updateEvent(Event updatedEvent) {
    setState(() {
      final List<Event>? dayEvents = events[_selectedDay!];
      if (dayEvents != null) {
        final index = dayEvents.indexWhere((event) =>
            event.timestamp ==
            updatedEvent
                .timestamp); // before change event.timestamp == updatedEvent.timestamp && event.foodOrMedication == updatedEvent.foodOrMedication

        if (index != -1) {
          dayEvents[index] = updatedEvent;
          events[_selectedDay!] = dayEvents;
        }
      }
    });
  }

  void _deleteEvent(Event event) {
    print('Deleting event: ${event.foodOrMedication}');
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Event"),
            content: const Text("Are you sure you want to delete this event?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  print('Cancel delete');
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Confirm delete');
                  _removeEvent(event);
                  Navigator.of(context).pop();
                  _selectedEvents.value = _getEventsForDay(_selectedDay);
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    }
  }

  void _removeEvent(Event event) {
    final List<Event>? dayEvents = events[_selectedDay!];
    if (dayEvents != null) {
      dayEvents.removeWhere((e) =>
          e.timestamp == event.timestamp &&
          e.foodOrMedication == event.foodOrMedication &&
          e.severity == event.severity);
      events[_selectedDay!] = dayEvents;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.calendar_month_sharp), text: 'Today'),
              Tab(icon: Icon(Icons.alarm), text: 'Meds'),
              Tab(icon: Icon(Icons.insights), text: 'Report'),
              Tab(icon: Icon(Icons.article), text: 'Insight'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TableCalendar(
                      calendarFormat: _calendarFormat,
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: _onDaySelected,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(fontSize: 24),
                      ),
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
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        weekendStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 104, 139),
                        ),
                      ),
                      eventLoader: (day) {
                        final eventsOnDay = _getEventsForDay(day);
                        return eventsOnDay.map((event) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            width: 4,
                            height: 4,
                          );
                        }).toList();
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return Column(
                          children: value.map((event) {
                            return Card(
                              // 8. Use cards for event list
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  // title: Text(event.foodOrMedication),
                                  title: Text(event.symptomCategory),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Allergen  :  ${event.foodOrMedication}"),
                                      Text("Severity   :  ${event.severity}"),
                                    ],
                                  ),

                                  onTap: () async {
                                    await _openEventDetails(event);
                                  },
                                  onLongPress: () {
                                    _deleteEvent(event);
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // MedPage(),
            // ReportPage(),
            // const InsightPage(),
            // ProfilePage(),
          ],
        ),
        floatingActionButton: _currentTabIndex == 0
            ? Theme(
                data: ThemeData(
                  primarySwatch: Colors.grey,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    _createEvent();
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white, // Set the color to white
                  ),
                  backgroundColor: Colors
                      .deepPurple, // Set the background color of the button // blue
                ),
              )
            : null,
        bottomNavigationBar:
            _currentTabIndex == 0 ? _buildBottomNavigationBar() : null,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle emergency call action here
          },
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 255, 104, 139),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          child: const Text(
            'EMERGENCY CALL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
