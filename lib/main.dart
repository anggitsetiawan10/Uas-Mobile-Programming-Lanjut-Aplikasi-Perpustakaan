import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';

// Inisialisasi RouteObserver global
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
      navigatorObservers: [routeObserver], // Penting untuk RouteAware
    );
  }
}
