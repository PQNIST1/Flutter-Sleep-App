import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sleep_media_model.dart';
import '../../themes.dart';
import '../../utils/responsive.dart';
import '../../view_models/detail_view_model.dart';
import '../../view_models/home_view_model.dart';
import '../widgets/card_state.dart';
import '../widgets/icon_menu.dart';
import '../widgets/sleep_card_item.dart';
import '../widgets/sleep_item_loading.dart';
import 'detail_screen.dart';

class audioStatefulWidget extends StatefulWidget {
  @override
  _AudiofulWidgetState createState() => _AudiofulWidgetState();
}

class _AudiofulWidgetState extends State<audioStatefulWidget> with TickerProviderStateMixin {
  List<SleepMediaItem> sleepMediaDatas = [];
  bool isLoading = false;
  late AnimationController controller;
  late int time;
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  void getSleepMediaDatas() {
    setState(() {
      isLoading = true;
    });
    getMediaDatas().then((value) {
      setState(() {
        sleepMediaDatas = value;
        isLoading = false;
      });
    });
  }
  void notify() {
    // FlutterRingtonePlayer.playNotification();
    controller.stop();
    Provider.of<DetailViewModel>(context, listen: false).pauseAudio();
  }
  @override
  void initState() {
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
    if (Provider.of<DetailViewModel>(context, listen: false).isPlaying) {
      controller.reverse(
          from: controller.value == 0 ? 1.0 : controller.value);
    }
    getSleepMediaDatas();
    print(countText);
    // Thực hiện các thao tác khi sleepMediaItem không null
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Responsive(
        mobile: _listTabletMobileScreen(screenHeight),
        tablet: _listTabletMobileScreen(screenHeight),
      ),
    );
  } Stack _listTabletMobileScreen(
      double screenHeight,
      ) {
    final audioPlay = Provider.of<DetailViewModel>(context, listen: true);
    return Stack(
      children: [
        SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const Image(
                        width: double.infinity,
                        image: AssetImage("assets/image_bg_home.png"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 225,
                                        height: 225,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                          image: DecorationImage(
                                            image: AssetImage(audioPlay.music.imgUrl.toString()),
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/10,),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (){
                                              if (audioPlay.isPlaying) {
                                                audioPlay.pauseAudio();
                                                controller.stop();
                                                print(countText);
                                                
                                              } else {
                                                audioPlay.playAudio();
                                                controller.reverse(
                                                    from: controller.value == 0 ? 1.0 : controller.value);
                                                print(countText);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black.withOpacity(0.4), // Màu nền của nút
                                              shape: CircleBorder(), // Đặt hình dạng nút thành hình tròn
                                              padding: EdgeInsets.all(25), // Điều chỉnh kích thước của nút
                                            ),
                                            child: Image.asset(audioPlay.isPlaying ? 'assets/pause.png' : 'assets/play-button-arrowhead.png',height: 15,width: 15,fit: BoxFit.cover),

                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(audioPlay.music.title.toString(),style: TextStyle(
                                  fontSize: 18,color: kWhiteColor
                                ),),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            isLoading
                                ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 8,
                              itemBuilder: (context, i) {
                                return sleepItemLoading(context);
                              },
                              padding: const EdgeInsets.fromLTRB(25, 5, 18, 0),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                Responsive.isTabletPotrait(context)
                                    ? 3
                                    : Responsive.isTabletLandscape(context)
                                    ? 4
                                    : 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 10,
                              ),
                            )
                                : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sleepMediaDatas.length,
                              itemBuilder: (context, i) {
                                return Hero(
                                  tag: "detail_img_$i",
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      onTap: () {
                                        if(audioPlay.currentUrl != sleepMediaDatas[i].mediaUrl){
                                          audioPlay.pause();
                                          audioPlay.setUrl(sleepMediaDatas[i].mediaUrl.toString(), sleepMediaDatas[i]);
                                          audioPlay.playAudio();
                                        } else if(audioPlay.isPlaying) {
                                          audioPlay.pauseAudio();
                                        } else {
                                          audioPlay.playAudio();
                                        }
                                      },
                                      child: CardItem(sleepMediaItem: sleepMediaDatas[i],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              padding: const EdgeInsets.fromLTRB(25, 5, 18, 0),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                Responsive.isTabletPotrait(context)
                                    ? 3
                                    : Responsive.isTabletLandscape(context)
                                    ? 4
                                    : 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              );
            })),
        Container(
          child: IconButton(
              color: Colors.transparent,
              alignment: Alignment.center,
              onPressed: () {
                Navigator.pop(context);
                controller.stop();
                audioPlay.setTime(int.parse(countText.split(':')[0]) * 3600 +
                    int.parse(countText.split(':')[1]) * 60 +
                    int.parse(countText.split(':')[2]));
              },
              icon: Image.asset('assets/close.png',height: 15,width: 15,fit: BoxFit.cover,)),
        ),
      ],
    );
  }
}
