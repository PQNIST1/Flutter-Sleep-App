import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sleep/src/view/home/global.dart';

import '../../models/progress_bar_model.dart';
import '../../models/sleep_media_model.dart';
import '../../themes.dart';
import '../../view_models/detail_view_model.dart';
import '../details/detail_screen.dart';
class MusicPlayerWidget extends StatefulWidget {
  @override
  _MusicPlayerWidgetState createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> with TickerProviderStateMixin {
  late AnimationController controller;
  late int time;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  void notify() {
    // FlutterRingtonePlayer.playNotification();
    controller.stop();
    Provider.of<DetailViewModel>(context, listen: false).pauseAudio();
    Provider.of<DetailViewModel>(context, listen: false).pauseAll();
  }
  @override
  void initState() {
    super.initState();
    time = Provider.of<DetailViewModel>(context, listen: false).time;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: time),
    );
    controller.addListener(() {
      if (controller.value <= 0.01) {
        notify();
      }
    });

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final detailViewModel = Provider.of<DetailViewModel>(context, listen: true);
    final newTime = detailViewModel.time;

    // Kiểm tra xem time có thay đổi so với giá trị trước đó không
    if (newTime != time) {
      // Cập nhật time mới
      time = newTime;

      // Cập nhật duration của controller
      controller.duration = Duration(seconds: time);

      // Đặt lại controller.value về mặc định
      controller.value = 1.0;
    }
    if (Provider.of<DetailViewModel>(context).isPlaying && Provider.of<DetailViewModel>(context).isTime) {
      controller.reverse(
              from: controller.value == 0 ? 1.0 : controller.value,
            );
    } else {
      controller.stop();
    }
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final audioPlay = Provider.of<DetailViewModel>(context, listen: true);
    return GestureDetector(
            onTap: (){
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return DetailScreen(
                      heroTagName: "detail_img_",
                      isRelated: false,
                      sleepMediaItem: audioPlay.music,
                    );
                  }));
             controller.stop();
             audioPlay.timing();
              audioPlay.setTime(int.parse(countText.split(':')[0]) * 3600 +
                  int.parse(countText.split(':')[1]) * 60 +
                  int.parse(countText.split(':')[2]));
            },
      child: Container(
        height: MediaQuery.of(context).size.height*0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.65,
              child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(audioPlay.music.imgUrl.toString(),width: 60,height: 60,fit: BoxFit.cover,),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10,bottom: 5),
                            child: Text(audioPlay.music.title.toString(),style: TextStyle(fontSize: 16,color: Colors.white),),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset('assets/alarm-clock.png',width: 15,height: 15,fit: BoxFit.cover,),
                              ),
                              AnimatedBuilder(
                                animation: controller,
                                builder: (context, child) => Text(
                                  countText,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),


            ),
            Container(
              width: MediaQuery.of(context).size.width*0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (audioPlay.isPlaying) {
                            audioPlay.pauseAudio();
                            audioPlay.pauseAll();
                            controller.stop();
                          } else {
                            audioPlay.playAudio();
                            audioPlay.playAll();
                            controller.reverse(
                                from: controller.value == 0 ? 1.0 : controller.value);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide.none,
                          shadowColor: Colors.transparent,
                          primary: Colors.transparent,
                          minimumSize: Size(10,10),
                          // padding: EdgeInsets.fromLTRB(
                          //   MediaQuery.of(context).size.width /6, // Left padding
                          //   25, // Top padding
                          //   MediaQuery.of(context).size.width /6, // Right padding
                          //   25, // Bottom padding
                          // ),
                          textStyle: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                              color: Colors.transparent,
                              fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),

                        child: Image.asset(audioPlay.isPlaying ? 'assets/pause.png' : 'assets/play-button-arrowhead.png',height: 15,width: 15,fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(0),
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          audioPlay.popup();
                        });
                        audioPlay.pauseAll();
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide.none,
                        shadowColor: Colors.transparent,
                        primary: Colors.transparent,
                        minimumSize: Size(10,10),
                      ),
                      child: Image.asset('assets/close.png',width: 15,height: 15,fit: BoxFit.cover,),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

