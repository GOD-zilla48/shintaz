import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/ai_service.dart';  // AI model logic
import 'result_screen.dart';          // Result display
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AIService _aiService = AIService(); // AI Service instance
  bool _isModelLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadAIModel(); // Load TFLite model on start
  }

  // Load the AI model when app opens
  Future<void> _loadAIModel() async {
    try {
      await _aiService.loadModel();
      if (mounted) {
        setState(() {
          _isModelLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load AI model: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isModelLoading = false;
        });
      }
    }
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    if (_isModelLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI model is loading...')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _processImageWithAI(imageFile);
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    if (_isModelLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI model is loading...')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _processImageWithAI(imageFile);
    }
  }

  // Process image with AI and show result
  Future<void> _processImageWithAI(File imageFile) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Analyzing your digit...'),
            ],
          ),
        ),
      );

      // Run AI prediction
      final result = await _aiService.predictDigit(imageFile);
      
      // Close loading
      Navigator.pop(context);
      
      // Navigate to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imageFile: imageFile,
            predictedDigit: result['digit'],
            confidence: result['confidence'],
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Shintaz'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile menu')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Card(
                color: Colors.grey.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.design_services,
                          size: 40,
                          color: Color(0xFF9C27B0),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to Shintaz!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isModelLoading 
                            ? 'Loading AI model...' 
                            : 'Your AI companion is ready to assist you',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Feature Cards
              const Text(
                'Explore Shintaz',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // AI Assistant Card (unchanged)
              Card(
                color: Colors.grey.shade800,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: Color(0xFF9C27B0),
                      size: 30,
                    ),
                  ),
                  title: const Text(
                    'AI Assistant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: const Text(
                    'Intelligent assistance for your tasks',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('AI Assistant feature coming soon!')),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // ✨ DIGIT CLASSIFIER CARD - FULLY FUNCTIONAL! ✨
              Card(
                color: Colors.grey.shade800,
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BCD4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.numbers,
                      color: Color(0xFF00BCD4),
                      size: 30,
                    ),
                  ),
                  title: const Text(
                    'Digit Classifier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    _isModelLoading 
                        ? 'Loading AI model...' 
                        : 'AI-powered handwritten digit recognition (99% accuracy)',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                  children: [
                    // Camera & Gallery Options
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Camera Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isModelLoading ? null : _pickImageFromCamera,
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              label: const Text(
                                'Take Photo',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00BCD4),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Gallery Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _isModelLoading ? null : _pickImageFromGallery,
                              icon: const Icon(Icons.photo_library, color: Color(0xFF00BCD4)),
                              label: Text(
                                'Choose from Gallery',
                                style: TextStyle(color: _isModelLoading 
                                    ? Colors.white54 
                                    : const Color(0xFF00BCD4)),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFF00BCD4)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          
                          if (_isModelLoading)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Loading AI Model...',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Settings Card (unchanged)
              Card(
                color: Colors.grey.shade800,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Color(0xFFE91E63),
                      size: 30,
                    ),
                  ),
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: const Text(
                    'Manage your preferences',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings feature coming soon!')),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Logout Button (unchanged)
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aiService.dispose(); // Clean up AI service
    super.dispose();
  }
}