import 'package:flutter/material.dart';
import 'dart:io';

class ResultScreen extends StatelessWidget {
  final File imageFile;
  final int predictedDigit;
  final String confidence;

  const ResultScreen({
    Key? key,
    required this.imageFile,
    required this.predictedDigit,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          'Prediction Result', 
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // FIXED: Simple pop back to home
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Show captured/selected image
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade800,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade700,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 50),
                            Text('Failed to load image', 
                                 style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Prediction Result Card
              Card(
                color: Colors.grey.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF00BCD4),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'AI Analysis Complete!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Large Digit Display
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BCD4).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00BCD4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$predictedDigit',
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00BCD4),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Prediction Details
                      Column(
                        children: [
                          Text(
                            'Predicted Digit',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$predictedDigit',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_up, 
                                color: Colors.green, 
                                size: 20
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Confidence: $confidence%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // FIXED: Action Buttons - No More Black Screen!
              Row(
                children: [
                  // Back to Home Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // FIXED: Simple pop back to home
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: const Text(
                        'Back to Home',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Analyze Another Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // FIXED: Simple pop back to home for new analysis
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Analyze Another',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BCD4),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}