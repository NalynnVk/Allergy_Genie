import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/base_page.dart';
import 'package:flutter/material.dart';

class MedReminderPage extends StatefulWidget {
  final User user;
  const MedReminderPage({super.key, required this.user});

  @override
  State<MedReminderPage> createState() => _MedReminderPageState();
}

class _MedReminderPageState extends State<MedReminderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
