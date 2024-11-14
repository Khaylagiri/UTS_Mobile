import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

import 'package:finance_manager/screens/menu_pemasukan.dart';
import 'package:finance_manager/screens/menu_pengeluaran.dart';
import 'package:finance_manager/screens/menu_mutasi.dart';
import 'package:finance_manager/screens/konversi_mata_uang.dart';
import 'package:finance_manager/screens/tentang_aplikasi.dart';
import 'package:finance_manager/screens/login_page.dart'; // Import halaman login

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double saldo = 0; // Variabel untuk menyimpan saldo
  bool isSaldoVisible = false; // Status untuk menampilkan saldo
  final List<Map<String, dynamic>> mutasiList = []; // Daftar mutasi transaksi

  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadSaldo(); // Memuat saldo saat aplikasi dibuka
  }

  Future<void> _loadSaldo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      saldo = prefs.getDouble('saldo') ?? 0; // Mengambil saldo dari SharedPreferences
      isSaldoVisible = prefs.getBool('isSaldoVisible') ?? false; // Mengambil status visibilitas saldo
    });
  }

  Future<void> _saveSaldo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saldo', saldo); // Menyimpan saldo ke SharedPreferences
    await prefs.setBool('isSaldoVisible', isSaldoVisible); // Menyimpan status visibilitas saldo
  }

  void updateSaldo(double amount, String description, DateTime date) {
    setState(() {
      saldo += amount; // Update saldo dengan nilai baru
      isSaldoVisible = true; // Tampilkan saldo
      mutasiList.add({
        'type': 'pemasukan',
        'description': description,
        'date': date,
        'amount': amount,
      }); // Menambahkan mutasi pemasukan
    });
    _saveSaldo(); // Simpan saldo dan daftar mutasi
  }

  void deductSaldo(double amount, String description, DateTime date) {
    setState(() {
      saldo -= amount; // Mengurangi saldo dengan pengeluaran
      if (saldo < 0) saldo = 0; // Pastikan saldo tidak negatif
      mutasiList.add({
        'type': 'pengeluaran',
        'description': description,
        'date': date,
        'amount': amount,
      }); // Menambahkan mutasi pengeluaran
    });
    _saveSaldo(); // Simpan saldo dan daftar mutasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF0255A3),
        title: Text(
          'Finance Manager',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Navigasi ke halaman login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Bagian header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 40, color: Color(0xFF638889)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'WELCOME,\nKHAYLA GIRI FITRIANI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Box saldo
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF0255A3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Menampilkan saldo jika isSaldoVisible true
                      Text(
                        isSaldoVisible
                            ? _currencyFormat.format(saldo)
                            : 'Rp *******',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      // Tombol untuk menampilkan atau menyembunyikan saldo
                      IconButton(
                        icon: Icon(
                          isSaldoVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isSaldoVisible = !isSaldoVisible; // Toggle visibilitas saldo
                          });
                          _saveSaldo(); // Simpan status visibilitas saldo
                        },
                      ),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Grid menu fitur
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildFeatureIcon(
                    context,
                    icon: Icons.add_circle_outline,
                    label: 'Pemasukan',
                    onTap: () async {
                      // Memperbaiki pemanggilan MenuPemasukanPage dengan parameter lengkap
                      double? amount = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPemasukanPage(
                            onPemasukanSimpan: (double amount, String description, DateTime date) {
                              updateSaldo(amount, description, date); // Memperbarui saldo dan daftar mutasi
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  _buildFeatureIcon(
                    context,
                    icon: Icons.remove_circle_outline,
                    label: 'Pengeluaran',
                    onTap: () async {
                      // Memperbaiki pemanggilan MenuPengeluaranPage dengan parameter lengkap
                      double? amount = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPengeluaranPage(
                            saldo: saldo,
                            onPengeluaranSimpan: (double amount, String description, DateTime date) {
                              deductSaldo(amount, description, date); // Mengurangi saldo dan menambah mutasi
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  _buildFeatureIcon(
                    context,
                    icon: Icons.receipt_long,
                    label: 'Mutasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuMutasiPage(mutasiList: mutasiList), // Mengirim mutasiList ke MenuMutasiPage
                        ),
                      );
                    },
                  ),
                  _buildFeatureIcon(
                    context,
                    icon: Icons.currency_exchange,
                    label: 'Konversi\nMata Uang',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KonversiMataUangPage()),
                      );
                    },
                  ),
                  _buildFeatureIcon(
                    context,
                    icon: Icons.info_outline,
                    label: 'Tentang\nAplikasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TentangAplikasiPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Color(0xFF638889)),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0255A3),
            ),
          ),
        ],
      ),
    );
  }
}
