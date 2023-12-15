import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:recyclo/constants/routes.dart';
import 'package:wastehub/models/login_user.dart';
import 'package:wastehub/screens/basic/home.dart';
// import 'package:recyclo/screens/auth_ui/signup.dart';
import 'package:wastehub/services/auth.dart';
// import 'package:recyclo/constants.dart';

class Login extends StatefulWidget {
  // const Login({super.key});
  final Function? toggleView;
  const Login({super.key, this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPassword = true;

  String email = "", password = "";
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found for that email")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Wrong Password")));
      }
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
                    // const Padding(
                    //   padding: EdgeInsets.all(20),
                    //   child: Center(
                    //       child: Text('Welcome Back!',
                    //           style: TextStyle(
                    //             fontSize: 35,
                    //             fontWeight: FontWeight.bold,
                    //           ))),
                    // ),
                    Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Image.asset("assets/images/Recyclo.png",fit: BoxFit.contain,)),
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