import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 1),

              // TEKS HEADLINE DI ATAS GAMBAR
              Text(
                "Capture Your Ideas, Anytime, Anywhere.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
              SizedBox(height: 50 ),

              // GAMBAR
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'gambar/foto1.png',
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 24),

              // TEKS PENJELASAN DI BAWAH GAMBAR
              Text(
                "With our app, you can seamlessly jot down your thoughts, ideas, and to-dos wherever you are. Start organizing your life today!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),

              Spacer(flex: 2),

              // BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // FOOTER TEXT
              Text(
                "Your ideas matter. Let's make them count!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}