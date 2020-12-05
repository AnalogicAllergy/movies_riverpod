import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_riverpod/utils/environment_config.dart';
import 'package:movies_riverpod/models/movie.dart';
import 'package:movies_riverpod/utils/movies_exceptions.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.read(environmentConfigProvider);
  return MovieService(config, Dio());
});

class MovieService {
  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  MovieService(this._environmentConfig, this._dio);

  Future<List<Movie>> getMovies([int page = 1]) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/popular?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=$page');
      final results = List<Map<String, dynamic>>.from(response.data['results']);
      final List<Movie> movies = results
          .map((movieData) => Movie.fromMap(movieData))
          .toList(growable: false);
      return movies;
    } on DioError catch (e) {
      throw MoviesException.fromDioError(e);
    }
  }
}
