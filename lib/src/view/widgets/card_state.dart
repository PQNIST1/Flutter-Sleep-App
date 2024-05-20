import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sleep_media_model.dart';
import '../../themes.dart';
import '../../view_models/detail_view_model.dart';

class CardItem extends StatelessWidget {
  final SleepMediaItem sleepMediaItem;

  const CardItem({
    Key? key,
    required this.sleepMediaItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlay = Provider.of<DetailViewModel>(context, listen: true);
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
                      image: sleepMediaItem.imgUrl.toString(),
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
                        sleepMediaItem.title.toString(),
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),),
            Positioned(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/15,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          if (audioPlay.isPlaying) {
                            audioPlay.pauseAudio();
                          } else {
                            audioPlay.playAudio();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.4), // Màu nền của nút
                          shape: CircleBorder(), // Đặt hình dạng nút thành hình tròn
                          padding: EdgeInsets.all(25), // Điều chỉnh kích thước của nút
                        ),
                        child: Image.asset(audioPlay.isPlaying && audioPlay.currentUrl == sleepMediaItem.mediaUrl ? 'assets/pause.png' : 'assets/play-button-arrowhead.png',height: 15,width: 15,fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ))
          ]),
    );
  }
}
