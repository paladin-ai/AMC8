import 'package:flutter/material.dart';

class Problem3Page extends StatelessWidget {
  const Problem3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem 3'),
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
              'Buffalo Shuffle-o is a card game in which all the cards are distributed evenly among all players at the start of the game. When Annika and 3 of her friends play Buffalo Shuffle-o, each player is dealt 15 cards. Suppose 2 more friends join the next game. How many cards will be dealt to each player?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '(A) 8 (B) 9 (C) 10 (D) 11 (E) 12',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
