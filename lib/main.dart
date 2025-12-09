import 'package:flutter/material.dart';
import 'package:navigator_5d/beranda.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bgController1;
  late AnimationController _bgController2;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _bgController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _bgController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bgController1.dispose();
    _bgController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background Layer 1
          AnimatedBuilder(
            animation: _bgController1,
            builder: (context, child) {
              final angle1 = _bgController1.value * 2 * math.pi;
              return Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(
                        math.cos(angle1) * 0.5,
                        math.sin(angle1) * 0.3,
                      ),
                      radius: 0.8 + _bgController1.value * 0.4,
                      colors: [
                        Colors.red.shade400,
                        Colors.orange.shade500,
                        Colors.red.shade600,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Animated Background Layer 2
          AnimatedBuilder(
            animation: _bgController2,
            builder: (context, child) {
              final angle2 = _bgController2.value * 2 * math.pi;
              return Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(
                        math.sin(angle2) * 0.4,
                        math.cos(angle2) * 0.5,
                      ),
                      radius: 1.0,
                      colors: [
                        Colors.orange.shade400,
                        Colors.yellow.shade400,
                        Colors.white.withOpacity(0.2),
                        Colors.orange.shade600,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.07,
                        vertical: 20,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo dengan animasi
                              Hero(
                                tag: 'logo',
                                child: Container(
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.shade400.withOpacity(0.5),
                                        blurRadius: 30,
                                        spreadRadius: 8,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/upgris.png',
                                    height: MediaQuery.of(context).size.width * 0.25,
                                  ),
                                ),
                              ),

                              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                              // Judul
                              Text(
                                "Selamat Datang",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.red.shade800.withOpacity(0.5),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Silakan login untuk melanjutkan",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.038,
                                  color: Colors.white.withOpacity(0.95),
                                  letterSpacing: 0.5,
                                  height: 1.4,
                                ),
                              ),

                              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                              // Card Input mobile-optimized
                              Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                ),
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.065),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.97),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.shade500.withOpacity(0.4),
                                      blurRadius: 50,
                                      spreadRadius: 12,
                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Username Field
                                    TextField(
                                      style: TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person_rounded,
                                          color: Colors.red.shade600,
                                          size: 24,
                                        ),
                                        labelText: "Username",
                                        labelStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: Colors.orange.shade300,
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: Colors.red.shade600,
                                            width: 2.5,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                                    // Password Field
                                    TextField(
                                      obscureText: _obscurePassword,
                                      style: TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock_rounded,
                                          color: Colors.red.shade600,
                                          size: 24,
                                        ),
                                        suffixIcon: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: Colors.grey.shade600,
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: Colors.orange.shade300,
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: Colors.red.shade600,
                                            width: 2.5,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 18,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 12),

                                    // Forgot Password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // Handle forgot password
                                        },
                                        child: Text(
                                          "Lupa Password?",
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    // Button Login
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Halaman_Utama(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade600,
                                          foregroundColor: Colors.white,
                                          elevation: 15,
                                          shadowColor: Colors.orange.shade400,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                              // Register Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Belum punya akun? ",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle register
                                    },
                                    child: Text(
                                      "Daftar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
