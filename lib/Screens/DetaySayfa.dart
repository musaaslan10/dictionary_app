import 'package:dictionary_app_firebase/Classes/Kelimeler.dart';
import 'package:flutter/material.dart';

class KelimeDetay extends StatefulWidget {
  Kelimeler kelime;


  KelimeDetay(this.kelime);

  @override
  State<KelimeDetay> createState() => _KelimeDetayState();
}

class _KelimeDetayState extends State<KelimeDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Detaylar"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("${widget.kelime.ingilizce}",style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold , color: Colors.redAccent.shade700),),
            Text("${widget.kelime.turkce}",style: TextStyle(fontSize: 20),),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
