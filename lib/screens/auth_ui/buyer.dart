// buyer.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastehub/screens/auth_ui/login.dart';
import 'package:wastehub/screens/auth_ui/signup.dart';

class BuyerSignup extends StatefulWidget {
  const BuyerSignup({Key? key}) : super(key: key);

  @override
  State<BuyerSignup> createState() => _BuyerSignupState();
}

enum WasteType { Plastic, Paper, Metal, Glass, Others }



List<String> _wasteQuantities = [
    ' 1 to 5 kg',
    ' 5 to 10 kg',
    ' Above 10 kg',
  ];
  String _selectedWasteQuantity = _wasteQuantities[0];

class _BuyerSignupState extends State<BuyerSignup> {
  bool isShowPassword = true;

  String fullName = "", email = "", phone = "", password = "", wastetype = "", wastequantity = "";
  List<WasteType> selectedWasteTypes = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController wastetypeController = TextEditingController();
  TextEditingController wastequantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

register1() async {
    if (passwordController.text != "" &&
        nameController.text != "" &&
        emailController.text != "" &&
        phoneController.text != "" &&
        wastetypeController.text != "" &&
        wastequantityController.text != ""
        ) {
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

void _showWasteTypeDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Waste Type'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildCheckbox(WasteType.Plastic),
              buildCheckbox(WasteType.Paper),
              buildCheckbox(WasteType.Metal),
              buildCheckbox(WasteType.Glass),
              buildCheckbox(WasteType.Others),
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

CheckboxListTile buildCheckbox(WasteType wasteType) {
  return CheckboxListTile(
    title: Text(wasteType.toString().split('.').last),
    value: selectedWasteTypes.contains(wasteType),
    onChanged: (bool? value) {
      setState(() {
        if (value != null && value) {
          selectedWasteTypes.add(wasteType);
        } else {
          selectedWasteTypes.remove(wasteType);
        }
      });
    },
    tileColor: selectedWasteTypes.contains(wasteType)
        ? Colors.green.withOpacity(0.2) // Selected color
        : null,
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
            Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Waste Quantity",
                      prefixIcon: const Icon(
                        Icons.check_box,
                        color: Color.fromARGB(255, 8, 149, 128),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between text field and dropdown
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 8, 149, 128), // Green color
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius
                  ),
                  child: DropdownButton<String>(
                    value: _selectedWasteQuantity,
                    items: _wasteQuantities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedWasteQuantity = value!;
                      });
                    },
                  ),
                ),
              ],
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
                    wastequantity = wastequantityController.text;
                  });
              }
              register1();
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