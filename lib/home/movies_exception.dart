import 'package:dio/dio.dart';

class MoviesException implements Exception{
  String? message;
  MoviesException.fromDioError(DioError dioError){
    switch (dioError.type){
      case DioErrorType.cancel:
        message = "Request to API was canceled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message = _handleError(dioError.response?.statusCode);
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.other:
        message = "Connection to API failed due to internet connection";
        break;
    }
  }


  String _handleError(int? statusCode){
    switch (statusCode){
      case 400:
        return 'Bad Request';
      case 404:
        return 'The requested resource was not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }
}