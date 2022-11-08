import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ihm/model/curso_model.dart';

import 'data/data.dart';
import 'main.dart';

class AddCursoview extends StatefulWidget {
  Data data;
  AddCursoview({@required this.data});
  @override
  AddCursoviewState createState() => new AddCursoviewState();
}

class AddCursoviewState extends State<AddCursoview> {
  TextEditingController _textEditingControllerNome;
  TextEditingController _textEditingControllerResp;
  TextEditingController _textEditingControllerValor;
  TextEditingController _textEditingControllerDuracao;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  CursoModel _cursoModel;
  String _nomeCurso, _responsavel, _valor, _duracao;

  @override
  void initState() {
    _textEditingControllerNome = TextEditingController();
    _textEditingControllerResp = TextEditingController();
    _textEditingControllerValor = TextEditingController();
    _textEditingControllerDuracao = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _textEditingControllerNome.dispose();
    _textEditingControllerResp.dispose();
    _textEditingControllerValor.dispose();
    _textEditingControllerDuracao.dispose();

    super.dispose();
  }

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
          title: new Text("Adicionar Novo Curso",
              style: Theme.of(context).textTheme.title),
          bottom: new PreferredSize(
              preferredSize: const Size.fromHeight(25.0),
              child: new Container(height: 30.0, child: null)),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.miscellaneous_services,
                size: 100,
                color: Theme.of(context).accentIconTheme.color,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Nome do Curso: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    TextField(
                      controller: _textEditingControllerNome,
                      onSubmitted: (String value) {
                        _nomeCurso = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Responsavel: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    TextField(
                      controller: _textEditingControllerResp,
                      onSubmitted: (String value) {
                        _responsavel = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Valor: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    TextField(
                      controller: _textEditingControllerValor,
                      textAlign: TextAlign.end,
                      onSubmitted: (String value) {
                        _valor = value;
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Duração: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    TextField(
                      controller: _textEditingControllerDuracao,
                      textAlign: TextAlign.end,
                      onSubmitted: (String value) {
                        _duracao = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.save_alt),
          label: new Text("Salvar", style: TextStyle(fontSize: 20.0)),
          foregroundColor: Theme.of(context).iconTheme.color,
          backgroundColor: Theme.of(context).accentIconTheme.color,
          elevation: 4.0,
          tooltip: "Salvar",
          onPressed: () {
            _cursoModel = new CursoModel(
                _nomeCurso, _responsavel, "Investimentos", _duracao, _valor);
            widget.data.uploadCurso(_cursoModel);
          }),
    );
  }
}
