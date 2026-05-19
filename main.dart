import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = "0";

  String lastExpression = "";

  String firstNumber = "";

  String secondNumber = "";

  String operation = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        output = "0";
      } else if (buttonText == "AC") {
        output = "0";
      } else if (buttonText == "⌫") {
        if (output.length > 1) {
          output = output.substring(0, output.length - 1);
        } else {
          output = "0";
        }
      } else if (buttonText == "N/D") {
        if (lastExpression.contains("/")) {
          List<String> parts = lastExpression.split("/");

          int numerator = int.parse(parts[0]);

          int denominator = int.parse(parts[1]);

          int gcdValue = gcd(numerator, denominator);

          numerator = numerator ~/ gcdValue;

          denominator = denominator ~/ gcdValue;

          output = "$numerator/$denominator";
        }
      } else if (buttonText == "( )") {
        int openBrackets = "(".allMatches(output).length;

        int closeBrackets = ")".allMatches(output).length;

        if (openBrackets > closeBrackets) {
          output += ")";
        } else {
          if (output == "0") {
            output = "(";
          } else {
            String lastChar = output[output.length - 1];

            if (lastChar == ")" || RegExp(r'[0-9]').hasMatch(lastChar)) {
              output += "*(";
            } else {
              output += "(";
            }
          }
        }
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          int openBrackets = "(".allMatches(output).length;

          int closeBrackets = ")".allMatches(output).length;

          while (openBrackets > closeBrackets) {
            output += ")";

            closeBrackets++;
          }

          lastExpression = output;

          Expression exp = p.parse(output);

          ContextModel cm = ContextModel();

          double result = exp.evaluate(EvaluationType.REAL, cm);

          if (result.isInfinite || result.isNaN) {
            output = "Error";
          } else {
            output = result.toString();
          }

          output = result.toString();
        } catch (e) {
          output = "Error";
        }
      } else {
        String operators = "+-*/%^";

        String lastChar = output[output.length - 1];

        if (operators.contains(lastChar) && operators.contains(buttonText)) {
          return;
        }

        if (buttonText == "." && output.contains(".")) {
          return;
        }

        if (output == "0") {
          output = buttonText;
        } else {
          output = output + buttonText;
        }
      }
    });
  }

  int gcd(int a, int b) {
    while (b != 0) {
      int temp = b;

      b = a % b;

      a = temp;
    }

    return a;
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),

        child: ElevatedButton(
          onPressed: () {
            buttonPressed(buttonText);
          },

          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: buttonText == "N/D" || buttonText == "AC" ? 20 : 28,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),

      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,

              padding: EdgeInsets.all(20),

              child: Text(output, style: TextStyle(fontSize: 40)),
            ),
          ),

          Row(
            children: [
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("⌫"),
              buildButton("AC"),
            ],
          ),

          Row(
            children: [
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("*"),
              buildButton("/"),
            ],
          ),

          Row(
            children: [
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("+"),
              buildButton("-"),
            ],
          ),

          Row(
            children: [
              buildButton("0"),
              buildButton("( )"),
              buildButton("."),
              buildButton("N/D"),
              buildButton("="),
            ],
          ),
        ],
      ),
    );
  }
}
