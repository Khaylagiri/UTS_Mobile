import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class MenuPemasukanPage extends StatefulWidget {
  final Function(double, String, DateTime) onPemasukanSimpan;

  MenuPemasukanPage({required this.onPemasukanSimpan});

  @override
  _MenuPemasukanPageState createState() => _MenuPemasukanPageState();
}

class _MenuPemasukanPageState extends State<MenuPemasukanPage> {
  final MoneyMaskedTextController _controller = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: '.',
    leftSymbol: 'Rp ',
    precision: 0,
    initialValue: 0.00,
  );
  final TextEditingController _sumberController = TextEditingController();
  double _saldo = 0;

  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _saldo = prefs.getDouble('saldo') ?? 0;
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saldo', _saldo);
  }

  void _tambahPemasukan() async {
    double pemasukan = _controller.numberValue;
    String sumber = _sumberController.text;

    if (pemasukan > 0 && sumber.isNotEmpty) {
      bool? confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Konfirmasi Pemasukan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Apakah Anda yakin ingin menambahkan pemasukan ini?'),
                SizedBox(height: 10),
                Text('Sumber Penghasilan: $sumber'),
                Text('Jumlah Pemasukan: ${_currencyFormat.format(pemasukan)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yakin', style: TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        DateTime timestamp = DateTime.now();
        setState(() {
          _saldo += pemasukan;
          widget.onPemasukanSimpan(pemasukan, sumber, timestamp);
        });
        _saveData();
        _controller.updateValue(0.00); // Reset the controller value to zero
        _sumberController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pemasukan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0255A3),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Anda: ${_currencyFormat.format(_saldo)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _sumberController,
              decoration: InputDecoration(
                labelText: 'Sumber Penghasilan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Pemasukan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tambahPemasukan,
              child: Text('Simpan Pemasukan'),
            ),
          ],
        ),
      ),
    );
  }
}
