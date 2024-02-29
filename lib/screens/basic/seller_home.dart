import 'package:flutter/material.dart';
// import 'package:recyclo/constants/routes.dart';
import 'package:ReCyclo/models/waste_type.dart';
// import 'package:ReCyclo/screens/auth_ui/account_setting.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ReCyclo/screens/auth_ui/login.dart';
import 'package:ReCyclo/screens/basic/feedback.dart';
import 'package:ReCyclo/screens/basic/sell_request.dart';
// import 'package:ReCyclo/constants/themedata.dart';
// import 'package:ReCyclo/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// String selectedCategory = "";
// List<String> categories = ["Plastic", "Metal", "Paper", "e-Waste", "Others"];
class _HomeState extends State<Home> {
  String selectedCategory = "Plastic";

  List<WasteItemCategory> wasteItemCategories = [
    WasteItemCategory(categoryName: "Plastic", items: [
      WasteItem(
          itemName: "Plastic Bottle",
          imageUrl: "assets/images/water_bottle.jpg",
          description: "Rs.5 for 1l bottle."),
      WasteItem(
          itemName: "Plastic Chair",
          imageUrl: "assets/images/chair.jpg",
          description: "Negotiable"),
      WasteItem(
          itemName: "Plastic Container",
          imageUrl: "assets/images/container.png",
          description: "Rs.10 per kg"),
      WasteItem(
          itemName: "Plastic Pipes",
          imageUrl: "assets/images/plastic_pipe.jpg",
          description: "Rs.20 per meter"),
    ]),
    WasteItemCategory(categoryName: "Paper", items: [
      WasteItem(
          itemName: "Newspaper",
          imageUrl: "assets/images/newspaper.jpg",
          description: "Re.1 per page."),
      WasteItem(  
          itemName: "cardboard",
          imageUrl: "assets/images/cardboard.jpg",
          description: "Rs.10 per piece."),
    ]),
    WasteItemCategory(categoryName: "Metal & Steel", items: [
      WasteItem(
          itemName: "Aluminium",
          imageUrl: "assets/images/alu.png",
          description: "Negotiable"),
      WasteItem(
          itemName: "Steel Furniture",
          imageUrl: "assets/images/steel_furniture.jpg",
          description: "Negotiable"),
    ]),
    WasteItemCategory(categoryName: "e-Waste", items: [
      WasteItem(
          itemName: "CDs",
          imageUrl: "assets/images/CDs.jpg",
          description: "Rs.10 per kg."),
      WasteItem(
          itemName: "CPU & Accessories",
          imageUrl: "assets/images/computer.jpg",
          description: "Rs.100 per piece"),
      WasteItem(
          itemName: "Battery",
          imageUrl: "assets/images/battery.jpg",
          description: "Negotiable"),
    ]),
    WasteItemCategory(categoryName: "Glass", items: [
      WasteItem(
          itemName: "Glass Bottle",
          imageUrl: "assets/images/beer.jpg",
          description: "Rs.30 for 1l bottle"),
      WasteItem(
          itemName: "TubeLights",
          imageUrl: "assets/images/light.jpg",
          description: "Negotiable"),
    ])
  ];

@override
  Widget build(BuildContext context) {

    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue 
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
               //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), 
              //return true when click on "Yes"
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }

    // ignore: deprecated_member_use
    return WillPopScope( 
      onWillPop: showExitPopup, //call function on back button press
      child:Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 247, 245, 245)),
          title: const Text(
            "Recyclo",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 8, 149, 128),
          actions: [
            IconButton(
              onPressed: () {},
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
      
      body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "What can be Sold",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                Center(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
direction: Axis.horizontal,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: wasteItemCategories.map((category) {
                      return TextButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = category.categoryName;
                          });
                        },
                        child: Text(category.categoryName),
                      );
                    }).toList(),
                  ),
               
                ),
                const SizedBox(
                  height: 30,
                ),
                if (selectedCategory.isNotEmpty)
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      // childAspectRatio: 0.2,
                    ),
                    itemCount: wasteItemCategories
                        .firstWhere((category) =>
                            category.categoryName == selectedCategory).items
                        .length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final selectedItem = wasteItemCategories
                          .firstWhere((category) =>
                              category.categoryName == selectedCategory)
                          .items[index];
                      return Card(
                        
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          
                          children: [
                            
                            Image.asset(selectedItem.imageUrl,
                            
                                 width: 100, fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                              print("Error loading image: $error");
                              return const SizedBox();
                            }),
                            // const SizedBox(height: 8),
                            Text(
                              selectedItem.itemName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // const SizedBox(height: 8),
                            Text(
                              selectedItem.description,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                SizedBox(
                  height: 40,
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
          ))),
    ),
    );
  }
}
