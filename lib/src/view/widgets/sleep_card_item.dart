import 'package:flutter/material.dart';

import '../../themes.dart';

class SleepCardItem extends StatelessWidget {
  const SleepCardItem({
    Key? key,
    required this.image,
    required this.label,
  }) : super(key: key);

  final String image;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Stack(
        children:[ Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/image_placeholder.jpg",
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: image,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                      "assets/image_placeholder.jpg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ]),
          Positioned(
            child:   Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/6.2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),)
      ]),
    );
  }
}
