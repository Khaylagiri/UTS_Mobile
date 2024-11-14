import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class MenuPengeluaranPage extends StatefulWidget {
  final double saldo;
  final Function(double, String, DateTime) onPengeluaranSimpan; // Mengubah parameter

  MenuPengeluaranPage({required this.saldo, required this.onPengeluaranSimpan});

  @override
  _MenuPengeluaranPageState createState() => _MenuPengeluaranPageState();
}

class _MenuPengeluaranPageState extends State<MenuPengeluaranPage> {
  final MoneyMaskedTextController _pengeluaranController = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: '.',
    leftSymbol: 'Rp ',
    precision: 0,
    initialValue: 0.00,
  );
  final TextEditingController _itemController = TextEditingController();

  late double saldoTerkini;

  @override
  void initState() {
    super.initState();
    saldoTerkini = widget.saldo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengeluaran',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0255A3),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Color(0xFFF6F1F5),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Anda: Rp${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(saldoTerkini)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Sumber pengeluaran',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pengeluaranController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Pengeluaran',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEAE2F1),
                  foregroundColor: Color(0xFF6A4C93),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                onPressed: () {
                  double pengeluaran = _pengeluaranController.numberValue;
                  String item = _itemController.text.trim();

                  if (pengeluaran > 0 && item.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Konfirmasi Pengeluaran'),
                          content: Text(
                            'Apakah Anda yakin ingin menyimpan pengeluaran ini?\n\n'
                            'Item: $item\n'
                            'Pengeluaran: Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(pengeluaran)}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                setState(() {
                                  saldoTerkini -= pengeluaran;
                                });

                                // Mengirimkan data pengeluaran lengkap
                                widget.onPengeluaranSimpan(pengeluaran, item, DateTime.now());

                                _pengeluaranController.updateValue(0.00);
                                _itemController.clear();
                              },
                              child: Text('Ya'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Masukkan nama item dan jumlah pengeluaran yang valid.')),
                    );
                  }
                },
                child: Text('Simpan Pengeluaran'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
