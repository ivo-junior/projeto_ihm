import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ihm/model/curso_model.dart';

import 'data/data.dart';
import 'main.dart';

class ComprarCurso extends StatefulWidget {
  final CursoModel cursoModel;
  final Data data;

  ComprarCurso({@required this.cursoModel, @required this.data});

  @override
  _CompraCursoState createState() => _CompraCursoState();
}

class _CompraCursoState extends State<ComprarCurso> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          titleSpacing: 0.0,
          elevation: appBarElevation,
          title: new Text("Carrinho", style: Theme.of(context).textTheme.title),
          bottom: new PreferredSize(
              preferredSize: const Size.fromHeight(25.0),
              child: new Container(height: 25.0, child: null)),
        ),
      ),
      body: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60,
              color: Theme.of(context).accentIconTheme.color,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.add_shopping_cart,
                      color: Theme.of(context).iconTheme.color,
                      size: 40,
                    ),
                    Text(
                      "Detalhes da Compra!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 25.0),
                    ),
                  ]),
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Curso: ${widget.cursoModel.nome_curso}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.arrow_left_sharp,
                          color: Theme.of(context).accentIconTheme.color),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "Por: ${widget.cursoModel.responsavel}",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.black87, fontSize: 20.0),
                        ),
                      ),
                    ]),
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.arrow_left_sharp,
                          color: Theme.of(context).accentIconTheme.color),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "${widget.cursoModel.area}",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.black87, fontSize: 20.0),
                        ),
                      ),
                    ]),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_left_sharp,
                        color: Theme.of(context).accentIconTheme.color),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "${widget.cursoModel.duracao}h",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87, fontSize: 20.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.attach_money,
                  color: Theme.of(context).accentIconTheme.color,
                  size: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "Valor: ${widget.cursoModel.valor == "0.00" ? "Grátis" : ("R\$" + widget.cursoModel.valor)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 25.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.cursoModel.comprado = true;
          widget.cursoModel.valor = 'Adquirido';
          widget.data.updateCurso(widget.cursoModel);

          _showMyDialog();
        },
        icon: Icon(Icons.add),
        label: new Text("Comprar"),
        foregroundColor: Theme.of(context).iconTheme.color,
        backgroundColor: Theme.of(context).accentIconTheme.color,
        elevation: 4.0,
        tooltip: "Comprar",
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Obrigado!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Curso adiquirido com Sucesso!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Comfirm'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
