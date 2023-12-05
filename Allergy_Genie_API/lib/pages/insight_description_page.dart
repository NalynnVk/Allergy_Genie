import 'package:allergygenieapi/models/insight/insight_model.dart';
import 'package:allergygenieapi/models/user/user_model.dart';
import 'package:flutter/material.dart';

class InsightDescriptionPage extends StatefulWidget {
  final User user;
  final Insight insight;

  const InsightDescriptionPage(
      {super.key, required this.user, required this.insight});

  @override
  State<InsightDescriptionPage> createState() => _InsightDescriptionPageState();
}

class _InsightDescriptionPageState extends State<InsightDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Insight"), //tekan title1 at homepage, tittle1 display in description page
      ),
      body: SingleChildScrollView(
        //easy to scroll
        child: Padding(
          // padding tepi
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.insight.photo_path ?? 'No Photo',
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.insight.title ?? 'No Title',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.insight.description ?? 'No Description',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.normal),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
