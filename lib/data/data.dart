// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:projeto_ihm/model/curso_model.dart';
import 'package:projeto_ihm/model/video_model.dart';
import 'package:projeto_ihm/util/urls.dart';

class Data {
  Dio? _dio;

  Response? _response;

  Data() {
    this._dio = Dio();
  }

  Future<List<CursoModel>> findAllCursos() async {
    List list = [];
    List<CursoModel> listCursos = [];
    CursoModel curso;

    _response = await this._dio!.get(Urls.FIND_ALL_CURSOS);

    list = _response!.data['cursos'];

    list.forEach((element) {
      curso = new CursoModel(
          element['nome_curso'],
          element['responsavel'],
          'Investimentos',
          element['duracao'].toString(),
          element['comprado'] == true ? 'Adquirido' : element['valor']);
      curso.id = element['id'].toString();
      curso.comprado = element['comprado'];

      listCursos.add(curso);
    });

    return listCursos;
  }

  Future<List<CursoModel>> findAllCursosUsuario() async {
    List list = [];
    List<CursoModel> listCursos = [];
    CursoModel curso;

    _response = await this._dio!.get(Urls.FIND_ALL_CURSOS_USUARIO);

    List res = _response!.data['cursos'];

    for (var i = 0; i < res.length; i++) {
      var csid = await this
          ._dio!
          .get(Urls.FIND_CURSO_ID, queryParameters: {'id': res[i]['curso_id']});
      list.add(csid.data['cursos']);
    }

    list.forEach((element) {
      curso = new CursoModel(
          element['nome_curso'],
          element['responsavel'],
          'Investimentos',
          element['duracao'].toString(),
          element['comprado'] == true ? 'Adquirido' : element['valor']);
      curso.comprado = element['comprado'];
      curso.id = element['id'].toString();

      listCursos.add(curso);
    });

    return listCursos;
  }

  Future<List<CursoModel>> findAllCursosComprados() async {
    List list = [];
    List<CursoModel> listCursos = [];
    CursoModel curso;

    _response = await this._dio!.get(Urls.FIND_ALL_CURSOS_COMPRADOS);

    List res = _response!.data['cursos'];

    for (var i = 0; i < res.length; i++) {
      var csid = await this
          ._dio!
          .get(Urls.FIND_CURSO_ID, queryParameters: {'id': res[i]['curso_id']});
      list.add(csid.data['cursos']);
    }

    list.forEach((element) {
      curso = new CursoModel(
          element['nome_curso'],
          element['responsavel'],
          'Investimentos',
          element['duracao'].toString(),
          element['comprado'] == true ? 'Adquirido' : element['valor']);
      curso.comprado = element['comprado'];
      curso.id = element['id'].toString();

      listCursos.add(curso);
    });

    return listCursos;
  }

  Future<dynamic> findVideosCursos(CursoModel cursoModel) async {
    List list = [];
    List<VideoModel> listVideos = [];
    VideoModel videoModel;
    _response = await this
        ._dio!
        .get(Urls.FIND_CURSOS_VIDEOS, queryParameters: {'id': cursoModel.id});

    list = _response!.data['videos'];

    list.forEach((element) {
      videoModel = new VideoModel(element['titulo']);
      videoModel.id = element['id'];
      videoModel.url = '${Urls.URL}${element['url']}';
      listVideos.add(videoModel);
    });

    return listVideos;
  }

  Future<CursoModel> findCurso(CursoModel cursoModel) async {
    dynamic res = [];
    CursoModel curso;
    _response = await this._dio!.get(Urls.FIND_CURSO,
        queryParameters: {'nome_curso': cursoModel.nome_curso});

    res = _response!.data['cursos'];

    curso = new CursoModel(
        res['nome_curso'],
        res['responsavel'],
        'Investimentos',
        res['duracao'].toString(),
        res['comprado'] == true ? 'Adquirido' : res['valor']);
    curso.comprado = res['comprado'];
    curso.id = res['id'].toString();

    return curso;
  }

  Future<String> updateCurso(CursoModel cursoModel) async {
    try {
      _response = await this
          ._dio!
          .get(Urls.UPDATE_CURSO, queryParameters: {"id": cursoModel.id});
      return "Susses";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> uploadVideo(
      CursoModel cursoModel, VideoModel videoModel) async {
    String fileName = basename(videoModel.video_file.path);
    FormData formData;

    try {
      // formData = new FormData.fromMap({
      //   'id': cursoModel.id,
      //   'titulo': videoModel.titulo,
      //   'video_file': await MultipartFile.fromFile(videoModel.video_file.path,
      //       filename: fileName),
      // });
      // _response = await this._dio.post(Urls.UPLOAD_VIDEO, data: formData);
      // // _response = await this._dio.post(Urls.UPLOAD_VIDEO, data: {
      // //   'id': cursoModel.id,
      // //   'titulo': videoModel.titulo,
      // //   'video_file': await MultipartFile.fromFile(videoModel.video_file.path,
      // //       filename: fileName),
      // // });
      _response = await this._dio!.post(Urls.UPLOAD_VIDEO, data: {
        'id': cursoModel.id,
        'titulo': videoModel.titulo,
        'video_file': videoModel.video_file
      });
      return "Susses";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> uploadCurso(CursoModel cursoModel) async {
    try {
      _response = await this._dio!.get(Urls.UPLOAD_CURSO, queryParameters: {
        'nome_curso': cursoModel.nome_curso,
        'responsavel': cursoModel.responsavel,
        'duracao': cursoModel.duracao,
        'valor': cursoModel.valor,
      });
      return "Susses";
    } catch (e) {
      return e.toString();
    }
  }
}
