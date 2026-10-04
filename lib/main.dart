import 'package:flutter/material.dart';

void main() {
  runApp(const TerrainProApp());
}

class TerrainProApp extends StatelessWidget {
  const TerrainProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerrainPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const Scaffold(body: Center(child: Text('TerrainPro'))),
    );
  }
}
