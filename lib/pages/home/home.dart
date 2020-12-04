import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:movies_riverpod/models/movie.dart';
import 'package:movies_riverpod/pages/home/movie_pagination_controller.dart';
import 'package:movies_riverpod/services/movie_services.dart';
import 'package:movies_riverpod/utils/movies_exceptions.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;
  final movieService = ref.read(movieServiceProvider);
  final movies = await movieService.getMovies();

  return movies;
});

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final movies = watch(moviesFutureProvider);
    final paginationController = watch(moviePaginationControllerProvider);
    final paginationState = watch(moviePaginationControllerProvider.state);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Movies Riverpod"),
      ),
      body: Builder(
        builder: (context) {
          if (paginationState.refreshError) {
            return _ErrorBody(message: paginationState.errorMessage);
          } else if (paginationState.movies.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () {
              return context
                  .refresh(moviePaginationControllerProvider)
                  .getMovies();
            },
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  maxCrossAxisExtent: 200),
              itemCount: paginationState.movies.length,
              itemBuilder: (context, index) {
                paginationController.handleScrollWithIndex(index);
                return _MovieBox(movie: paginationState.movies[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () =>
                context.refresh(moviePaginationControllerProvider).getMovies(),
            child: const Text("Tentar novamente"),
          ),
        ],
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;

  const _MovieBox({Key key, this.movie}) : super(key: key);

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
          child: _FrontBanner(text: movie.title),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  const _FrontBanner({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

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
