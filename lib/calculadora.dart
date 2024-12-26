import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'Limpar';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Não é possível calcular';
    }
  }

  double _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');

    try {
      // Avalia a expressão com a biblioteca expressions
      final expression = Expression.parse(expressao);
      final evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      
      // Verifica se o resultado pode ser convertido para double
      if (result is double) {
        return result;
      } else if (result is int) {
        return result.toDouble();
      } else {
        return 0.0; // Caso de erro
      }
    } catch (e) {
      return 0.0; // Caso de erro na expressão
    }
  }

  Widget _botao(String valor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          valor,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _pressionarBotao(valor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(20),
            child: Text(
              _expressao,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(20),
            child: Text(
              _resultado,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 1.5,
            children: [
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('x'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao('.'),
              _botao('='),
              _botao('+'),
            ],
          ),
        ),
        Expanded(
          child: _botao(_limpar),
        )
      ],
    );
  }
}