import 'dart:math';

import 'package:flutter/material.dart';
import 'piatti.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPiattoPage extends StatefulWidget {
  final Piatto piatto;

  const EditPiattoPage({Key? key, required this.piatto}) : super(key: key);

  @override
  _EditPiattoPageState createState() => _EditPiattoPageState();
}

class _EditPiattoPageState extends State<EditPiattoPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController thumbnailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.piatto.name);
    priceController =
        TextEditingController(text: widget.piatto.price.toString());
    descriptionController =
        TextEditingController(text: widget.piatto.description);
    thumbnailController = TextEditingController(text: widget.piatto.thumbnail);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    thumbnailController.dispose();

    super.dispose();
  }

  Future<void> editPiatto(String id) async {
    final url = Uri.parse("http://192.168.1.68:3000/piatti/$id");
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        // Usa jsonEncode per convertire la mappa in una stringa JSON
        'product': nameController.text,
        'description': descriptionController.text,
        'price': priceController.text,
        'thumbnail': thumbnailController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final updatedPiatto = Piatto(
        id: widget.piatto.id,
        name: nameController.text,
        description: descriptionController.text,
        price: priceController.text,
        thumbnail: thumbnailController.text,
      );

      Navigator.pop(context, updatedPiatto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Prodotto modificato con successo!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.blue),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Errore durante la modifica del prodotto: $e'),
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.blue)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 58, 118, 166),
      ),
      backgroundColor: const Color.fromARGB(255, 156, 190, 218),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nome prodotto"),
              style: TextStyle(color: Color.fromARGB(255, 58, 118, 166)),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Prezzo"),
              style: TextStyle(color: Color.fromARGB(255, 58, 118, 166)),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Descrizione"),
              style: TextStyle(color: Color.fromARGB(255, 58, 118, 166)),
              maxLines: 4,
            ),
            TextField(
              controller: thumbnailController,
              decoration: InputDecoration(labelText: "URL immagine prodotto"),
              style: TextStyle(color: Color.fromARGB(255, 58, 118, 166)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => editPiatto(widget.piatto.id),
              child: Text("Salva modifiche"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 58, 118, 166),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
