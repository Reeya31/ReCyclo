import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastehub/screens/basic/home.dart';
import 'package:wastehub/screens/basic/buyer_home.dart'; // Import your buyer screen
// import 'package:wastehub/screens/seller_home.dart'; // Import your seller screen

enum UserRole { buyer, seller }

class Login extends StatefulWidget {
  final Function? toggleView;

  const Login({Key? key, this.toggleView}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPassword = true;
  String email = "";
  String password = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserRole selectedRole = UserRole.buyer; // Default role is buyer

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (selectedRole == UserRole.buyer) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BuyerHome()));
      } else if (selectedRole == UserRole.seller) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user found for that email")),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Wrong Password")),
        );
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Image.asset(
                    "assets/images/Recyclo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  onChanged: (UserRole? value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: UserRole.buyer,
                      child: const Text('Buyer'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.seller,
                      child: const Text('Seller'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Select Role',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 8, 149, 128),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: emailController,
                    autofocus: false,
                    validator: (value) {
                      if (value != null) {
                        if (value.contains('@') && value.endsWith('.com')) {
                          return null;
                        }
                        return 'Enter a valid email address';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Color.fromARGB(255, 8, 149, 128),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: passwordController,
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
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = emailController.text;
                        password = passwordController.text;
                      });
                    }
                    userLogin();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text("Don't have an account?"),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'signup_screen');
                  },
                  child: const Text(
                    "Create an Account.",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
