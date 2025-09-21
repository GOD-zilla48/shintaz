import 'dart:typed_data';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class AIService {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/digit_model.tflite');
      _isLoaded = true;
      print('✅ AI Model loaded successfully');
      
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      print('📏 Model input shape: $inputShape');
      print('📏 Model output shape: $outputShape');
      
    } catch (e) {
      print('❌ Error loading AI model: $e');
      rethrow;
    }
  }

  bool get isModelLoaded => _isLoaded;

  // FIXED: Proper type casting for double values
  List<List<List<List<double>>>> _preprocessImage(File imageFile) {
    final imageBytes = imageFile.readAsBytesSync();
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Cannot decode image');
    }

    final resized = img.copyResize(image, width: 28, height: 28);
    final gray = img.grayscale(resized);

    // Create exactly [1, 28, 28, 1] tensor with explicit double casting
    final input = List.generate(1, (batch) =>
      List.generate(28, (y) =>
        List.generate(28, (x) {
          final luminance = img.getLuminance(gray.getPixel(x, y));
          final normalized = (luminance as num).toDouble();  // ← FIXED: Explicit double cast
          return [normalized];  // Single channel, 0.0-1.0
        })
      )
    );

    print('🔍 Input tensor created: [1, 28, 28, 1]');
    return input;
  }

  Future<Map<String, dynamic>> predictDigit(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('AI Model not loaded');
    }

    final input = _preprocessImage(imageFile);
    
    // Create output tensor [1, 10] to match model
    final output = List.generate(1, (batch) => List.filled(10, 0.0));

    try {
      print('🚀 Running inference...');
      _interpreter!.run(input, output);
      
      // Extract predictions from output[0]
      final predictions = output[0] as List<double>;
      
      // Find highest probability
      double maxConfidence = predictions[0];
      int predictedDigit = 0;
      for (int i = 1; i < 10; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          predictedDigit = i;
        }
      }

      final confidencePercent = (maxConfidence * 100).toStringAsFixed(1);
      print('🎯 SUCCESS! digit=$predictedDigit, confidence=$confidencePercent%');
      
      return {
        'digit': predictedDigit,
        'confidence': confidencePercent,
      };
      
    } catch (e) {
      print('❌ Inference FAILED: $e');
      throw Exception('Prediction failed: $e');
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}