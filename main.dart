import 'package:flutter/material.dart';

void main() {
  runApp(Engegov());
}

class Engegov extends StatelessWidget {
  const Engegov({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencia(),

        //FormularioTransferencia(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNomeConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  FormularioTransferencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Appbarclass('Nova transação'),
        
            Editor(
              controlador: _controladorCampoNomeConta,
              rotulo: 'Seu nome:',
              dica: ' Fulano de Tal',
              icone: Icons.account_box,
            ),
            Editor(
              controlador: _controladorCampoValor,
              rotulo: 'Valor desejado:',
              dica: ' R\$ 1.000,00',
              icone: Icons.account_balance_wallet,
              teclado: TextInputType.number,
            ),
        
            ElevatedButton(
              onPressed: () {
                _criarTransferencia(context);
              },
              child: Text('Confimar'),
            ),
          ],
        ),
      ),
    );
  }

  void _criarTransferencia(BuildContext context) {
    final String nomeUsuario = _controladorCampoNomeConta.text;
    String valorSemV = _controladorCampoValor.text;

    valorSemV = valorSemV.replaceAll('.', '');
    valorSemV = valorSemV.replaceAll(',', '.');
    final double? valor = double.tryParse(valorSemV);

    if (nomeUsuario != '' && valor != null) {
      final transferenciaCriada = Transferencia(nomeUsuario, valor);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$transferenciaCriada')));

      Navigator.pop(context, transferenciaCriada);
      debugPrint('Criando transferencia');
    } else {
      if (nomeUsuario == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entrada no nome de Usuario invalida ou em branco.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entrada no valor desejado invalida ou em branco.'),
          ),
        );
      }
    }
  }
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarclass('EngeGov'),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(
            transferencia.nomeUsuario,
            'R\$ ${transferencia.valor.toStringAsFixed(2)}',
            Icons.account_box,
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia?> future = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormularioTransferencia();
              },
            ),
          );
          future.then((transferenciaRecebida) {
            debugPrint('entrou no then');
            debugPrint('$transferenciaRecebida');
            if (transferenciaRecebida != null) {
              setState(() {
                widget._transferencias.add(transferenciaRecebida);
              });
            }
          });
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icone;

  const ItemTransferencia(this.title, this.subtitle, this.icone, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icone),
      ),
    );
  }
}

class Transferencia {
  final String nomeUsuario;
  final double valor;

  Transferencia(this.nomeUsuario, this.valor);

  @override
  String toString() {
    return 'Nome do Usuario: $nomeUsuario, Valor desejado: $valor';
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;
  final TextInputType? teclado;

  const Editor({
    super.key,
    this.controlador,
    this.rotulo,
    this.dica,
    this.icone,
    this.teclado,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: teclado,
      ),
    );
  }
}

class Appbarclass extends StatelessWidget implements PreferredSizeWidget {
  final String _textappbar;

  const Appbarclass(this._textappbar, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.orangeAccent,
      title: Text(_textappbar),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
