// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wastehub/constants/routes.dart';

import 'package:wastehub/screens/basic/buyer_home.dart';
import 'package:wastehub/screens/basic/seller_home.dart';
// import 'package:wastehub/screens/auth_ui/signup.dart';
// import 'package:wastehub/constants.dart';

class Login extends StatefulWidget {
  // const Login({super.key});
  final Function? toggleView;
  const Login({super.key, this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _LoginState extends State<Login> {
  bool isShowPassword = true;

  String email = "", password = "";
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String selectedRole = "Seller";

  List<String> roles = ["Seller", "Buyer"];

  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Retrieve user information from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      String userType = userDoc['userType'];

      // Check if the user's role matches the selected role
      // ignore: unrelated_type_equality_checks
      if (selectedRole == "Seller" && userType == 'Seller') {
        Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
              }
        // Navigate to the appropriate screen based on the user's role
        
        else if(selectedRole == "Buyer" && userType == 'Buyer'){
          // Navigate to Buyer screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BuyerHome()));
        }
       else {
        // Role mismatch, show an error message or handle it accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Invalid user role for login"),
              backgroundColor: Color.fromARGB(255, 8, 149, 128)),
        );
      }

      // if (selectedRole == "Seller") {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => const Home()));
      // } else {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => const BuyerHome()));
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found for that email"),
            backgroundColor: Color.fromARGB(255, 8, 149, 128)));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Wrong Password"),
            backgroundColor: Color.fromARGB(255, 8, 149, 128)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    // const Padding(
                    //   padding: EdgeInsets.all(20),
                    //   child: Center(
                    //       child: Text('Welcome Back!',
                    //           style: TextStyle(
                    //             fontSize: 35,
                    //             fontWeight: FontWeight.bold,
                    //           ))),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Image.asset(
                          "assets/images/Recyclo.png",
                          fit: BoxFit.contain,
                          width: 300, // Set the desired width
                          height: 280, // Set the desired height
                          )),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                          controller: emailcontroller,
                          autofocus: false,
                          validator: (value) {
                            if (value != null) {
                              if (value.contains('@') &&
                                  value.endsWith('.com')) {
                                return null;
                              }
                              return 'Enter the valid email address';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Color.fromARGB(255, 8, 149, 128),
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                          controller: passwordcontroller,
                          obscureText: isShowPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.password_outlined,
                              color: Color.fromARGB(255, 8, 149, 128),
                            ),
                            suffixIcon: TextButton(
                              onPressed: () {
                                setState(() {
                                  isShowPassword = !isShowPassword;
                                });
                              },
                              child: const Icon(
                                Icons.visibility,
                                color: Color.fromARGB(255, 8, 149, 128),
                              ),
                            ),
                          )),
                    ),
                    DropdownButton<String>(
                      value: selectedRole,
                      items: roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailcontroller.text;
                              password = passwordcontroller.text;
                            });
                          }
                          userLogin();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        )),

                    const SizedBox(
                      height: 12,
                    ),
                    const Text("Didn't Have an Account?"),
                    const SizedBox(
                      height: 12,
                    ),
                    // TextButton(onPressed: (){}, child: const Text("Create an Account."))
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'signup_screen');
                      },
                      child: const Text(
                        "Create an Account.",
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    )
                  ]),
                ))));
  }
}