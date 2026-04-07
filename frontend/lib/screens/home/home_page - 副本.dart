import 'package:flutter/material.dart';
import 'package:amc8/screens/problems/year2025_problem1_page.dart';
import 'package:amc8/screens/problems/year2025_problem2_page.dart'; // 我帮你加了第二题
import 'package:amc8/screens/problems/year2025_problem3_page.dart';
import 'package:amc8/screens/problems/year2025_problem4_page.dart'; // 新增

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AMC 8 2025"),
      ),
      body: ListView(
        children: [
          // 第一题
          ListTile(
            title: const Text("Problem 1"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Y2025Problem1Page(),
                ),
              );
            },
          ),

          // 第二题（我帮你加的）
          ListTile(
            title: const Text("Problem 2"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Y2025Problem2Page(),
                ),
              );
            },
          ),
         
ListTile(
  title: const Text("Problem 3"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Y2025Problem3Page(),
      ),
    );
  },
),

          // ========== Problem4 ==========
          ListTile(
            title: const Text("Problem 4"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Y2025Problem4Page(),
                ),
              );
            },
          ),

 
        ],
      ),
    );
  }
}