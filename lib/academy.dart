import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:projeto_ihm/add_curso_view.dart';
import 'package:projeto_ihm/add_videos_view.dart';
import 'package:projeto_ihm/comprar_curso.dart';
import 'package:projeto_ihm/model/curso_model.dart';
import 'package:projeto_ihm/util/custom_avatar.dart';

import 'curso_view.dart';
import 'curso_view_edit.dart';
import 'data/data.dart';
import 'main.dart';

const double kOverlayBoxWidth = 160.0;
const double kOverlayBoxHeight = 160.0;
const double kOverlayCardWidth = 296.0;
const int kColorMin = 127;

class Academy extends StatefulWidget {
  @override
  AcademyState createState() => new AcademyState();
}

class AcademyState extends State<Academy> with SingleTickerProviderStateMixin {
  Data data;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode _editFocusNode = FocusNode();
  TabController _tabController;
  List<CursoModel> _cursosList;
  List<CursoModel> _cursosCompradosList;
  List<CursoModel> _userCursosList;

  Future<bool> update() async => await Future.wait([
        data.findAllCursos(),
        data.findAllCursosComprados(),
        data.findAllCursosUsuario()
      ]).then((value) {
        limpaListas();

        _cursosList.addAll(value[0]);
        _cursosCompradosList.addAll(value[1]);
        _userCursosList.addAll(value[2]);

        return true;
      });

  void limpaListas() {
    _cursosList = [];
    _cursosCompradosList = [];
    _userCursosList = [];
  }

  @override
  void initState() {
    super.initState();

    limpaListas();

    _tabController = new TabController(length: 3, vsync: this);
    data = Data();
  }

  void dispose() {
    _tabController.dispose();
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
          title: new Text("Academia", style: Theme.of(context).textTheme.title),
          bottom: new PreferredSize(
              preferredSize: const Size.fromHeight(25.0),
              child: new Container(
                  height: 32.0,
                  child: new TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).accentIconTheme.color,
                    indicatorWeight: 3.0,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    labelColor: Theme.of(context).primaryIconTheme.color,
                    tabs: <Widget>[
                      new Tab(text: "Todos os Cursos"),
                      new Tab(text: "Comprados"),
                      new Tab(text: "Meus Cursos"),
                    ],
                  ))),
        ),
      ),
      body: new Container(
          child: FutureBuilder(
              future: update(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      _cursos(_cursosList, context, data, 1),
                      _cursos(_userCursosList, context, data, 2),
                      _cursos(_cursosCompradosList, context, data, 3),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new AddCursoview(
                      data: data,
                    ))),
        icon: Icon(Icons.add),
        label: new Text("Novo Curso"),
        foregroundColor: Theme.of(context).iconTheme.color,
        backgroundColor: Theme.of(context).accentIconTheme.color,
        elevation: 4.0,
        tooltip: "Novo Curso",
      ),
    );
  }

  CursoModel index;

  Widget _cursos(List<CursoModel> cursosList, BuildContext context, Data data,
      int tpCurso) {
    return cursosList.isNotEmpty
        ? ListView.builder(
            itemCount: cursosList.length,
            itemBuilder: (BuildContext c, int i) {
              index = cursosList[i];
              return GradientColorCard(
                  kColora: cursosList[i].kColora,
                  kColorb: cursosList[i].kColorb,
                  child: CursoWidget(
                    index: index,
                    allowPushRoute: true,
                    focusNode: _editFocusNode,
                    data: data,
                    tpCurso: tpCurso,
                  ));
            },
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 25.0, right: 15, top: 15),
            scrollDirection: Axis.vertical,
          )
        : new Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: new Text("Não há cursos disponíveis no momento!",
                style: Theme.of(context).textTheme.caption));
  }
}

class CursoWidget extends StatelessWidget {
  final CursoModel index;
  final FocusNode focusNode;
  final bool allowPushRoute;
  final Data data;
  final int tpCurso;

  const CursoWidget({
    Key key,
    @required this.allowPushRoute,
    @required this.index,
    @required this.data,
    @required this.tpCurso,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!index.comprado && tpCurso == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      new ComprarCurso(cursoModel: index, data: data)));
        }
        if (index.comprado || tpCurso == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new CursoView(
                curso: index,
                data: data,
                tab: 1,
              ),
            ),
          );
        }

        if (tpCurso == 3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new CursoViewEdit(
                        curso: index,
                        data: data,
                        tab: 2,
                      )));
        }
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      width: 38.0,
                      height: 38.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //color: Colors.white70
                      ),
                      // radius: 16.0,
                      child: CustomCircleAvatar(
                        myImage: NetworkImage(
                          "",
                        ),
                        initials: index.nome_curso.substring(0, 1),
                      )),
                  const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${index.nome_curso}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Duração: ${index.duracao}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "${(index.valor != "0.00" && index.valor != "Adquirido") ? ("R\$" + index.valor) : index.valor == "0.00" ? "Grátis" : "Adquirido"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "${index.area}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 11.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Responsável: ${index.responsavel}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 11.0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          linhas_estrela(index.nota_avaliacao)
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "(${index.num_avaliacoes == null ? "0" : index.num_avaliacoes})",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 11.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget linhas_estrela(nota) {
    if (nota == 5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
        ],
      );
    }
    if (nota == 4.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star_half, color: Colors.black),
        ],
      );
    }
    if (nota == 4) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 3.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star_half, color: Colors.black),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 3) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 2.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(
            Icons.star_half,
            color: Colors.black,
          ),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 2) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 1.5) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star_half, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 1) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
        ],
      );
    }
    if (nota == 0 || nota == null) {
      return Row(
        children: <Widget>[
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
          Icon(Icons.star, color: Colors.black),
        ],
      );
    }
  }
}

class GradientColorCard extends StatelessWidget {
  final CursoWidget child;
  final Color kColora;
  final Color kColorb;

  GradientColorCard({this.child, this.kColora, this.kColorb});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: child.index.nome_curso,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: kOverlayBoxHeight,
            minWidth: kOverlayBoxWidth,
          ),
          child: Container(
            width: kOverlayCardWidth,
            margin: EdgeInsets.only(right: 8.0, bottom: 4.0, top: 4.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [kColora, kColorb],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 8.0),
              ],
            ),
            child: child,
          ),
        ));
  }
}
