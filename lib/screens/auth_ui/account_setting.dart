import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastehub/authentication/authentication_repository.dart';
import 'package:wastehub/screens/auth_ui/login.dart';
// import 'package:get/get.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Logout() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Setting')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Profile Setting",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.arrow_right,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Row(children: [
                      Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 40, 125, 112),
                        size: 30,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  const Row(children: [
                    Icon(
                      Icons.money,
                      color: Color.fromARGB(255, 40, 125, 112),
                      size: 30,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Rates",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ]),
                  const SizedBox(
                    height: 45,
                  ),
                  const Row(children: [
                    Icon(
                      Icons.info,
                      color: Color.fromARGB(255, 40, 125, 112),
                      size: 30,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "About Us",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ]),
                  const SizedBox(
                    height: 45,
                  ),
                  const Row(children: [
                    Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 40, 125, 112),
                      size: 30,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Contact",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ]),
                  const SizedBox(
                    height: 45,
                  ),
                  InkWell(
                    onTap: () {
                      Logout();
                    },
                    child: const Row(children: [
                      Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 40, 125, 112),
                        size: 30,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}