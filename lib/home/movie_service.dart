import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latest_movies/environment_config.dart';
import 'package:latest_movies/home/movies_exception.dart';

import 'movie.dart';

final movieServiceProvider = Provider<MovieService>((ref){
  final config = ref.read(environmentConfigProvider);
  return MovieService(config, Dio());
});

class MovieService {
  final EnvironmentConfig _environmentConfig;
  final Dio _dio;
  MovieService(this._environmentConfig, this._dio);
  Future<List<Movie>> getMovies() async {

    try{
      final response = await _dio.get(
          "https://api.themoviedb.org/3/movie/popular?api_key=$_environmentConfig&language=en-US&page=1");
      final results = List<Map<String, dynamic>>.from(response.data['results']);
      List<Movie> movies = results
          .map((moviesData) => Movie.fromMap(moviesData))
          .toList(growable: false);
      return movies;
    }on DioError catch(dioError){
      throw MoviesException.fromDioError(dioError);
    }


  }
}
