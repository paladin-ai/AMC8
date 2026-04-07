import 'package:flutter/material.dart';

class Problem2Page extends StatelessWidget {
  const Problem2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem 2'),
        // 允许返回首页
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
              'The table below shows the Ancient Egyptian hieroglyphs that were used to represent different numbers.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // 题目2表图
            Image(
              image: NetworkImage('https://artofproblemsolving.com/wiki/images/d/de/Mathh.PNG'),
            ),
            SizedBox(height: 20),
            Text(
              'For example, the number 32 was represented by the hieroglyphs ∩∩∩||. What number is represented by the following combination of hieroglyphs?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // 题目2示例图
            Image(
              image: NetworkImage('https://artofproblemsolving.com/wiki/images/3/38/Amc8_2025_prob_2_pic.PNG'),
            ),
            SizedBox(height: 20),
            Text(
              '(A) 1,423  (B) 10,423  (C) 14,023  (D) 14,203  (E) 14,230',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
