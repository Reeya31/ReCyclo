import 'package:flutter/material.dart';
// import 'package:recyclo/constants/routes.dart';
import 'package:wastehub/models/waste_type.dart';
// import 'package:wastehub/screens/auth_ui/account_setting.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:wastehub/screens/auth_ui/login.dart';
import 'package:wastehub/screens/basic/feedback.dart';
import 'package:wastehub/screens/basic/sell_request.dart';
// import 'package:wastehub/constants/themedata.dart';
// import 'package:wastehub/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// String selectedCategory = "";
// List<String> categories = ["Plastic", "Metal", "Paper", "e-Waste", "Others"];
class _HomeState extends State<Home> {
  String selectedCategory = "";

  List<WasteItemCategory> wasteItemCategories = [
    WasteItemCategory(categoryName: "Plastic", items: [
      WasteItem(
          itemName: "Plastic Bottle",
          imageUrl: "assets/images/water_bottle.jpg",
          description: "plastic water bottle"),
      WasteItem(
          itemName: "Plastic Chair",
          imageUrl: "assets/images/chair.jpg",
          description: "broken chair"),
    ]),
    WasteItemCategory(categoryName: "Paper", items: [
      WasteItem(
          itemName: "Newspaper",
          imageUrl: "assets/images/newspaper.jpg",
          description: "plastic water bottle"),
      WasteItem(
          itemName: "cardboard",
          imageUrl: "assets/images/cardboard.jpg",
          description: "broken chair"),
    ]),
    WasteItemCategory(categoryName: "Metal & Steel", items: [
      WasteItem(
          itemName: "Aluminium",
          imageUrl: "assets/images/alu.png",
          description: "aluminium untesils"),
      WasteItem(
          itemName: "Steel",
          imageUrl: "assets/images/steel.jpg",
          description: "rusted steel tool"),
    ]),
    WasteItemCategory(categoryName: "e-Waste", items: [
      WasteItem(
          itemName: "Old Computer",
          imageUrl: "assets/images/computer.jpg",
          description: "plastic water bottle"),
      WasteItem(
          itemName: "Battery",
          imageUrl: "assets/images/battery.jpg",
          description: "broken chair"),
    ]),
    WasteItemCategory(categoryName: "Glass", items: [
      WasteItem(
          itemName: "Glass Bottle",
          imageUrl: "assets/images/beer.jpg",
          description: "plastic water bottle"),
      WasteItem(
          itemName: "TubeLights",
          imageUrl: "assets/images/light.jpg",
          description: "broken chair"),
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              )),
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'account_screen');
                },
                icon: const Icon(
                  Icons.circle,
                  color: Colors.white,
                ));
          })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FeedbackPage()));
        },
        label: Text("Provide Feedback"),
        backgroundColor: Color.fromARGB(255, 8, 149, 128),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // body: Padding(
      //   padding: const EdgeInsets.all(15),
      //   child: GridView.count(

      //     crossAxisCount: 2,
      //     crossAxisSpacing: 5,
      //   ),
      // ),

      body: Padding(
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

                  // children: wasteTypes.map((WasteType) {
                  //   return TextButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         selectedCategory = WasteType.name;
                  //         print("Selected Category:$selectedCategory");
                  //       });
                  //     },
                  //     child: Text(WasteType.name),
                  //   );
                  // }).toList(),
                  // children: [
                  //   TextButton(
                  //       onPressed: () {}, child: const Text("Plastic")),
                  //   TextButton(onPressed: () {}, child: Text("Paper")),
                  //   TextButton(onPressed: () {}, child: Text("Metal")),
                  //   TextButton(onPressed: () {}, child: Text("e-waste")),
                  //   TextButton(onPressed: () {}, child: Text("others")),
                  // ]
                ),
                const SizedBox(
                  height: 40,
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
                                height: 120, width: 100, fit: BoxFit.contain,
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
          )),
    );
  }
}
