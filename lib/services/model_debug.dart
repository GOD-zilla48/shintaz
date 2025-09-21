import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class ModelDebugger {
  static Future<void> debugModel() async {
    try {
      // Load model
      final modelBytes = await rootBundle.load('assets/models/digit_model.tflite');
      final interpreter = await Interpreter.fromBuffer(modelBytes.buffer.asUint8List());
      
      print('=== MODEL DEBUG INFO ===');
      print('Model loaded successfully!');
      
      // Get input details
      final inputTensor = interpreter.getInputTensor(0);
      print('Input shape: ${inputTensor.shape}');
      print('Input type: ${inputTensor.type}');
      print('Input name: ${inputTensor.name}');
      
      // Get output details
      final outputTensor = interpreter.getOutputTensor(0);
      print('Output shape: ${outputTensor.shape}');
      print('Output type: ${outputTensor.type}');
      print('Output name: ${outputTensor.name}');
      
      interpreter.close();
      print('=== DEBUG COMPLETE ===');
      
    } catch (e) {
      print('=== MODEL DEBUG FAILED ===');
      print('Error: $e');
    }
  }
}