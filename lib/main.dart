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
            fontSize: 82,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 32,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            fixedSize: const Size(100, 100),
          ),
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
  double _result = 0;
  double _firstOperand = 0;
  double _secondOperand = 0;
  String _operation = '';
  bool _dotClicked = false;

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
      _result = double.parse(_result.toString().substring(0, 8));
      _firstOperand = _result;
      _secondOperand = 0;
      _dotClicked = false;
    });
  }

  void numberClicked(int number) {
    setState(() {
      if (_operation == '') {
        if (_firstOperand.toString().length >= 8) return;
        if (_dotClicked) {
          // add to the decimal part of the number
          String temp = _firstOperand.toString();
          if (!temp.contains('.')) {
            temp = temp + '.';
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
            temp = temp + '.';
          }
          _secondOperand = double.parse(temp + number.toString());
        } else {
          _secondOperand = _secondOperand * 10 + number;
        }
        _result = _secondOperand;
      }
    });
  }

  void clearOne() {
    setState(() {
      if (_operation == '') {
        _firstOperand = _firstOperand ~/ 10 as double;
        _result = _firstOperand;
      } else {
        _secondOperand = _secondOperand ~/ 10 as double;
        _result = _secondOperand;
      }
    });
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
  }

  void clear() {
    setState(() {
      _firstOperand = 0;
      _secondOperand = 0;
      _operation = '';
      _result = 0;
      _dotClicked = false;
    });
  }

  void addDot() {
    setState(() {
      _dotClicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // results container
              Expanded(
                flex: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "$_result",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              // buttons container
              Expanded(
                flex: 80,
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
                          onPressed: addDot,
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
    );
  }
}
