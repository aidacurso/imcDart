import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

enum genero { masculino, feminino }

class Pessoa {
  String sexo = "";
  double peso = 0;
  int altura = 0;
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  genero? _generica = genero.feminino;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  late String _result;

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    setState(() {
      _result = 'Informe seus dados';
    });
  }

  void calculateImc() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text) / 100.0;
    double imc = weight / (height * height);

    if (_generica.toString() == "masculino") {
      setState(() {
        _result = "IMC = ${imc.toStringAsPrecision(2)}\n";
        if (imc < 20.7) {
          _result += "abaixo do peso";
        } else if (imc < 26.4) {
          _result += "peso ideal";
        } else if (imc < 27.8) {
          _result += "Pouco acima do peso";
        } else if (imc < 31.1) {
          _result += "Acima do peso";
        } else {
          _result += "Obesidade";
        }
      });
    } else {
      setState(() {
        _result = "IMC = ${imc.toStringAsPrecision(2)}\n";
        if (imc < 19.1) {
          _result += "abaixo do peso";
        } else if (imc < 25.8) {
          _result += "peso ideal";
        } else if (imc < 27.3) {
          _result += "Pouco acima do peso";
        } else if (imc < 32.3) {
          _result += "Acima do peso";
        } else {
          _result += "Obesidade";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Calculadora de IMC'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Peso(kg)",
              error: "Insira seu peso!",
              controller: _weightController),
          buildTextFormField(
              label: "Altura(cm)",
              error: "Insira uma altura!",
              controller: _heightController),
          ListTile(
            title: const Text('Feminino'),
            leading: Radio<genero>(
              value: genero.feminino,
              groupValue: _generica,
              onChanged: (genero? value) {
                setState(() {
                  _generica = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Masculino'),
            leading: Radio<genero>(
              value: genero.masculino,
              groupValue: _generica,
              onChanged: (genero? value) {
                setState(() {
                  _generica = value;
                });
              },
            ),
          ),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  Padding buildCalculateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            calculateImc();
          }
        },
        child: const Text('CALCULAR', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Padding buildTextResult() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _result,
        textAlign: TextAlign.center,
      ),
    );
  }

  TextFormField buildTextFormField(
      {required TextEditingController controller,
      required String error,
      required String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text!.isEmpty ? error : null;
      },
    );
  }
}
