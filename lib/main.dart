import 'package:dictionary_app_firebase/Classes/Kelimeler.dart';
import 'package:dictionary_app_firebase/Screens/DetaySayfa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool aramaYapiliyorMu = false;
  String arananKelime = "";

  var refKelimeler = FirebaseDatabase.instance.ref().child("kelimeler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: aramaYapiliyorMu ? TextField(
              decoration: InputDecoration(
                hintText: "Arama Yap",
              ),
              onChanged: (kelime){
                setState(() {
                  arananKelime = kelime;
                });
              },
            )
            :Text("Sözlük Uygulaması"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = false;
                arananKelime = "";
              });
            },
          )
              :IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refKelimeler.onValue,
        builder: (context,event){
          if(event.hasData){
            var kelimelerListesi = <Kelimeler>[];
            var gelenDegerler = event.data!.snapshot.value as dynamic;
            if(gelenDegerler != null){
              gelenDegerler.forEach((key,nesne){
                var gelenKelime = Kelimeler.fromJson(key, nesne);
                if(aramaYapiliyorMu){
                  if(gelenKelime.ingilizce.contains(arananKelime)){
                    kelimelerListesi.add(gelenKelime);
                  }
                }else{
                  kelimelerListesi.add(gelenKelime);
                }
              });
            }
            return ListView.builder(
              itemCount: kelimelerListesi.length,
              itemBuilder: (context,index){
                var kelime = kelimelerListesi[index];
                return GestureDetector(
                  child: SizedBox(
                    height: 70,
                    child: Card(
                      color: Colors.lightGreenAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Text("${kelime.ingilizce}",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 ,), textAlign: TextAlign.center,),
                          ),
                          Expanded(
                              child: Text("${kelime.turkce}",style: TextStyle(fontSize: 17),textAlign: TextAlign.center,)
                          ),
                          Icon(Icons.arrow_circle_right),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => KelimeDetay(kelime)));
                  },
                );
              },
            );
          }else{
            return Center();
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
