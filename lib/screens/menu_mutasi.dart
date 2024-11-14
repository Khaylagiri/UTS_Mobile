import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuMutasiPage extends StatefulWidget {
  final List<Map<String, dynamic>> mutasiList;

  MenuMutasiPage({required this.mutasiList});

  @override
  _MenuMutasiPageState createState() => _MenuMutasiPageState();
}

class _MenuMutasiPageState extends State<MenuMutasiPage> {
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mutasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0255A3),
      ),
      body: widget.mutasiList.isEmpty
          ? Center(child: Text('Belum ada mutasi'))
          : ListView.builder(
              itemCount: widget.mutasiList.length,
              itemBuilder: (context, index) {
                final mutasi = widget.mutasiList[index];
                bool isPemasukan = mutasi['type'] == 'pemasukan';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Icon(
                      isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isPemasukan ? Colors.green : Colors.red,
                    ),
                    title: Text(mutasi['description']),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(mutasi['date'])),
                    trailing: Text(
                      '${isPemasukan ? '+' : '-'}${_currencyFormat.format(mutasi['amount'])}',
                      style: TextStyle(
                        color: isPemasukan ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
