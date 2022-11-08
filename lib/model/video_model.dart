import 'dart:io';

import 'package:flutter/cupertino.dart';

class VideoModel {
  int id;
  String titulo, url;
  File video_file;
  String imagem;

  VideoModel(this.titulo);

  VideoModel.fromJson(this.id, this.titulo);
}
