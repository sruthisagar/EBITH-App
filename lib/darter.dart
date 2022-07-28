import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import './camera_screen.dart';

class Starter extends StatefulWidget {
  const Starter({super.key});

  @override
  State<Starter> createState() => _StarterState();
}

class _StarterState extends State<Starter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            final List<CameraDescription> cameras = await availableCameras();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraScreen(cameras: cameras)),
            );
          },
          child: Text("click me"),
        ),
      ),
    );
  }
}
