import 'package:flutter/material.dart';
import 'package:amc8/screens/problems/year2025_problem1_page.dart';
import 'package:amc8/screens/problems/year2025_problem2_page.dart';
import 'package:amc8/screens/problems/year2025_problem3_page.dart';
import 'package:amc8/screens/problems/year2025_problem4_page.dart';
import 'package:amc8/screens/problems/year2025_problem5_page.dart';
import 'package:amc8/screens/problems/year2025_problem6_page.dart';
import 'package:amc8/screens/problems/year2025_problem7_page.dart';
import 'package:amc8/screens/problems/year2025_problem8_page.dart';
import 'package:amc8/screens/problems/year2025_problem9_page.dart';
import 'package:amc8/screens/problems/year2025_problem10_page.dart';
import 'package:amc8/screens/problems/year2025_problem11_page.dart';
import 'package:amc8/screens/problems/year2025_problem12_page.dart';
import 'package:amc8/screens/problems/year2025_problem13_page.dart';
import 'package:amc8/screens/problems/year2025_problem14_page.dart';
import 'package:amc8/screens/problems/year2025_problem15_page.dart';
import 'package:amc8/screens/problems/year2025_problem16_page.dart';
import 'package:amc8/screens/problems/year2025_problem17_page.dart';
import 'package:amc8/screens/problems/year2025_problem18_page.dart';
import 'package:amc8/screens/problems/year2025_problem19_page.dart';
import 'package:amc8/screens/problems/year2025_problem20_page.dart';
import 'package:amc8/screens/problems/year2025_problem21_page.dart';
import 'package:amc8/screens/problems/year2025_problem22_page.dart';
import 'package:amc8/screens/problems/year2025_problem23_page.dart';
import 'package:amc8/screens/problems/year2025_problem24_page.dart';
import 'package:amc8/screens/problems/year2025_problem25_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AMC 8 2025")),
      body: ListView(
        children: [
          ListTile(title: const Text("Problem 1"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem1Page()))),
          ListTile(title: const Text("Problem 2"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem2Page()))),
          ListTile(title: const Text("Problem 3"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem3Page()))),
          ListTile(title: const Text("Problem 4"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem4Page()))),
          ListTile(title: const Text("Problem 5"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem5Page()))),
          ListTile(title: const Text("Problem 6"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem6Page()))),
          ListTile(title: const Text("Problem 7"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem7Page()))),
          ListTile(title: const Text("Problem 8"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem8Page()))),
          ListTile(title: const Text("Problem 9"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem9Page()))),
          ListTile(title: const Text("Problem 10"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem10Page()))),
          ListTile(title: const Text("Problem 11"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem11Page()))),
          ListTile(title: const Text("Problem 12"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem12Page()))),
          ListTile(title: const Text("Problem 13"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem13Page()))),
          ListTile(title: const Text("Problem 14"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem14Page()))),
          ListTile(title: const Text("Problem 15"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem15Page()))),
          ListTile(title: const Text("Problem 16"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem16Page()))),
          ListTile(title: const Text("Problem 17"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem17Page()))),
          ListTile(title: const Text("Problem 18"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem18Page()))),
          ListTile(title: const Text("Problem 19"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem19Page()))),
          ListTile(title: const Text("Problem 20"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem20Page()))),
          ListTile(title: const Text("Problem 21"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem21Page()))),
          ListTile(title: const Text("Problem 22"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem22Page()))),
          ListTile(title: const Text("Problem 23"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem23Page()))),
          ListTile(title: const Text("Problem 24"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem24Page()))),
          ListTile(title: const Text("Problem 25"),onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const Y2025Problem25Page()))),
        ],
      ),
    );
  }
}