import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_ihm/model/quiz_model.dart';
import 'package:projeto_ihm/util/data_perguntas.dart';

class QuizView extends StatefulWidget {
  QuizView({Key key}) : super(key: key);

  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  QuizModel quiz;
  List<Resultados> results;

  Future<void> fetchData() async {
    // final url = await http.get("https://opentdb.com/api.php?amount=40");
    // if (url.statusCode == 200) {
    //   var decodeRes = jsonDecode(url.body);
    //   print(decodeRes);
    //   quiz = QuizModel.fromJson(decodeRes);
    //   results = quiz.results;
    if (perguntasData != null) {
      quiz = QuizModel.fromJson(perguntasData);
      results = quiz.results;
    } else {
      throw Exception(
          "Falha ao carregar perguntas. Por favor recarregue a página e tente novamente");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Quiz"),
        centerTitle: true,
        titleSpacing: 2.0,
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: _appBody(),
    );
  }
}

Widget _appBody() {
  QuizModel quiz;
  List<Resultados> results;

  Future<void> _fetchData() async {
    // final url = await http.get("https://opentdb.com/api.php?amount=30");
    // if (url.statusCode == 200) {
    //   var decodeRes = jsonDecode(url.body);
    //   print(decodeRes);
    //   quiz = QuizModel.fromJson(decodeRes);
    //   results = quiz.results;
    //print(results);
    if (perguntasData != null) {
      quiz = QuizModel.fromJson(perguntasData);
      results = quiz.results;
    } else {
      throw Exception(
          "Falha ao carregar perguntas. Por favor recarregue a página e tente novamente");
    }
  }

  return RefreshIndicator(
    child: new FutureBuilder(
      future: _fetchData(),
      initialData: 56,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text("Precione o botão para começar!");
            break;
          case ConnectionState.active:
            return Center(
              child: new Text("Em Processo..."),
            );
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Container(
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        child: new Text("Erro!! : '${snapshot.error}'"),
                        padding: EdgeInsets.all(40.0),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: new RaisedButton(
                            onPressed: _fetchData,
                            child: new Text(
                              "Recarregar",
                              style: new TextStyle(color: Colors.white),
                            ),
                            color: Colors.indigoAccent,
                          )),
                    ],
                  ),
                ),
              );
            } else {
              return SafeArea(
                child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int index) => new Card(
                        color: Colors.white,
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ExpansionTile(
                              title: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    results[index].question,
                                    style: new TextStyle(
                                      fontSize: 17.0,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  new FittedBox(
                                      child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      FilterChip(
                                        label:
                                            new Text(results[index].category),
                                        backgroundColor: Colors.indigo[50],
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        onSelected: (bool value) {},
                                      ),
                                      new SizedBox(
                                        width: 10.0,
                                      ),
                                      FilterChip(
                                        label:
                                            new Text(results[index].difficulty),
                                        backgroundColor: Colors.indigo[50],
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        onSelected: (bool value) {},
                                      )
                                    ],
                                  )),
                                ],
                              ),
                              leading: new CircleAvatar(
                                child: new Text((results[index].category[0])),
                                foregroundColor:
                                    Theme.of(context).iconTheme.color,
                                backgroundColor:
                                    Theme.of(context).accentIconTheme.color,
                              ),
                              children: results[index].allAnswers.map((m) {
                                return AnswerWidget(
                                    results: results, index: index, m: m);
                              }).toList()),
                        ))),
              );
            }
            break;
          default:
        }
        Widget _hasErrorButton() {
          return new Container(
              child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  child: new Text("Erro : '${snapshot.error}'"),
                  padding: EdgeInsets.all(40.0),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: new RaisedButton(
                      onPressed: _fetchData,
                      child: new Text(
                        "Recarregar",
                        style: new TextStyle(color: Colors.white),
                      ),
                      color: Colors.indigoAccent,
                    )),
              ],
            ),
          ));
        }
      },
    ),
    onRefresh: _fetchData,
  );
}

class AnswerWidget extends StatefulWidget {
  final List<Resultados> results;
  final int index;
  final String m;

  AnswerWidget({this.results, this.index, this.m});

  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color c = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new ListTile(
      onTap: () {
        setState(() {
          if (widget.m == widget.results[widget.index].correctAnswer) {
            c = Colors.greenAccent;
          } else {
            c = Colors.redAccent;
          }
        });
      },
      title: new Text(
        widget.m,
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontSize: 18,
          color: c,
        ),
      ),
    ));
  }
}
