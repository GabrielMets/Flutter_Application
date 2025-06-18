import 'package:flutter/material.dart';

void main() {
  runApp(Engegov());
}

class Engegov extends StatelessWidget {
  const Engegov({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(), home: ListaTransferencia());
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
              dica: 'seu nome aqui...',
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00BCF0),
                foregroundColor: Color(0xFFFFE556),
              ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$transferenciaCriada',
            style: TextStyle(color: Color(0xFFFFE556)),
          ),
          backgroundColor: Color(0xFF00BCF0),
        ),
      );

      Navigator.pop(context, transferenciaCriada);
      debugPrint('Criando transferencia');
    } else {
      if (nomeUsuario == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Entrada no nome de Usuario invalida ou em branco.',
              style: TextStyle(color: Color(0xFFFFE556)),
            ),
            backgroundColor: Color(0xFF00BCF0),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Entrada no valor desejado invalida ou em branco.',
              style: TextStyle(color: Color(0xFFFFE556)),
            ),
            backgroundColor: Color(0xFF00BCF0),
          ),
        );
      }
    }
  }
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  ListaTransferencia({super.key});

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
        backgroundColor: Color(0xFF00BCF0), // <--- Define a cor de fundo do FAB
        foregroundColor: Color(0xFFFFE556),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Cantos mais arredondados
        side: BorderSide(
          color: Color(0xFFFFE556),
        ), // Borda sutil com a cor primária do tema
      ),
      color: Color(0xFF00BCF0),
      child: InkWell(
        // Adiciona InkWell para um efeito de toque visual (feedback)
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Usuario $title possui $subtitle na conta.',
                style: TextStyle(color: Color(0xFFFFE556)),
              ),
              backgroundColor: Color(0xFF00BCF0),
            ),
          );
        },
        child: ListTile(
          title: Text(title, style: TextStyle(color: Color(0xFFFFE556))),
          subtitle: Text(subtitle, style: TextStyle(color: Color(0xFFFFE556))),
          leading: Icon(icone, color: Color(0xFFFFE556)),
        ),
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
        style: TextStyle(fontSize: 24.0, color: Color(0xFFFFE556)),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone, color: Color(0xFFFFE556)) : null,
          labelText: rotulo,
          labelStyle: TextStyle(color: Color(0xFF00BCF0)),
          hintText: dica,
          hintStyle: TextStyle(color: Color(0xFFFFE556), fontSize: 10.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFE556), width: 2.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00BCF0), width: 2.0),
          ),
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
      backgroundColor: Color(0xFF00BCF0),
      title: Text(_textappbar, style: TextStyle(color: Color(0xFFFFE556))),
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFFFFE556)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
