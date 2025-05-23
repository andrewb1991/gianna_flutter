import 'package:flutter/material.dart';
import 'package:gianna_flutter/src/piatti.dart';
import 'package:page_transition/page_transition.dart';
import 'package:gianna_flutter/src/products_screen.dart';
import './src/addproductpage.dart';
import './src/api_service.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/login_new.dart';

void main() async {
  // await dotenv.load(fileName: ".env"); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'errStore',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => ItemsScreen(),
        '/product': (context) {
          final piatto = ModalRoute.of(context)!.settings.arguments as Piatto;
          return PiattoScreen(piatto);
        },
      },
      theme: ThemeData(
        fontFamily: 'GT Maru',
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: ItemsScreen(),
    );
  }
}



Future<void> _confirmLogout(BuildContext context) async {
  bool? shouldLogout = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Conferma Logout"),
        content: Text("Sei sicuro di voler uscire?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Annulla
            child: Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Conferma
            child: Text("Logout"),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Rimuove il token salvato

    // Naviga alla schermata di login e rimuove la Home dallo stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class ItemsScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading:
      IconButton(
              icon: Icon(Icons.add, color: Colors.greenAccent),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      childCurrent: this,
                      child: AddProductPage(),
                    ));
              }),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("errSmart", style: TextStyle(color: Colors.blue)),
        backgroundColor: const Color.fromARGB(255, 58, 118, 166),
        actions: [
          IconButton(
            icon: Icon(Icons.search), onPressed: () => null,
            // onPressed: () => _startSearch(context),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: const Color.fromARGB(255, 202, 72, 62)),
            tooltip: 'logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 156, 190, 218),
      body: FutureBuilder<List<Piatto>>(
        future: apiService.fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Errore: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nessun dato disponibile"));
          } else {
            final items = snapshot.data!;

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Conferma Eliminazione"),
                          content: Text(
                              "Sei sicuro di voler eliminare questo prodotto?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Annulla"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Elimina",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) async {
                    try {
                      await apiService.deleteProduct(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Prodotto eliminato con successo"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.blue),
                      );
                      items.removeAt(index); // Rimuove dalla lista
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Errore durante l'eliminazione: $e"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.blue),
                      );
                    }
                  },
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeftJoined,
                          childCurrent: this,
                          child: PiattoScreen(items[index]),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    leading: Image.network(
                      item.thumbnail,
                      width: 50,
                      height: 50,
                      fit: BoxFit.scaleDown,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 50);
                      },
                    ),
                    title: Text(item.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Categoria: ${item.description}"),
                        Text("Prezzo: ${item.price} €"),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

