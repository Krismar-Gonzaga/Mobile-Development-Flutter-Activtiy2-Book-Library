// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/book_view_model.dart';
import 'views/book_list_view.dart';

/// Main application entry point
/// Wraps the app with ChangeNotifierProvider to make BookViewModel available
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Book Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),
        // cardTheme: CardTheme(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        // ),
      ),
      home: const BookListView(),
    );
  }
}