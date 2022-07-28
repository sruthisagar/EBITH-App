import 'dart:async';
import 'dart:io';
import 'dart:async';


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sru_apz/darter.dart';
// import 'package:camerawesome/camerawesome_plugin.dart';

void main()
{
  runApp(const Home());
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Starter(),
    );
  }
}



// class Camera extends StatefulWidget {
//   const Camera({Key? key}) : super(key: key);
//
//   @override
//   State<Camera> createState() => _CameraState();
// }
//
// class _CameraState extends State<Camera> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }



// class camera_page extends StatefulWidget {
//   const camera_page({Key? key}) : super(key: key);
//
//   @override
//   State<camera_page> createState() => _camera_pageState();
// }
//
// class _camera_pageState extends State<camera_page> with TickerProviderStateMixin {
//   ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
//   ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
//   ValueNotifier<Size> _photoSize = ValueNotifier(Size(1920, 1080));
//   @override
//   Widget build(BuildContext context) {
//     return CameraAwesome(
//       testMode: false,
//       // onPermissionsResult: (bool result) { },
//       selectDefaultSize: (List<Size> availableSizes) => Size(1920, 1080),
//       onCameraStarted: () { },
//       // onOrientationChanged: (CameraOrientations newOrientation) { },
//       // zoom: 0.64,
//       sensor: _sensor,
//       photoSize: _photoSize,
//       // switchFlashMode: _switchFlash,
//       captureMode: _captureMode,
//       fitted: true,
//       imagesStreamBuilder: (imageStream) {
//         /// listen for images preview stream
//         /// you can use it to process AI recognition or anything else...
//         print('-- init CamerAwesome images stream');
//       },
//     );
//   }
// }


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final cameras = await availableCameras();
//
//   final firstCamera = cameras.first;
//
//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         camera: firstCamera,
//       ),
//     ),
//   );
// }
//
// class TakePictureScreen extends StatefulWidget {
//   const TakePictureScreen({
//     super.key,
//     required this.camera,
//   });
//
//   final CameraDescription camera;
//
//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }
//
// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   TakePictureScreenState()
//   {
//     var time = const Duration(milliseconds: 5000);
//     Timer.periodic(time, (timer) => {
//     capture_image();
//     }
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       widget.camera,
//       ResolutionPreset.medium,
//     );
//
//
//     _initializeControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Take a picture')),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//
//
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }
//
// Future<void> capture_image()
// async {
//   try {
//     await _initializeControllerFuture;
//     final image = await _controller.takePicture();
//     if (!mounted) return;
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => DisplayPictureScreen(
//           imagePath: image.path,
//         ),
//       ),
//     );
//   } catch (e) {
//     print(e);
//   }
// }
//
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({super.key, required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       body: Image.file(File(imagePath)),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print(imagePath);
//         },
//       ),
//     );
//   }
// }