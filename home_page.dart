import 'package:flutter/material.dart';
import 'year2025_problem1_page.dart';

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
        ],
      ),
    );
  }
}