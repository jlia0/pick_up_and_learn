import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pick_up_and_learn/param.dart';
import 'tcard.dart';
import 'package:translator/translator.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';
import 'package:overlay_support/overlay_support.dart';

class UnlockPage extends StatefulWidget {
  const UnlockPage({Key? key, required this.param}) : super(key: key);

  // Declare a field that holds the param.
  final Param param;

  @override
  _UnlockPageState createState() => _UnlockPageState();
}

List<Color> colors = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.amber,
  Colors.cyan,
  Colors.purple,
  Colors.brown,
  Colors.teal,
];

class _UnlockPageState extends State<UnlockPage> {
  TCardController _controller = TCardController();
  int _index = 0;
  List<String> words_f = [];
  List<String> words_t = [];
  String lan_from = '';
  String lan_to = '';
  List<int> seq = [];
  List<bool> answer = [];
  List<Widget> cards = [];
  List<bool> choices = [];
  List<int> choices_seq = [];

  @override
  initState() {
    super.initState();
    Prep();
  }

  Future TranslateWords() async {
    print(widget.param.colorseq);

    final translator = GoogleTranslator();

    lan_from = widget.param.lan_from;
    lan_to = widget.param.lan_to;
    seq = widget.param.colorseq;

    for (var i = 0; i < seq.length; i++) {
      String noun = nouns[Random().nextInt(nouns.length)];
      bool as = Random().nextBool();
      answer.add(as);

      if (lan_from == 'en') {
        words_f.add(noun);
      } else {
        var translation = await translator.translate(noun, to: lan_from);
        words_f.add(translation.text);
      }

      if (as) {
        var translation = await translator.translate(noun, to: lan_to);
        words_t.add(translation.text);
      } else {
        String temp_noun = nouns[Random().nextInt(nouns.length)];
        var translation = await translator.translate(temp_noun, to: lan_to);
        words_t.add(translation.text);
      }
    }

    print(answer);
    print(words_f);
    print(words_t);
  }

  void Prep() async {
    await TranslateWords();

    for (var i = 0; i < words_f.length; i++) {
      cards.add(Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors[Random().nextInt(9)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              words_f[i],
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              words_t[i],
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ));
    }

    setState(() {});
  }

  List<Widget> _sequence() {
    List<Widget> widgets = [];
    for (var i = 0; i < choices_seq.length; i++) {
      int color = choices_seq[i];
      widgets.add(
        color == 0
            ? (choices[i]
                ? const Icon(
                    Icons.add_circle,
                    size: 25,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.remove_circle,
                    size: 25,
                    color: Colors.red,
                  ))
            : (choices[i]
                ? const Icon(
                    Icons.add_circle,
                    size: 25,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.remove_circle,
                    size: 25,
                    color: Colors.blue,
                  )),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              cards.isNotEmpty
                  ? TCard(
                      cards: cards,
                      controller: _controller,
                      onForward: (index, info) {
                        _index = index;

                        print(info.direction);
                        print(_index);

                        switch (info.direction) {
                          case SwipeDirection.TopLeft:
                            choices.add(true);
                            choices_seq.add(0);
                            break;
                          case SwipeDirection.TopRight:
                            choices.add(false);
                            choices_seq.add(0);
                            break;
                          case SwipeDirection.BotLeft:
                            choices.add(true);
                            choices_seq.add(1);
                            break;
                          case SwipeDirection.BotRight:
                            choices.add(false);
                            choices_seq.add(1);
                            break;
                          case SwipeDirection.None:
                            // TODO: Handle this case.
                            break;
                        }

                        if (_index == seq.length) {
                          if (listEquals(choices, answer) &&
                              listEquals(choices_seq, seq)) {
                            showSimpleNotification(
                              const Text("Unlock"),
                              background: Colors.green,
                              position: NotificationPosition.bottom,
                              slideDismissDirection: DismissDirection.down,
                            );

                          } else {
                            setState(() {
                              _index = 0;
                              words_f = [];
                              words_t = [];
                              answer = [];
                              cards = [];
                              choices = [];
                              choices_seq = [];
                            });
                            showSimpleNotification(
                              const Text("Wrong Sequence"),
                              background: Colors.redAccent,
                              position: NotificationPosition.bottom,
                              slideDismissDirection: DismissDirection.down,
                            );
                            setState(() {
                              _index = 0;
                              words_f = [];
                              words_t = [];
                              answer = [];
                              cards = [];
                              choices = [];
                              choices_seq = [];
                              Prep();
                              _controller.reset();
                            });


                          }
                        }

                        setState(() {});
                      },
                      onBack: (index, info) {
                        _index = index;
                        setState(() {});
                      },
                      onEnd: () {
                        print('end');
                      },
                    )
                  : SizedBox(),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _sequence(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
