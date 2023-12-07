import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:allergygenieapi/pages/widgets/base_page.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  final User user;
  const ReportPage({super.key, required this.user});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
    //   return Scaffold(
    //     body: BasePage(),
    //   );
  }
}
