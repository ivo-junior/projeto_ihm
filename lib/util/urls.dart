class Urls {
  // static final IP = '192.168.42.80';
  static final IP = '192.168.1.102';
  // static final IP = '192.168.0.109';

  // static final IP = '192.168.0.4';
  // static final IP = '192.168.0.3';

  static final URL = 'http://${IP}:8000';
  static final URL_API = '${URL}/api/';

  static final FIND_CURSOS_VIDEOS = '${URL_API}get_videos/';
  static final FIND_ALL_CURSOS = '${URL_API}get_all_cursos/';
  static final FIND_ALL_CURSOS_USUARIO = '${URL_API}get_all_curso_comprados/';
  static final FIND_ALL_CURSOS_COMPRADOS = '${URL_API}get_all_curso_usuario/';
  static final FIND_CURSO = '${URL_API}get_curso/';
  static final FIND_CURSO_ID = '${URL_API}get_curso_id/';
  static final UPLOAD_CURSO = '${URL_API}upload_curso/';
  static final UPLOAD_VIDEO = '${URL_API}upload_video/';
  static final UPDATE_CURSO = '${URL_API}update_curso/';
}
