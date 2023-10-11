import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/Screens/Dashboard.dart';
import 'package:tracker/login/getStart.dart';

import 'package:tracker/login/login.dart';
import 'package:tracker/provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  final prefs = await SharedPreferences.getInstance();
  final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
  

  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: MyApp(
      isAuthenticated: isAuthenticated,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isAuthenticated});
  final isAuthenticated;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: isAuthenticated ? Dashboard() : GetStarted(),
  // home: LoginScreen(),
    );
  }
}
