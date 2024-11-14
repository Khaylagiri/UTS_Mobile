import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KonversiMataUangPage extends StatefulWidget {
  @override
  _KonversiMataUangPageState createState() => _KonversiMataUangPageState();
}

class _KonversiMataUangPageState extends State<KonversiMataUangPage> {
  final TextEditingController _saldoController = TextEditingController(text: "Rp 0");
  String? _selectedCurrency;
  double _convertedAmount = 0.0;

  final List<String> _currencies = ['USD', 'EUR', 'JPY', 'GBP', 'IDR'];

  // Fungsi untuk mengonversi saldo ke mata uang yang dipilih
  void _convertCurrency() {
    double saldo = _parseRupiahToDouble(_saldoController.text);
    if (_selectedCurrency != null) {
      double exchangeRate;
      switch (_selectedCurrency) {
        case 'USD':
          exchangeRate = 0.000067;
          break;
        case 'EUR':
          exchangeRate = 0.000058;
          break;
        case 'JPY':
          exchangeRate = 0.0074;
          break;
        case 'GBP':
          exchangeRate = 0.000048;
          break;
        case 'IDR':
          exchangeRate = 1.0;
          break;
        default:
          exchangeRate = 1.0;
      }
      setState(() {
        _convertedAmount = saldo * exchangeRate;
      });
    }
  }

  // Fungsi untuk memformat input ke dalam format Rupiah tanpa desimal
  void _updateRupiahText(String value) {
    final double? saldo = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (saldo != null) {
      String formatted = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 00).format(saldo);
      _saldoController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      _convertCurrency(); // Konversi ulang saldo setelah format
    }
  }

  // Fungsi untuk mengubah teks Rupiah ke double untuk perhitungan
  double _parseRupiahToDouble(String text) {
    String number = text.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(number) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konversi Mata Uang',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0255A3),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _saldoController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Masukan Jumlah Uang',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Color(0xFFF8F8F8), // Warna latar belakang sesuai gambar
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _updateRupiahText(value); // Format angka ke Rupiah secara otomatis
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              items: _currencies
                  .map((currency) => DropdownMenuItem(
                        child: Text(currency),
                        value: currency,
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Pilih Mata Uang',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value;
                });
                _convertCurrency();
              },
            ),
            SizedBox(height: 16),
            Text(
              'Hasil Konversi: $_convertedAmount ${_selectedCurrency ?? ''}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
