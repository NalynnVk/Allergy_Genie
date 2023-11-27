import 'package:flutter/material.dart';
import 'package:allergygenieapi/pages/tracking/number_stepper.dart'; // Import the custom number stepper widget

class Event {
  final String foodOrMedication;
  final String symptomCategory;
  final String notes;
  final int severity;
  final DateTime timestamp;

  Event({
    required this.foodOrMedication,
    required this.symptomCategory,
    required this.notes,
    required this.severity,
    required this.timestamp,
  });
}

class EventDetailsPage extends StatefulWidget {
  final Event event;

  const EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  // late TextEditingController _symptomCategoryController;
  // late TextEditingController _severityController;
  late TextEditingController _descriptionController;

  String? _selectedSymptomCategory;
  String? _selectedFoodMedication;

  int _severity = 0; // Added a variable to store symptom severity

  @override
  void initState() {
    super.initState();
    // _symptomCategoryController =
    //     TextEditingController(text: widget.event.symptomCategory);
    // _severityController =
    //     TextEditingController(text: widget.event.severity.toString());
    _selectedSymptomCategory = widget.event.symptomCategory;
    _selectedFoodMedication = widget.event.foodOrMedication;
    _descriptionController = TextEditingController(text: widget.event.notes);

    // Initialize severity with the value from the event
    _severity = widget.event.severity;
  }

  @override
  void dispose() {
    // _symptomCategoryController.dispose();
    // _severityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateEvent() {
    final updatedEvent = Event(
      symptomCategory: _selectedSymptomCategory ?? '',
      foodOrMedication: _selectedFoodMedication ?? '',
      severity: _severity,
      notes: _descriptionController.text,
      timestamp: widget.event.timestamp,
    );

    Navigator.of(context).pop(updatedEvent); // Return the updated event
  }

  void _deleteEvent() {
    if (mounted) {
      Navigator.of(context).pop(null); // Return null when the event is deleted
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Event'),
                    content: const Text(
                        'Are you sure you want to delete this event?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteEvent();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
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
                  // Add all the other food/medication options here
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSymptomCategory = value;
                  });
                },
                decoration:
                    const InputDecoration(labelText: 'Symptom Category'),
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
                  // Add all the other food/medication options here
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFoodMedication = value;
                  });
                },
                decoration:
                    const InputDecoration(labelText: 'Food / Medication'),
              ),
              // TextFormField(
              //   controller: _symptomCategoryController,
              //   decoration:
              //       const InputDecoration(labelText: 'Symptom Category'),
              // ),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Additional Notes'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Symptom Severity (0-10)',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 97, 97, 97),
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

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateEvent,
                child: const Text('Update Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
