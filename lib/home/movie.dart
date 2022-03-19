// To parse this JSON data, do
//
//     final movie = movieFromMap(jsonString);

import 'dart:convert';

Movie movieFromMap(String str) => Movie.fromMap(json.decode(str));

String movieToMap(Movie data) => json.encode(data.toMap());

class Movie {
  Movie({
    required this.originalTitle,
    required this.posterPath,
  });

  String get fullImageUrl => 'https://image.tmdb.org/t/p/w200$posterPath';

  String originalTitle;
  String posterPath;

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
    originalTitle: json["original_title"],
    posterPath: json["poster_path"],
  );

  Map<String, dynamic> toMap() => {
    "original_title": originalTitle,
    "poster_path": posterPath,
  };
}

