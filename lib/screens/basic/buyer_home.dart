import 'package:flutter/material.dart';
import 'package:wastehub/screens/basic/feedback.dart';
import 'package:wastehub/screens/basic/sell_request.dart';

class BuyerHome extends StatefulWidget {
  const BuyerHome({Key? key});

  @override
  State<BuyerHome> createState() => _HomeState();
}

class _HomeState extends State<BuyerHome> {
  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 247, 245, 245)),
        title: const Text(
          "Recyclo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 149, 128),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'history_screen'); // Replace with the actual name of your history screen
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'account_screen');
            },
            icon: const Icon(
              Icons.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
            label: const Text("Provide Feedback"),
            backgroundColor: Color.fromARGB(255, 8, 149, 128),
            foregroundColor: Colors.white,
          ),
          const SizedBox(height: 10),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),

            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'history_screen'); // Replace with the actual name of your history screen
              },
              child: const Text("History", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellRequest()));
                    },
                    child: Text("Sell Waste",style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}
