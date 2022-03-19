
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latest_movies/home/movie.dart';
import 'package:latest_movies/home/movie_service.dart';
import 'package:latest_movies/home/movies_exception.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;
  final movieService = ref.read(movieServiceProvider);
  final movies = await movieService.getMovies();
  return movies;
});

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Movie>> movies = ref.watch(moviesFutureProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Movisio"),
        ),
        body: movies.when(
            data: (moviesData) {
              return RefreshIndicator(
                onRefresh: () { return ref.refresh(moviesFutureProvider.future); },
                child: GridView.extent(
                    maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                  children: moviesData.map((movie) => _MovieBox(movie: movie)).toList(),
                ),
              );
            },
            error: (e, s) {
              if(e is MoviesException){
                return _ErrorBody(message: e.message!);
              }
              return _ErrorBody(message: "Oops something unexpected happened");
            },
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}

class _ErrorBody extends ConsumerWidget {
  const _ErrorBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Movie>> movies = ref.watch(moviesFutureProvider);
    return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        ElevatedButton(onPressed: (){return ref.refresh(moviesFutureProvider.future);}, child: Text("Try Again"))
      ],
    ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;
  const _MovieBox({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _FrontBanner(text: movie.originalTitle,))
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  final String text;
  const _FrontBanner({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 60,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}



