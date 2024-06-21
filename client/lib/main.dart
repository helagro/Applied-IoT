import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:tradfri_extension/screens/automations_screen.dart';
import 'package:tradfri_extension/screens/data_screen.dart';
import 'package:tradfri_extension/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const TabBar(
                tabs: [
                  Tab(text: "Automations"),
                  Tab(text: "Data"),
                  Tab(
                    text: "Settings",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                const AutomationsScreen(),
                DataScreen(),
                const Settings(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
