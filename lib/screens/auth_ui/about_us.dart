import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display Picture
            Image.asset(
              'assets/images/welcome.png', // Replace with your image path
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // "About Us" Text
            SizedBox(height: 10),
            Text(
              'Recyclo is all about making recycling easy and convenient. We use technology to help people recycle more, making our world cleaner and better for everyone.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // "Our Purpose" Section
            Text(
              'Our Purpose',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our mission is to empower communities to adopt eco-friendly practices for a greener, healthier planet.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // "Meet Our Members" Section
            Text(
              'Meet Our Members',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // List of team members
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/reeya.jpg'), // Replace with member's profile picture
              ),
              title: Text('Riya BC'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('riyabc.076@kathford.edu.np'),
                  Text('+977 9815603612'),
                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/rupesh.jpg'), // Replace with member's profile picture
              ),
              title: Text('Rupesh Khatri'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('rupeshkhatri.076@kathford.edu.np'),
                  Text('+977 9816373563'),
                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/sneha.jpg'), // Replace with member's profile picture
              ),
              title: Text('Sneha Neupane'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('snehaneupane.076@kathford.edu.np'),
                  Text('+977 9825365166'),
                ],
              ),
            ),
            // Add more ListTile widgets for other members as needed
          ],
        ),
      ),
    );
  }
}