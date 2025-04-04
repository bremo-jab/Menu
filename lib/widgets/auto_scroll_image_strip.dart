import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AutoScrollImageStrip extends StatefulWidget {
  @override
  _AutoScrollImageStripState createState() => _AutoScrollImageStripState();
}

class _AutoScrollImageStripState extends State<AutoScrollImageStrip> {
  late ScrollController _scrollController;
  double scrollPosition = 0;

  final List<String> images = [
    "https://cdn.pixabay.com/photo/2015/04/08/13/13/food-712665_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_960_720.jpg",
    "https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/29/04/00/food-1869598_960_720.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      autoScroll();
    });
  }

  void autoScroll() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 30));
      if (_scrollController.hasClients) {
        scrollPosition += 1;
        if (scrollPosition >= _scrollController.position.maxScrollExtent) {
          scrollPosition = 0;
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(scrollPosition);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: images.length * 2,
        itemBuilder: (context, index) {
          final image = images[index % images.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: image,
                width: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }
}
