import 'package:flutter/material.dart';

import '../widgets/home/category_line.dart';
import '../widgets/home_appbar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppbar(onTap: () {  }, screenIcon: Icon(Icons.add),),
          CategoryLine(),
          CategoryLine(),
          CategoryLine(),
          CategoryLine(),
          CategoryLine(),
        ],
      )
    );
  }
}
