import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:wastehub/screens/auth_ui/login.dart';
// import 'package:recyclo/models/login_user.dart';
import 'package:flutter_toggle_tab/helper.dart';

import 'package:wastehub/screens/basic/home.dart';
// import 'package:recyclo/services/auth.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:recyclo/constants/routes.dart';
// import 'package:recyclo/controller/signup_controller.dart';
// import 'package:recyclo/screens/auth_ui/login.dart';
// import 'package:recyclo/screens/basic/home.dart';
// import 'package:recyclo/constants.dart';

class Signup extends StatefulWidget {
  // const Signup({super.key});
  final Function? toggleView;
  const Signup({super.key, this.toggleView});

  @override
  State<Signup> createState() => _SignupState();
}

enum UserType {Seller , Buyer}

class _SignupState extends State<Signup> {
  bool isShowPassword = true;

  // final AuthService _auth = AuthService();
  UserType selectedUserType = UserType.Seller;



// User Authentication
  String fullName = "", email = "", phone = "", password = "";

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  register() async {
    if (password != null &&
        namecontroller.text != "" &&
        emailcontroller.text != "" &&
        phonecontroller.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Registered Succesfully!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        )));
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Password is too weeak")));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Email is already used")));
        }
      }
    }
  }


  final ValueNotifier<int> _tabIndexBasicToggle = ValueNotifier(1);

  //toggle button
  List<String> get btns => ["Seller","Buyer"];
  // int counter =0;


      // Function to render the form fields based on the selected user type
Widget renderFormFields(UserType userType){
  switch(userType){
    case UserType.Seller:
      return Column(
          children: [
            Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                      controller: namecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "FullName",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 8, 149, 128),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      validator: (value) {
                        if (value != null) {
                          if (value.contains('@') && value.endsWith('.com')) {
                            return null;
                          }
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
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
                      controller: phonecontroller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "Phone Number",
                          prefixIcon: Icon(
                            Icons.call,
                            color: Color.fromARGB(255, 8, 149, 128),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                      controller: passwordcontroller,
                      obscureText: isShowPassword,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters in length';
                        }
                        // Return null if the entered password is valid
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Create Password",
                        prefixIcon: const Icon(
                          Icons.lock,
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
                 ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          fullName = namecontroller.text;
                          email = emailcontroller.text;
                          phone = phonecontroller.text;
                          password = passwordcontroller.text;
                        });
                      }
                      register();
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(color: Colors.white),
                    )),




          ],
      );
      case UserType.Buyer:
          return Column(
          children: [
            Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                      controller: namecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "FullName",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 8, 149, 128),
                          ))),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                      controller: namecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "FullName",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 8, 149, 128),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      validator: (value) {
                        if (value != null) {
                          if (value.contains('@') && value.endsWith('.com')) {
                            return null;
                          }
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
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
                      controller: phonecontroller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "Phone Number",
                          prefixIcon: Icon(
                            Icons.call,
                            color: Color.fromARGB(255, 8, 149, 128),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                      controller: passwordcontroller,
                      obscureText: isShowPassword,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters in length';
                        }
                        // Return null if the entered password is valid
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Create Password",
                        prefixIcon: const Icon(
                          Icons.lock,
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
                 ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          fullName = namecontroller.text;
                          email = emailcontroller.text;
                          phone = phonecontroller.text;
                          password = passwordcontroller.text;
                        });
                      }
                      register();
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(color: Colors.white),
                    )),




          ],
      );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text('Create an Account',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ))),
                ),
                
                ValueListenableBuilder(valueListenable: _tabIndexBasicToggle, builder: (context,currentIndex,_){
                  selectedUserType = currentIndex==0 ? UserType.Seller:UserType.Buyer;

                  return FlutterToggleTab(
                    width: 90,
                    height: 50,
                    borderRadius: 30,
                    labels: btns,
                     selectedIndex: currentIndex,
                     selectedBackgroundColors: [Color.fromARGB(255, 8, 149, 128)],
                     selectedTextStyle: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),
                      unSelectedTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                selectedLabelIndex: (index){ 
                  _tabIndexBasicToggle.value = index;
                  
                },
                isScroll: false,
                     
                     
                     );
                }
                )
               ,

               renderFormFields(selectedUserType),

                
                
               
               
                const SizedBox(
                  height: 12,
                ),
                const Text("Already Have an Account?"),

                // TextButton(onPressed: (){}, child: const Text("Create an Account."))
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                )
              ]),
            )),
      ),
    );
  }
}