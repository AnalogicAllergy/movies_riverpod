import 'package:dio/dio.dart';

class MoviesException implements Exception {
  MoviesException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.CANCEL:
        message = "Requisição para a API foi cancelada";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        message = "Tempo de conexão ao servidor expirado";
        break;
      case DioErrorType.DEFAULT:
        message = "Conexão falhou por falta de internet";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        message =
            "A conexão com o servidor foi interrompida devido a problemas";
        break;
      case DioErrorType.RESPONSE:
        message = _handleError(dioError.response.statusCode);
        break;
      case DioErrorType.SEND_TIMEOUT:
        message = "Servidor indisponível";
        break;
      default:
        message = "Ops... algo deu errado!";
        break;
    }
  }

  String message;

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Erro do cliente';
      case 404:
        return 'O recurso não foi encontrado';
      case 500:
        return 'Erro de servidor interno';
      default:
        return 'Oops... algo deu errado!';
    }
  }

  @override
  String toString() => message;
}
