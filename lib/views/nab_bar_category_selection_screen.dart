import 'package:flutter/material.dart';
import 'package:testapi/views/data_screens.dart';

class NabBarCategorySelectionScreen extends StatefulWidget {
  const NabBarCategorySelectionScreen({super.key});

  @override
  State<NabBarCategorySelectionScreen> createState() => _NabBarCategorySelectionScreenState();
}

class _NabBarCategorySelectionScreenState extends State<NabBarCategorySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: const DataScreens(), 
    );
  }
}