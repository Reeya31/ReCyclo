import 'package:flutter/material.dart';
import 'package:ReCyclo/screens/account_screen/profile_setting.dart';

class SettingScreen extends StatelessWidget{
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(title: Text("Settings"),),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: const Row(children: [
                            Icon(
                              Icons.settings_applications_sharp,
                              color: Color.fromARGB(255, 40, 125, 112),
                              size: 30,
                            ),SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Profile Setting",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ]),
            )
          ],
        ),
      ),
    );
  }
}