// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:budgeting_for_lexingtons/page/create_sheets_page.dart';
import 'package:budgeting_for_lexingtons/page/create_settings_page.dart';
import 'package:budgeting_for_lexingtons/api/sheets/budget_sheet_api.dart';
import 'package:budgeting_for_lexingtons/widget/popup.dart';

Future main() async {
  await Future.delayed(const Duration(milliseconds: 200));
  WidgetsFlutterBinding.ensureInitialized();

  // await BudgetSheetApi.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

@immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with AfterLayoutMixin<HomeScreen> {
  static const title = 'Budgeting for Lexington';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.money)),
                Tab(icon: Icon(Icons.settings))
              ],
            )
          ),
          body: TabBarView(
            children: [
              CreateSheetsPage(),
              CreateSettingsPage(),
            ],

          ),
        // body: const Center(
          // body: CreateSheetsPage(),
        // body: const Center(
        //   child: Text('Hello World'),
        // ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    // Calling the same function "after layout" to resolve the issue.
    var status = await BudgetSheetApi.setSheetConnection();
    var status_color;
    var msg1;
    var msg2;
    if(status){
      msg1 = 'Fuck yeah';
      msg2 = "Connection to google sheet was successful";
      status_color = Color.fromARGB(255, 28, 111, 1);
    } else {
      msg1 = 'Shieeeeeet';
      msg2 = "Could not connect to google sheet";
      status_color = Color.fromARGB(255, 103, 5, 5);
    }
    ScaffoldMessenger.of(context).showSnackBar(connectionPopup(status_color, msg1, msg2));
  }

  void showHelloWorld() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Hello World'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('DISMISS'),
            )
          ],
        );
      },
    );
  }
}

// MaterialApp(
//       home: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(title),
//             bottom: const TabBar(
//               tabs: [
//                 Tab(icon: Icon(Icons.money)),
//                 Tab(icon: Icon(Icons.settings))
//               ],
//             )
//           ),
//           body: TabBarView(
//             children: [
//               CreateSheetsPage(),
//               CreateSettingsPage(),
//             ],

//           ),
//         // body: const Center(
//           // body: CreateSheetsPage(),
//         // body: const Center(
//         //   child: Text('Hello World'),
//         // ),
//         ),
//       ),
//     );