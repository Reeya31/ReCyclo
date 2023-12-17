import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:wastehub/authentication/authentication_repository.dart';
import 'package:wastehub/constants/themedata.dart';
import 'package:wastehub/firebase_options.dart';
import 'package:wastehub/models/firebase_user.dart';
import 'package:wastehub/screens/auth_ui/account_setting.dart';
import 'package:wastehub/screens/auth_ui/login.dart';
import 'package:wastehub/screens/auth_ui/signup.dart';
import 'package:wastehub/screens/auth_ui/user_profile.dart';
import 'package:wastehub/screens/basic/home.dart';
import 'package:wastehub/screens/basic/buyer_home.dart';
import 'package:wastehub/screens/basic/welcome.dart';
import 'package:wastehub/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:wastehub/screens/basic/sell_request.dart';
// import 'package:recyclo/screens/auth_ui/login.dart';
// import 'package:recyclo/screens/basic/welcome.dart';
// import 'package:recyclo/constants/themedata.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "recyclo",
          theme: themeData,
          initialRoute: 'login_screen',
          routes: {
            'welcome_screen': (context) => Welcome(),
            'signup_screen': (context) => Signup(),
            'login_screen': (context) => Login(),
            'profile_screen': (context) => UserProfile(),
            'home_screen': (context) => Home(),
            'buyer_home_screen': (context) => BuyerHome(),
            'account_screen': (context) => AccountSetting(),
          },
          home:  Signup(),
        ));
  }
}
