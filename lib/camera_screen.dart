import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import './api.dart';
import 'package:image/image.dart' as I;
import 'gallery_screen.dart';
import 'dart:io' as Io;

int counter = 0;

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    // select image stream mode for camera
    // _camera.startImageStream((CameraImage image) {

    super.initState();
  }

  late CameraController _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; //Future to wait until camera initializes
  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (widget.cameras.length > 1) {
                      setState(() {
                        selectedCamera = selectedCamera == 0 ? 1 : 0;
                        initializeCamera(selectedCamera);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No secondary camera found'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  icon: const Icon(Icons.switch_camera_rounded,
                      color: Colors.white),
                ),
                GestureDetector(
                  onTap: () async {
                    await _initializeControllerFuture;

                    //   setState(() async {
                    //   capturedImages.add(File(xFile.path));
                    //   File imagefile = File(xFile.path); //convert Path to File
                    //   Uint8List imagebytes =
                    //       await imagefile.readAsBytes(); //convert to bytes
                    //   String base64string = base64.encode(imagebytes);
                    //   //convert bytes to base64 string
                    //   Future<String> res = Post(base64string);
                    //   print(res);
                    // });

                    _controller.startImageStream((xFile) async {
                      // save image to a var
                      if (counter == 0) {
                        counter++;
                        Future<String> s = imgto64(xFile);
                        Future<String> res = Post(s);
                        print(res);
                        print("hello");
                        
                      }
                      // File imagefile = File();

                      // Uint8List imagebytes =
                      //     await imagefile.readAsBytes(); //convert to bytes
                      // String base64string = base64.encode(imagebytes);
                      // //convert bytes to base64 string
                      // Future<String> res = Post(base64string);
                      // print(res);
                    });
                    // var xFile = await _controller.takePicture();
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (capturedImages.isEmpty) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryScreen(
                                images: capturedImages.reversed.toList())));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      image: capturedImages.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(capturedImages.last),
                              fit: BoxFit.cover)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

const shift = (0xFF << 24);
Future<String> imgto64(CameraImage image) async {
  final int width = image.width;
  final int height = image.height;
  final int uvRowStride = image.planes[1].bytesPerRow;
  final int? uvPixelStride = image.planes[1].bytesPerPixel;

  // print("uvRowStride: " + uvRowStride.toString());
  // print("uvPixelStride: " + uvPixelStride.toString());

  // imgLib -> Image package from https://pub.dartlang.org/packages/image
  var img = I.Image(width, height); // Create Image buffer

  // Fill image buffer with plane[0] from YUV420_888
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      final int uvIndex =
          uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
      final int index = y * width + x;

      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];
      // Calculate pixel color
      int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
      // color: 0x FF  FF  FF  FF
      //           A   B   G   R
      img.data[index] = shift | (b << 16) | (g << 8) | r;
    }
  }
  // save img to jpeg

  // final ByteData byteData = await img.toByteData(format: I.ImageByteFormat.rawRgba);
  // final Uint8List uint8List = byteData.buffer.asUint8List();
  // final String base64 = base64Encode(uint8List);
  // print(base64);

  I.PngEncoder png = I.PngEncoder();
  List<int> im = png.encodeImage(img);
  Uint8List fin = Uint8List.fromList(im);
  final String base64 = base64Encode(fin);
  // print(base64);
  return base64;
  // final bytes = await Io.File(img).readAsBytes();

  // I.PngEncoder pngEncoder =  I.PngEncoder(level: 0, filter: 0);
  // Uint8List png = pngEncoder.encodeImage(img);
  // muteYUVProcessing = false;
  // return Image.memory(png);
}
