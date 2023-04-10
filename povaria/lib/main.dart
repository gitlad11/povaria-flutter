import 'package:flutter/material.dart';
import 'package:povaria/components/current_list.dart';
import 'package:povaria/store/current_list.dart';
import 'package:povaria/store/recipe.dart';
import 'package:povaria/views/main_view.dart';
import 'package:provider/provider.dart';
import 'package:povaria/store/catalog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Catalog_store()),
        ChangeNotifierProvider(create: (_) => Current_list_store()),
        ChangeNotifierProvider(create: (_) => Recipe_store())
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Main_view();
  }
}
