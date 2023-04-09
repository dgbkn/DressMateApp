import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class GoogleMLVisionPage extends StatefulWidget {
  const GoogleMLVisionPage({super.key});

  @override
  State<GoogleMLVisionPage> createState() => _GoogleMLVisionPageState();
}

class _GoogleMLVisionPageState extends State<GoogleMLVisionPage> {
  final ImageLabeler labeler = GoogleVision.instance.imageLabeler();


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child:  SingleChildScrollView(

      )),
    );
  }
}