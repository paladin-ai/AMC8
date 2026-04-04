import 'package:flutter/material.dart';

class Problem8Page extends StatelessWidget {
  const Problem8Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem 8'),
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
              'Isaiah cuts open a cardboard cube along some of its edges to form the flat shape shown on the right, which has an area of 18 square centimeters. What is the volume of the cube in cubic centimeters?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            
            // 题目图片
            Image.network(
              'https://artofproblemsolving.com/wiki/images/5/54/Amc8_2025_prob8.PNG',
              width: 410,
              height: 157,
            ),
            
            const SizedBox(height: 20),
            const Text(
              '(A) 3\u{221A}3 (B) 6 (C) 9 (D) 6\u{221A}3 (E) 9\u{221A}3',
              style: TextStyle(fontSize: 18)
            ),
          ],
        ),
      ),
    );
  }
}