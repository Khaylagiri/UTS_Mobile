import 'package:flutter/material.dart';

class TentangAplikasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentang Aplikasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0255A3),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f7fa), Color(0xFF80deea)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Finance Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004d40),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Aplikasi ini dirancang untuk membantu Anda mengelola keuangan pribadi dengan cara yang lebih mudah dan efisien. '
                    'Dengan antarmuka yang sederhana dan intuitif, Anda dapat mencatat pemasukan dan pengeluaran, '
                    'membuat anggaran, serta mendapatkan laporan keuangan yang jelas dan mudah dipahami.\n\n'
                    'Mari wujudkan kebebasan finansial Anda dan nikmati pengalaman mengelola keuangan yang menyenangkan!',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Image.asset(
                'assets/image.png',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '© 2024 Khayla Giri Fitriani',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
