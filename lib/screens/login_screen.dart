import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Form controllers and state
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Customizable variables for Shintaz
  static const List<String> animatedHeadings = [
    'Welcome to Shintaz',
    'Your AI Companion',
    'Sign in to continue',
  ];
  static const Color primaryColor = Color(0xFF9C27B0); // Purple for border and Sign Up
  static const Color secondaryColor = Color(0xFFD81B60); // Red/Pink for Sign In
  static const Color textColor = Colors.white;
  static const Color waveColor1 = Color(0xFF9C27B0); // Purple wave
  static const Color waveColor2 = Color(0xFFE91E63); // Pink wave
  static const Color waveColor3 = Color(0xFF00BCD4); // Blue wave
  static const double animationSpeed = 2.0; // Seconds per cycle
  static const String backgroundImage = 'assets/login_background.png';

  // Sign In Validation and Logic
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API authentication
    await Future.delayed(const Duration(seconds: 2));

    // Simple mock authentication (replace with your actual auth logic)
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Mock validation - replace with your backend API call
    if (email == 'test@shinta.com' && password == 'password123') {
      setState(() {
        _isLoading = false;
      });

      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shintaz Logo Circle
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor,
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated Wave Pattern
                          Positioned.fill(
                            child: CustomPaint(
                              painter: WavePainter(
                                waveColor1: waveColor1,
                                waveColor2: waveColor2,
                                waveColor3: waveColor3,
                                animationValue: _animation.value,
                              ),
                            ),
                          ),
                          // Your Logo in center
                          ClipOval(
                            child: Image.asset(
                              'assets/shintaz_logo.png', // Your custom logo
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.design_services, // Your brand icon
                                    size: 80,
                                    color: primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Animated Heading
                    SizedBox(
                      width: 280,
                      child: AnimatedTextKit(
                        animatedTexts: animatedHeadings.map((text) {
                          return TypewriterAnimatedText(
                            text,
                            textStyle: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 1.2,
                            ),
                            speed: Duration(milliseconds: (animationSpeed * 500).toInt()),
                          );
                        }).toList(),
                        totalRepeatCount: 1000,
                        pause: Duration(milliseconds: (animationSpeed * 1000).toInt()),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Sign In Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: Colors.white70),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.grey.shade800,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF9C27B0),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: Icon(Icons.email, color: Colors.white70),
                              suffixIcon: _emailController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, color: Colors.white70),
                                      onPressed: () => _emailController.clear(),
                                    )
                                  : null,
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white70),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.grey.shade800,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF9C27B0),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: Icon(Icons.lock, color: Colors.white70),
                              suffixIcon: _passwordController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, color: Colors.white70),
                                      onPressed: () => _passwordController.clear(),
                                    )
                                  : null,
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 8),
                          
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Forgot Password feature coming soon!'),
                                    backgroundColor: Color(0xFF9C27B0),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Signing In...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () => _handleSignUp(context),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom Painter for Animated Wave Pattern
class WavePainter extends CustomPainter {
  final Color waveColor1;
  final Color waveColor2;
  final Color waveColor3;
  final double animationValue;

  WavePainter({
    required this.waveColor1,
    required this.waveColor2,
    required this.waveColor3,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [waveColor1.withOpacity(0.3), Colors.transparent],
        center: Alignment.center,
        radius: animationValue % 2 + 0.5,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [waveColor2.withOpacity(0.2), Colors.transparent],
        center: Alignment.centerLeft,
        radius: (animationValue % 2 + 1.5) % 2 + 0.3,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final paint3 = Paint()
      ..shader = RadialGradient(
        colors: [waveColor3.withOpacity(0.25), Colors.transparent],
        center: Alignment.topRight,
        radius: ((animationValue % 2) + 1.0) % 2 + 0.4,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.8, paint1);
    canvas.drawCircle(center, radius * 0.6, paint2);
    canvas.drawCircle(center, radius * 0.4, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}