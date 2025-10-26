import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends 
StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget
 {
  @override
  _HomePageState createState() =>
   _HomePageState();
}

class _HomePageState extends 
State<HomePage> {
  String userInput = '';
  String result = '';

  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '7', '8', '9', 'x',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=', 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                userInput,
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                result,
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                return buildButton(buttons[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == 'C') {
            userInput = '';
            result = '';
          } else if (text == 'DEL') {
            if (userInput.isNotEmpty) {
              userInput = userInput.substring(0, userInput.length - 1);
            }
          } else if (text == '=') {
            calculateResult();
          } else {
            userInput += text;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isOperator(text) ? Colors.blue : Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  bool isOperator(String x) {
    return (x == '%' || x == '/' || x == 'x' || x == '-' || x == '+' || x == '=');
  }

  void calculateResult() {
    String finalInput = userInput.replaceAll('x', '*');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result = eval.toString();
    } catch (e) {
      result = 'Error';
    }
  }
}