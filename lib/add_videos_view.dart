import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_ihm/model/curso_model.dart';
import 'package:projeto_ihm/model/video_model.dart';

import 'data/data.dart';
import 'main.dart';

class AddVideoview extends StatefulWidget {
  Data data;
  CursoModel cursoModel;
  AddVideoview({@required this.data, @required this.cursoModel});
  @override
  AddVideoviewState createState() => new AddVideoviewState();
}

class AddVideoviewState extends State<AddVideoview> {
  TextEditingController _textEditingController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  VideoModel _videoModel;
  File _videoFile;
  String _titulo;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
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
          title: new Text("Adicionar Video",
              style: Theme.of(context).textTheme.title),
          bottom: new PreferredSize(
              preferredSize: const Size.fromHeight(25.0),
              child: new Container(height: 30.0, child: null)),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Título do Video: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    TextField(
                      controller: _textEditingController,
                      onSubmitted: (String value) {
                        _titulo = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.upload_file,
                  color: Colors.black87,
                  size: 35,
                ),
                onPressed: () {
                  captureVideo().then((value) => _videoFile = value);
                  return Container(
                    width: 130.0,
                    height: 100.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color: Colors.white70
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.move_to_inbox,
                          size: 80,
                          color: Colors.black54,
                        ),
                        Text('${_videoModel.video_file.toString()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  );
                },
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
            _videoModel = new VideoModel(_titulo);
            _videoModel.video_file = _videoFile;
            widget.data.uploadVideo(widget.cursoModel, _videoModel);
          }),
    );
  }

  Future<File> captureVideo() async {
    try {
      final videoFile =
          await ImagePicker.pickVideo(source: ImageSource.gallery);
      return videoFile;
    } catch (e) {
      print(e);
    }
  }

  // Widget _buildButtons() {
  //   return ConstrainedBox(
  //       constraints: BoxConstraints.expand(height: 80.0),
  //       child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             _buildActionButton(
  //                 key: Key('upload'),
  //                 text: 'Salvar',
  //                 onPressed: () {
  //                   _videoModel = new VideoModel(_titulo);
  //                   _videoModel.video_file = _videoFile;
  //                   widget.data.uploadVideo(widget.cursoModel, _videoModel);
  //                 }),
  //           ]));
  // }

  // Widget _buildActionButton({Key key, String text, Function onPressed}) {
  //   return Expanded(
  //     child: FlatButton(
  //         key: key,
  //         child: Text(text, style: TextStyle(fontSize: 20.0)),
  //         shape: RoundedRectangleBorder(),
  //         // color: Colors.grey,
  //         textColor: Colors.white,
  //         onPressed: onPressed),
  //   );
  // }
}
