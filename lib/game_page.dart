import 'package:flutter/material.dart';
import 'package:tictactoe/board.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.size});

  final int size;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text('Tic Tac Toe'),
            actions: [
              PopupMenuButton(
                onSelected: (value) => {
                  if (value == 1)
                    {Navigator.pushReplacementNamed(context, '/game')}
                  else if (value == 2)
                    {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => _Setting(
                                size: size,
                              ))
                    }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 1, child: Text('Restart')),
                  PopupMenuItem(value: 2, child: Text('Change board size'))
                ],
              )
            ],
          ),
          body: Board(size: size),
        ),
        debugShowCheckedModeBanner: false);
  }
}

class _Setting extends StatefulWidget {
  const _Setting({required this.size});

  final int size;
  final double _min = 10;
  final double _max = 100;
  
  @override
  State<_Setting> createState() => _SettingState();
}

class _SettingState extends State<_Setting> {
  late int sliderVal = widget.size;
  late final _textController = TextEditingController(text: sliderVal.toString());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Board Size'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Slider(
          value: sliderVal.toDouble(),
          min: widget._min,
          max: widget._max,
          label: sliderVal.toString(),
          divisions: 9,
          onChanged: (val) => setState(() {
            sliderVal = val.round();
            _textController.text = sliderVal.toString();
          }),
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: _textController,
          onSubmitted: (val) => setState(() {
            sliderVal = int.parse(val);
          }),
        )
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: ((context) => GamePage(size: sliderVal))));
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
