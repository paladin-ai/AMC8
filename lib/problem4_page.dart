import 'package:flutter/material.dart';

class Problem4Page extends StatelessWidget {
  const Problem4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem 4'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lucius is counting backward by 7s. His first three numbers are 100, 93, and 86. What is his 10th number?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '(A) 30 (B) 37 (C) 42 (D) 44 (E) 47',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
