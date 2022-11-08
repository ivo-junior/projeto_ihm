import 'dart:ffi';
import 'dart:math' as Math;

import 'dart:ui';

import 'package:projeto_ihm/model/video_model.dart';

const int kColorMin = 127;

class CursoModel {
  String nome_curso, responsavel, area, duracao, valor;
  String num_avaliacoes, id;
  double nota_avaliacao;
  bool comprado = false;
  List<VideoModel> videos = [];
  // Float ;

  final Color kColora = Color.fromRGBO(
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      1.0);
  final Color kColorb = Color.fromRGBO(
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      kColorMin + Math.Random().nextInt(255 - kColorMin),
      1.0);

  CursoModel(
      this.nome_curso, this.responsavel, this.area, this.duracao, this.valor);

  CursoModel.fromJson(
      this.nome_curso, this.responsavel, this.area, this.duracao, this.valor);
}
