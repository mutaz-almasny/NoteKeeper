import 'package:flutter/material.dart';
import 'package:notes/add_notes.dart';
import 'package:notes/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {"addNote": (context) => AddNotes(), "home": (context) => Home()},
      title: 'NoteKeeper',
      home: Home(),
    );
  }
}
