import '../main.dart';
import 'package:flutter/material.dart';
// import 'editproductpage.dart';
import 'package:page_transition/page_transition.dart';
import './piatti.dart';

class PiattoScreen extends StatefulWidget {
  final Piatto piatto;

  PiattoScreen(this.piatto);

  @override
  _PiattoScreenState createState() => _PiattoScreenState();
}

class _PiattoScreenState extends State<PiattoScreen> {
  late Piatto currentPiatto;

  @override
  void initState() {
    super.initState();
    currentPiatto = widget.piatto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () async {
              // await Navigator.push(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.rightToLeftWithFade,
              //         child: ItemsScreen()));
              // setState(() {});
            },
          ),
          title: Text(currentPiatto.name,
              style: TextStyle(color: Colors.blue)),
          actions: [
            IconButton(
              icon: Icon(Icons.edit,
                  color: const Color.fromARGB(255, 196, 235, 40)),
              onPressed: () async {
              //   final updated = await Navigator.push(
              //     context,
              //     PageTransition(
              //       type: PageTransitionType.rightToLeftWithFade,
              //       duration: Duration(milliseconds: 400),
              //       child: EditProductPage(product: currentPiatto),
              //     ),
              //   );

              //   if (updated != null && updated is Piatto) {
              //     setState(() {
              //       currentPiatto = updated;
              //     });
              //   }
              },
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                // final updated = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         EditProductPage(product: currentProduct),
                //   ),
                // );

                // if (updated != null && updated is Product) {
                //   setState(() {
                //     currentProduct = updated;
                //   });
                // }
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 58, 118, 166),
        ),
        backgroundColor: Color.fromARGB(255, 156, 190, 218),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      currentPiatto.thumbnail,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Prezzo: ${currentPiatto.price}€',
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 27, 95, 150)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Descrizione: ' + currentPiatto.description,
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
