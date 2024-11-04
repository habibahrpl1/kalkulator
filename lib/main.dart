import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator iPhone',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String displayText = '0';
  double? firstOperand;
  String? operation;
  bool waitingForSecondOperand = false;

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        displayText = '0';
        firstOperand = null;
        operation = null;
        waitingForSecondOperand = false;
      } else if (buttonText == '+/-') {
        displayText = displayText.startsWith('-') ? displayText.substring(1) : '-$displayText';
      } else if (buttonText == '%') {
        double value = double.tryParse(displayText) ?? 0;
        displayText = (value / 100).toString();
        displayText = removeTrailingZeros(displayText);
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
        if (!waitingForSecondOperand) {
          firstOperand = double.tryParse(displayText);
          operation = buttonText;
          waitingForSecondOperand = true;
          displayText = '0';
        } else {
          operation = buttonText;
        }
      } else if (buttonText == '=') {
        if (firstOperand != null && operation != null) {
          double secondOperand = double.tryParse(displayText) ?? 0;
          double result;
          switch (operation) {
            case '+':
              result = firstOperand! + secondOperand;
              break;
            case '-':
              result = firstOperand! - secondOperand;
              break;
            case '×':
              result = firstOperand! * secondOperand;
              break;
            case '÷':
              result = secondOperand != 0 ? firstOperand! / secondOperand : double.nan;
              break;
            default:
              result = 0;
          }
          displayText = formatResult(result);
          firstOperand = null;
          operation = null;
          waitingForSecondOperand = false;
        }
      } else if (buttonText == '.') {
        if (!displayText.contains('.')) {
          displayText += '.';
        }
      } else {
        if (waitingForSecondOperand) {
          displayText = buttonText;
          waitingForSecondOperand = false;
        } else {
          displayText = displayText == '0' ? buttonText : displayText + buttonText;
        }
      }
    });
  }

  String removeTrailingZeros(String result) {
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0*$'), ''); // Hapus trailing zero
      if (result.endsWith('.')) result = result.substring(0, result.length - 1); // Hapus trailing dot
    }
    return result;
  }

  String formatResult(double result) {
    if (result.isNaN) return 'Error';
    var formatter = NumberFormat("#,##0.##########");
    return formatter.format(result);
  }

  Widget buildButton(String text, Color color, {Color textColor = Colors.white, double widthFactor = 1}) {
    return Expanded(
      flex: (widthFactor * 1000).toInt(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: color,
            foregroundColor: textColor,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Meningkatkan ukuran font
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Text(
                displayText,
                style: const TextStyle(fontSize: 48, color: Colors.white), // Mengurangi ukuran font untuk hasil
                maxLines: 1,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton('AC', Colors.grey, textColor: Colors.black),
                  buildButton('+/-', Colors.grey, textColor: Colors.black),
                  buildButton('%', Colors.grey, textColor: Colors.black),
                  buildButton('÷', Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton('7', Colors.grey[800]!),
                  buildButton('8', Colors.grey[800]!),
                  buildButton('9', Colors.grey[800]!),
                  buildButton('×', Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton('4', Colors.grey[800]!),
                  buildButton('5', Colors.grey[800]!),
                  buildButton('6', Colors.grey[800]!),
                  buildButton('-', Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton('1', Colors.grey[800]!),
                  buildButton('2', Colors.grey[800]!),
                  buildButton('3', Colors.grey[800]!),
                  buildButton('+', Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton('0', Colors.grey[800]!, widthFactor: 2),
                  buildButton('.', Colors.grey[800]!),
                  buildButton('=', Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
