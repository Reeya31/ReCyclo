// buyer.dart
import 'package:flutter/material.dart';
import 'package:wastehub/screens/auth_ui/signup.dart';

class BuyerSignup extends StatefulWidget {
  const BuyerSignup({Key? key}) : super(key: key);

  @override
  State<BuyerSignup> createState() => _BuyerSignupState();
}

enum WasteType { Plastic, Paper, Metal, Glass, Others }

class _BuyerSignupState extends State<BuyerSignup> {
  bool isShowPassword = true;

  String fullName = "", email = "", phone = "", password = "", wastetype = "";
  List<String> selectedWasteTypes = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController wastetypeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _showWasteTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Waste Type'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text("Plastic"),
                  value: selectedWasteTypes.contains(WasteType.Plastic),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedWasteTypes.add(WasteType.Plastic as String);
                      } else {
                        selectedWasteTypes.remove(WasteType.Plastic);
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Paper"),
                  value: selectedWasteTypes.contains(WasteType.Paper),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedWasteTypes.add(WasteType.Paper as String);
                      } else {
                        selectedWasteTypes.remove(WasteType.Paper);
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Metal"),
                  value: selectedWasteTypes.contains(WasteType.Metal),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedWasteTypes.add(WasteType.Metal as String);
                      } else {
                        selectedWasteTypes.remove(WasteType.Metal);
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Glass"),
                  value: selectedWasteTypes.contains(WasteType.Glass),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedWasteTypes.add(WasteType.Glass as String);
                      } else {
                        selectedWasteTypes.remove(WasteType.Glass);
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Others"),
                  value: selectedWasteTypes.contains(WasteType.Others),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedWasteTypes.add(WasteType.Others as String);
                      } else {
                        selectedWasteTypes.remove(WasteType.Others);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Full Name",
                prefixIcon: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 8, 149, 128),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
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
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Icon(
                  Icons.call,
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
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                if (value.trim().length < 8) {
                  return 'Password must be at least 8 characters in length';
                }
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              readOnly: true,
              onTap: () {
                _showWasteTypeDialog();
              },
              decoration: InputDecoration(
                hintText: "Select Waste Type",
                prefixIcon: const Icon(
                  Icons.check_box,
                  color: Color.fromARGB(255, 8, 149, 128),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                 setState(() {
                    fullName = nameController.text;
                    email = emailController.text;
                    phone = phoneController.text;
                    password = passwordController.text;
                    wastetype = wastetypeController.text;
                  });
              }
            },
            child: const Text(
              "SignUp",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
