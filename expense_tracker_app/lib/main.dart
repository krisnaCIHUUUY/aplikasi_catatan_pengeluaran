import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/routes/app_router.dart';
import 'package:expense_tracker_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
// import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
