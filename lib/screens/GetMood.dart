import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:flutter/material.dart';
import 'package:platform/platform.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;

class GetMood extends StatefulWidget {
  const GetMood({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  final List cameras;

  @override
  _GetMoodState createState() => _GetMoodState();
}

class _GetMoodState extends State<GetMood> {
  @override
  Widget build(BuildContext context) {
    print("cameras");
    for (dynamic i in widget.cameras) print(i);
    return TakePictureScreen(camera: widget.cameras[1]);
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Map<int, String> mapper = {
    0: 'angry',
    1: 'disgust',
    2: 'fear',
    3: 'happy',
    4: 'sad',
    5: 'surprise',
    6: 'neutral',
  };

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      // which camera to use (currently using front)
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Let's guess!!")),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          while (true) {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();

              final inputImage = InputImage.fromFilePath(image.path);

              final faceDetector = GoogleMlKit.vision.faceDetector();

              final List<Face> faces =
                  await faceDetector.processImage(inputImage);

              if (faces.isEmpty) continue;

              int x = faces[0].boundingBox.left.toInt();
              int y = faces[0].boundingBox.top.toInt();
              int w = faces[0].boundingBox.width.toInt();
              int h = faces[0].boundingBox.height.toInt();

              var bytes = await File(image.path).readAsBytes();

              img.Image faceCrop = img.decodeImage(bytes) as img.Image;

              faceCrop = img.copyCrop(faceCrop, x, y, w, h);
              faceCrop = img.copyResize(faceCrop, height: 48, width: 48);
              // faceCrop = img.grayscale(faceCrop);

              Interpreter interpreter =
                  await Interpreter.fromAsset("model.tflite");

              var _inputShape = interpreter.getInputTensor(0).shape;
              var _outputShape = interpreter.getOutputTensor(0).shape;
              var _inputType = interpreter.getInputTensor(0).type;
              var _outputType = interpreter.getOutputTensor(0).type;

              var _outputBuffer =
                  TensorBuffer.createFixedSize(_outputShape, _outputType);

              var _inputImage = TensorImage(_inputType);
              _inputImage.loadImage(faceCrop);
              _inputImage = ImageProcessorBuilder()
                  .add(ResizeWithCropOrPadOp(
                    _inputImage.height,
                    _inputImage.width,
                  ))
                  .add(ResizeOp(_inputShape[1], _inputShape[2],
                      ResizeMethod.NEAREST_NEIGHBOUR))
                  .build()
                  .process(_inputImage);

              var rgb = _inputImage.buffer.asFloat32List();
              Float32List gray = Float32List(rgb.length ~/ 3);

              for (var i = 0; i < gray.length; ++i) {
                gray[i] = (0.299 * rgb[i * 3] +
                        0.587 * rgb[i * 3 + 1] +
                        0.114 * rgb[i * 3 + 2]) /
                    255;
              }

              interpreter.run(
                gray.buffer,
                _outputBuffer.getBuffer(),
              );

              List<double> pred = _outputBuffer.getDoubleList();

              print(pred);

              int index = 0;

              for (var i = 1; i < pred.length; ++i) {
                if (pred[index] < pred[i]) index = i;
              }

              print(mapper[index]);

              Navigator.pop(context, mapper[index]);

            } catch (e) {
              print(e);
            }
            break;
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
