import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() => runApp(CatDogClassifierApp());

class CatDogClassifierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ClassifierScreen(),
    );
  }
}

class ClassifierScreen extends StatefulWidget {
  @override
  _ClassifierScreenState createState() => _ClassifierScreenState();
}

class _ClassifierScreenState extends State<ClassifierScreen> {
  late Interpreter interpreter;
  Uint8List? imageBytes;
  String? classificationResult;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/model.tflite');
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Load the image asynchronously, and only then call setState
      final imageBytes = Uint8List.fromList(await pickedImage.readAsBytes());
      setState(() {
        this.imageBytes = imageBytes;
      });

      // Classify the image after setting the state
      await classifyImage();
    }
  }


  Future<void> classifyImage() async {
    // Decode and resize the image
    final originalImage = img.decodeImage(imageBytes!)!;
    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);

    // Prepare the input tensor
    var input = List.generate(
      1,
          (i) => List.generate(
        224,
            (j) => List.generate(
          224,
              (k) => List<double>.filled(3, 0),
        ),
      ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        int pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = (img.getRed(pixel) / 255.0); // Red
        input[0][y][x][1] = (img.getGreen(pixel) / 255.0); // Green
        input[0][y][x][2] = (img.getBlue(pixel) / 255.0); // Blue
      }
    }

    // Define output shape based on the model's expected output (1, 2)
    var output = List.generate(1, (i) => List.generate(2, (j) => 0.0));

    // Run the model
    interpreter.run(input, output);

    // Retrieve probabilities for each class
    double catProbability = output[0][0];
    double dogProbability = output[0][1];

    setState(() {
      classificationResult = catProbability > dogProbability
          ? "It's a Cat!"
          : "It's a Dog!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat vs Dog Classifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageBytes != null
                ? Image.memory(imageBytes!)
                : Text("No image selected"),
            SizedBox(height: 20),
            classificationResult != null
                ? Text(
              classificationResult!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick an Image'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    interpreter.close();
    super.dispose();
  }
}
