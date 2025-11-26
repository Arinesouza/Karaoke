import 'package:flutter/material.dart';
import '../models/pronunciation_result.dart';

class ResultPage extends StatelessWidget {
  final PronunciationResult result;

  const ResultPage({required this.result, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resultado")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nota:", style: TextStyle(fontSize: 20)),
            Text(
              "${result.score}/100",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Text("Transcrição:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(result.transcript),

            SizedBox(height: 20),

            Text("Feedback:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(result.feedback),
          ],
        ),
      ),
    );
  }
}
