import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starbucks/animate/image_slider.dart';

import '../models/movie_model.dart';
import '../widgets/moive_detail.dart';
import '../widgets/movie_button.dart';
import 'animated_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  List<Movie> movies = [];
  int currentIndex = 0;
  double pageValue = 0.0;
  @override
  void initState() {
    super.initState();
    movies = rawData
        .map(
          (data) => Movie(
            title: data["title"],
            index: data["index"],
            image: data["image"],
          ),
        )
        .toList();
    _pageController = PageController(
      initialPage: currentIndex,
      viewportFraction: 0.8,
    )..addListener(() {
        setState(() {
          pageValue = _pageController.page!;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final reversedMovieList = movies.reversed.toList();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Stack(
              children: reversedMovieList.map((movie) {
                return ImageSlider(
                  pageValue: pageValue,
                  image: movie.image,
                  index: movie.index - 1,
                );
              }).toList(),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.8]),
              ),
            ),
            AnimatedScreen(
              pageValue: pageValue,
              pageController: _pageController,
              pageCount: movies.length,
              onPageChangeCallback: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              child: (index, _) => MovieDetail(
                movies[index],
              ),
            ),
            const Positioned(
              bottom: 32.0,
              left: 0.0,
              right: 0.0,
              child: MovieButton(),
            ),
          ],
        ),
      ),
    );
  }
}
