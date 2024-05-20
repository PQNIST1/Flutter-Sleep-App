import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sleep/src/themes.dart';
import 'package:sleep/src/utils/responsive.dart';
import 'package:sleep/src/view/details/detail_screen.dart';
import 'package:sleep/src/view/home/test.dart';
import 'package:sleep/src/view_models/home_view_model.dart';

import '../../models/sleep_media_model.dart';
import '../../view_models/detail_view_model.dart';
import '../widgets/icon_menu.dart';
import '../widgets/sleep_card_item.dart';
import '../widgets/sleep_item_loading.dart';
import 'global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late SleepMediaItem test;
  late final DetailViewModel detailViewModel;
  List<SleepMediaItem> sleepMediaDatas = [];
  late AnimationController controller;
  late int time;
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  String title = "";
  String subtitle = "";
  bool isLoading = false;
  int selectedCategoryId = 0;
  void notify() {
    // FlutterRingtonePlayer.playNotification();
    controller.stop();
    Provider.of<DetailViewModel>(context, listen: false).pauseAudio();
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

  void  getFilterSleepMediaDatas(int categoryId) {
    setState(() {
      sleepMediaDatas = [];
      isLoading = true;
    });
    getMediaDatas(categoryId: categoryId).then((value) {
      setState(() {
        sleepMediaDatas = value;
        isLoading = false;
      });
    });
  }

  void changePageText(id) {
    switch (id) {
      case 0:
        setState(() {
          title = "Âm thanh về giấc ngủ";
          subtitle = "Những âm nhạc về giấc ngủ và \n thiên nhiên hay nhất";
        });
        break;
      case 1:
        setState(() {
          title = "Âm thanh về giấc ngủ";
          subtitle =
              "Khám phá những âm thanh sẽ giúp bạn\n chìm vào giấc ngủ sâu";
        });
        break;
      case 2:
        setState(() {
          title = "Âm thanh về giấc ngủ";
          subtitle =
              "Khám phá những âm thanh sẽ giúp bạn\n hòa mình vào tự nhiên";
        });
        break;
      case 3:
        setState(() {
          title = "Âm thanh về giấc ngủ";
          subtitle =
              "Khám phá những âm thanh sẽ giúp bạn\n xua tan những mệt mõi";
        });
        break;
      case 4:
        setState(() {
          title = "Âm thanh về giấc ngủ";
          subtitle =
              "Tạo những âm nhạc về giấc ngủ yêu thích của bạn";
        });
        break;
      case 5:
        setState(() {
          title = "Âm thanh về giấc ngủ";
          subtitle =
          "Khám phá những âm thanh sẽ giúp bạn\n thư thãn hơn";
        });
        break;
      case 6:
        setState(() {
          title = "Âm thanh về giấc ngủ";
          subtitle =
          "Khám phá những âm thanh sẽ giúp bạn\n tập trung vào công việc";
        });
        break;
      default:
    }
  }


  @override
  void initState() {
    changePageText(0);
    getSleepMediaDatas();
      // Thực hiện các thao tác khi sleepMediaItem không null
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
    _scrollController = ScrollController();
    super.initState();
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
    // Kích hoạt việc chạy lại controller nếu cần
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Responsive(
            mobile: _homeTabletMobileScreen(screenHeight),
            tablet: _homeTabletMobileScreen(screenHeight),
        ),
      ),
    );
  }

  Stack _homeTabletMobileScreen(
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
                    padding: selectedCategoryId == 4
                        ? const EdgeInsets.only(top: 60)
                        : const EdgeInsets.fromLTRB(0, 60, 0, 20),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(48, 15, 48, 15),
                          child: Center(
                            child: Text(
                              subtitle,
                              style:
                                  Theme.of(context).textTheme.bodyText1!.copyWith(
                                        height: 1.4,
                                        fontSize: 17,
                                      ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(10, 25, 20, 0),
                          child: Row(
                            children: [
                              IconMenu(
                                onTap: () {
                                  getSleepMediaDatas();
                                  setState(() {
                                    selectedCategoryId = 0;
                                  });
                                  changePageText(selectedCategoryId);
                                },
                                icon: "assets/icon_menu_all.png",
                                label: "Tất cả",
                                isSelected: selectedCategoryId == 0 ? true : false,
                              ),
                              IconMenu(
                                onTap: () {
                                  getFilterSleepMediaDatas(4);
                                  setState(() {
                                    selectedCategoryId = 4;
                                  });
                                  changePageText(selectedCategoryId);
                                },
                                icon: "assets/icon_menu_favorite.png",
                                label: "Tùy chỉnh",
                                isSelected: selectedCategoryId == 4 ? true : false,
                              ),
                              IconMenu(
                                onTap: () {
                                  getFilterSleepMediaDatas(1);
                                  setState(() {
                                    selectedCategoryId = 1;
                                  });
                                  changePageText(selectedCategoryId);
                                },
                                icon: "assets/icon_menu_sleep.png",
                                label: "Ngủ",
                                isSelected: selectedCategoryId == 1 ? true : false,
                              ),
                              IconMenu(
                                onTap: () {
                                  getFilterSleepMediaDatas(2);
                                  setState(() {
                                    selectedCategoryId = 2;
                                  });
                                  changePageText(selectedCategoryId);
                                },
                                icon: "assets/rain.png",
                                label: "Mưa rơi",
                                isSelected: selectedCategoryId == 2 ? true : false,
                              ),
                              IconMenu(
                                onTap: () {
                                  getFilterSleepMediaDatas(3);
                                  setState(() {
                                    selectedCategoryId = 3;
                                  });
                                  changePageText(selectedCategoryId);
                                },
                                icon: "assets/relax_icon.png",
                                label: "Thư giãn",
                                isSelected: selectedCategoryId == 3 ? true : false,
                              ),
                              IconMenu(
                                onTap: () {
                                  getFilterSleepMediaDatas(5);
                                  setState(() {
                                    selectedCategoryId = 5;
                                  });
                                  changePageText(selectedCategoryId);
                                },
                                icon: "assets/relax.png",
                                label: "Thiền",
                                isSelected: selectedCategoryId == 5 ? true : false,
                              ),
                              IconMenu(
                                onTap: () {
                                  getFilterSleepMediaDatas(6);
                                  setState(() {
                                    selectedCategoryId = 6;
                                  });
                                  changePageText(selectedCategoryId);
                                },
                                icon: "assets/work.png",
                                label: "Làm việc",
                                isSelected: selectedCategoryId == 6 ? true : false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Visibility(
                            visible: selectedCategoryId == 4 &&
                                sleepMediaDatas.isEmpty &&
                                isLoading == false,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Lottie.asset('assets/good.json'),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Bạn chưa tạo âm nhạc yêu thích cho mình",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontWeight: medium,
                                        height: 1.4,
                                        fontSize: 17,
                                      ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Hãy Tạo Âm Thanh Yêu Thích Của Bạn Nào",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontWeight: medium,
                                        height: 1.4,
                                        fontSize: 16,
                                      ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 25,
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
                                           Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                            return DetailScreen(
                                              heroTagName: "detail_img_$i",
                                              isRelated: false,
                                              sleepMediaItem: sleepMediaDatas[i],
                                            );
                                          }));
                                           if(audioPlay.currentUrl != sleepMediaDatas[i].mediaUrl){
                                             audioPlay.pause();
                                             audioPlay.pauseAll();
                                             audioPlay.clear();
                                           }
                                           audioPlay.timing();
                                           controller.stop();
                                              audioPlay.setTime(int.parse(countText.split(':')[0]) * 3600 +
                                              int.parse(countText.split(':')[1]) * 60 +
                                              int.parse(countText.split(':')[2]));

                                        },
                                        child: SleepCardItem(
                                          image:
                                              sleepMediaDatas[i].imgUrl.toString(),
                                          label:
                                              sleepMediaDatas[i].title.toString(),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (audioPlay.popUp) Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.8),
                ),
                child: MusicPlayerWidget(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
