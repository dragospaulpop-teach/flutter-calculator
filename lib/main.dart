import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo App',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 74,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.deepOrange.shade400,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Colors.deepOrangeAccent.shade100,
                width: 1,
              ),
            ),
            fixedSize: const Size(80, 80),
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: Colors.deepOrangeAccent.shade100,
          dense: true,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _historyScrollController = ScrollController();

  double _result = 0;
  double _firstOperand = 0;
  double _secondOperand = 0;
  String _operation = '';
  bool _dotClicked = false;
  List<Map<String, dynamic>> history = [
    {
      'dot': false,
      'firstOperand': 0,
      'secondOperand': 0,
      'operation': '',
      'result': 0,
    }
  ];

  void compute() {
    setState(() {
      switch (_operation) {
        case '+':
          _result = _firstOperand + _secondOperand;
          break;
        case '-':
          _result = _firstOperand - _secondOperand;
          break;
        case 'x':
          _result = _firstOperand * _secondOperand;
          break;
        case '/':
          _result = _firstOperand / _secondOperand;
          break;
        case '%':
          _result = _firstOperand % _secondOperand;
          break;
        default:
      }

      String resultAsString = _result.toString();
      if (resultAsString.length > 8) {
        _result = double.parse(resultAsString.substring(0, 8));
      } else {
        _result = double.parse(resultAsString);
      }
      _firstOperand = _result;
      _secondOperand = 0;
      _dotClicked = false;
    });
    addHistoryRow();
  }

  void numberClicked(int number) {
    setState(() {
      if (_operation == '') {
        if (_firstOperand.toString().length >= 8) return;
        if (_dotClicked) {
          // add to the decimal part of the number
          String temp = _firstOperand.toString();
          if (!temp.contains('.')) {
            temp = '$temp.';
          }
          _firstOperand = double.parse(temp + number.toString());
        } else {
          // add to the integer part of the number
          _firstOperand = _firstOperand * 10 + number;
        }
        _result = _firstOperand;
      } else {
        if (_secondOperand.toString().length >= 8) return;
        if (_dotClicked) {
          String temp = _secondOperand.toString();
          if (!temp.contains('.')) {
            temp = '$temp.';
          }
          _secondOperand = double.parse(temp + number.toString());
        } else {
          _secondOperand = _secondOperand * 10 + number;
        }
        _result = _secondOperand;
      }
    });
    updateHistoryRow();
  }

  void clearOne() {
    setState(() {
      if (_operation == '') {
        String temp = _firstOperand.toString();
        if (temp.length > 1) {
          temp = temp.substring(0, temp.length - 1);
        }
        _firstOperand = double.parse(temp);
        _result = _firstOperand;
      } else {
        String temp = _secondOperand.toString();
        if (temp.length > 1) {
          temp = temp.substring(0, temp.length - 1);
        }
        _secondOperand = double.parse(temp);
        _result = _secondOperand;
      }
    });
    updateHistoryRow();
  }

  void setOperation(String op) {
    setState(() {
      if (_operation == '') {
        _operation = op;
      } else {
        compute();
        _operation = op;
      }
      _dotClicked = false;
    });
    updateHistoryRow();
  }

  void clear() {
    setState(() {
      _firstOperand = 0;
      _secondOperand = 0;
      _operation = '';
      _result = 0;
      _dotClicked = false;
      history = [
        {
          'dot': false,
          'firstOperand': 0,
          'secondOperand': 0,
          'operation': '',
          'result': 0,
        }
      ];
    });
  }

  void toggleDot() {
    setState(() {
      _dotClicked = !_dotClicked;
    });
    updateHistoryRow();
  }

  void addHistoryRow() {
    setState(() {
      history.add({
        'dot': _dotClicked,
        'firstOperand': _firstOperand,
        'secondOperand': _secondOperand,
        'operation': _operation,
        'result': _result
      });
    });
    _scrollToBottom();
  }

  void updateHistoryRow() {
    setState(() {
      history[history.length - 1] = {
        'dot': _dotClicked,
        'firstOperand': _firstOperand,
        'secondOperand': _secondOperand,
        'operation': _operation,
        'result': _result
      };
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_historyScrollController.hasClients) {
        _historyScrollController.animateTo(
          _historyScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // results container
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "$_result",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(
                      //   color: Colors.white,
                      //   width: 1,
                      // ),
                    ),
                    height: 200,
                    child: ListView.builder(
                      controller: _historyScrollController,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HistoryCell(content: 'dot'),
                                HistoryCell(content: '1st op'),
                                HistoryCell(content: '2nd op'),
                                HistoryCell(content: 'operation'),
                                HistoryCell(content: 'result'),
                              ],
                            ),
                            subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  HistoryCell(
                                    content: history[index]['dot'],
                                  ),
                                  HistoryCell(
                                    content: history[index]['firstOperand'],
                                  ),
                                  HistoryCell(
                                    content: history[index]['secondOperand'],
                                  ),
                                  HistoryCell(
                                    content: history[index]['operation'],
                                  ),
                                  HistoryCell(
                                    content: history[index]['result'],
                                  ),
                                ]));
                      },
                    ),
                  ),
                ),
                // buttons container
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // first row: %% C CE <-
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => setOperation("%"),
                            child: const Text("%"),
                          ),
                          TextButton(
                            onPressed: clear,
                            child: const Text("C"),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("CE"),
                          ),
                          TextButton(
                            onPressed: clearOne,
                            child: const Icon(Icons.arrow_left),
                          ),
                        ],
                      ),
                      // second row: 7 8 9 /
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => numberClicked(7),
                            child: const Text("7"),
                          ),
                          TextButton(
                            onPressed: () => numberClicked(8),
                            child: const Text("8"),
                          ),
                          TextButton(
                            onPressed: () => numberClicked(9),
                            child: const Text("9"),
                          ),
                          TextButton(
                            onPressed: () => setOperation("/"),
                            child: const Text("/"),
                          ),
                        ],
                      ),
                      // third row: 4 5 6 *
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => numberClicked(4),
                            child: const Text("4"),
                          ),
                          TextButton(
                            onPressed: () => numberClicked(5),
                            child: const Text("5"),
                          ),
                          TextButton(
                            onPressed: () => numberClicked(6),
                            child: const Text("6"),
                          ),
                          TextButton(
                            onPressed: () => setOperation("*"),
                            child: const Text("*"),
                          ),
                        ],
                      ),
                      // fourth row: 1 2 3 -
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => numberClicked(1),
                            child: const Text("1"),
                          ),
                          TextButton(
                            onPressed: () => numberClicked(2),
                            child: const Text("2"),
                          ),
                          TextButton(
                            onPressed: () => numberClicked(3),
                            child: const Text("3"),
                          ),
                          TextButton(
                            onPressed: () => setOperation("-"),
                            child: const Text("-"),
                          ),
                        ],
                      ),
                      // fifth row:  +/- 0 . +
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("0"),
                          ),
                          TextButton(
                            onPressed: toggleDot,
                            child: const Text("."),
                          ),
                          TextButton(
                            onPressed: compute,
                            child: const Text("="),
                          ),
                          TextButton(
                            onPressed: () => setOperation("+"),
                            child: const Text("+"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryCell extends StatelessWidget {
  const HistoryCell({
    super.key,
    required this.content,
  });

  final dynamic content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          textAlign: TextAlign.center,
          content.toString(),
        ),
      ),
    );
  }
}
