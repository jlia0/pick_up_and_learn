import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pick_up_and_learn/param.dart';
import 'package:pick_up_and_learn/unlock.dart';

String lan_from = 'en';
String lan_to = 'zh-cn';
List<int> _colorseq = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'CPSC 581 Project 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pick-Up-And-Learn-To-Unlock'),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  var languages = <String>['en', 'zh-cn', 'es', 'ru', 'fr', 'it', 'ar']
      .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  List<Widget> _sequence() {
    List<Widget> widgets = [];
    _colorseq.forEach((color) {
      widgets.add(color == 0
          ? const Icon(
              Icons.circle,
              size: 25,
              color: Colors.red,
            )
          : const Icon(
              Icons.circle,
              size: 25,
              color: Colors.blue,
            ));
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your daily average pickups is 80 times',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Please select language pair',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: lan_from,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      lan_from = newValue!;
                    });
                  },
                  items: languages,
                ),
                const SizedBox(
                  width: 50,
                ),
                DropdownButton<String>(
                  value: lan_to,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      lan_to = newValue!;
                    });
                  },
                  items: languages,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Please enter your color sequence',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _colorseq.add(0);
                    });
                  },
                  icon: const Icon(Icons.circle),
                  color: Colors.red,
                  iconSize: 50,
                ),
                const SizedBox(
                  width: 50,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _colorseq.add(1);
                    });
                  },
                  icon: const Icon(Icons.circle),
                  color: Colors.blue,
                  iconSize: 50,
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sequence(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Param param = Param(lan_from, lan_to, _colorseq);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UnlockPage(
                        param: param,
                      )));
        },
        tooltip: 'Lock',
        child: const Icon(Icons.lock),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
