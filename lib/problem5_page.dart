import 'package:flutter/material.dart';

class Problem5Page extends StatelessWidget {
  const Problem5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem 5'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Betty drives a truck to deliver packages in a neighborhood whose street map is shown below.\n\n'
              'Betty starts at the factory (labeled F) and drives to location A, then B, then C, before returning to F. '
              'What is the shortest distance, in blocks, she can drive to complete the route?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // 题目地图图片
            Image.network(
              'https://latex.artofproblemsolving.com/0/2/f/02f4d70dd8e934b785c58b9e171db52b9bca463e.png',
              width: 328,
              height: 222,
            ),
            const SizedBox(height: 20),
            const Text(
              '(A) 20 (B) 22 (C) 24 (D) 26 (E) 28',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
