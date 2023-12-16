// signup.dart
import 'package:flutter/material.dart';
import 'buyer.dart';
import 'seller.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

enum UserType { Seller, Buyer }

class _SignupState extends State<Signup> {
  UserType selectedUserType = UserType.Seller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // User type selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: UserType.Seller,
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = UserType.Seller;
                      });
                    },
                  ),
                  const Text('Seller'),
                  Radio(
                    value: UserType.Buyer,
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = UserType.Buyer;
                      });
                    },
                  ),
                  const Text('Buyer'),
                ],
              ),
              // Signup form based on user type
              if (selectedUserType == UserType.Seller)
                SellerSignup()
              else
                BuyerSignup(),
            ],
          ),
        ),
      ),
    );
  }
}
