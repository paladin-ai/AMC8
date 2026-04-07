import 'package:flutter/material.dart';

class Y2025Problem1Page extends StatelessWidget {
  const Y2025Problem1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Y2025Problem 1'),
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
              'The eight-pointed star, shown in the figure below, is a popular quilting pattern. What percent of the entire 4×4 grid is covered by the star?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // 题目1图片
            Image(
              image: NetworkImage('https://latex.artofproblemsolving.com/5/6/6/56638188764158bdffa266bc933d11b6acd2fb76.png'),
            ),
            SizedBox(height: 20),
            Text(
              '(A) 40  (B) 50  (C) 60  (D) 75  (E) 80',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
