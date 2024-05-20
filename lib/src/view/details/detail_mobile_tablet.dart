

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sleep/src/view/details/audioState.dart';



import '../../models/sleep_media_model.dart';

import '../../themes.dart';
import '../../view_models/detail_view_model.dart';

class DetailMobileTabletContent extends StatefulWidget {
  final BoxConstraints constraints;
  final BuildContext context;
  final double screenHeight;
  final double screenWidth;
  final Object tag;
  final bool isRelated;
  final SleepMediaItem sleepMediaItem;
  const DetailMobileTabletContent(
      {Key? key,
      required this.constraints,
      required this.context,
      required this.screenHeight,
      required this.screenWidth,
      required this.tag,
        required this.isRelated,
      required this.sleepMediaItem})
      : super(key: key);




  @override
  State<DetailMobileTabletContent> createState() =>
      _DetailMobileTabletContentState();
}

class _DetailMobileTabletContentState extends State<DetailMobileTabletContent> with TickerProviderStateMixin{
  List<SleepMediaItem> items = [];
  bool isFavorited = false;
  late int time;
  late AnimationController controller;
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
    Provider.of<DetailViewModel>(context, listen: false).setUrl(widget.sleepMediaItem.mediaUrl.toString(), widget.sleepMediaItem);
    Future.delayed(Duration.zero, () {
      if (!Provider.of<DetailViewModel>(context, listen: false).close) {
        Provider.of<DetailViewModel>(context, listen: false).playAudio();
        controller.reverse(
            from: controller.value == 0 ? 1.0 : controller.value);
      } else {
        Provider.of<DetailViewModel>(context, listen: false).pauseAudio();
        Provider.of<DetailViewModel>(context, listen: false).pauseAll();
      }
      for (int i = 0; i < widget.sleepMediaItem.listSound!.length; i++) {
        Provider.of<DetailViewModel>(context, listen: false).setUrl1(widget.sleepMediaItem.listSound?[i]["sound_file"]);
      }
    });
    time =  Provider.of<DetailViewModel>(context, listen: false).time;
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
    var dynamicImage = DecorationImage(
      image: AssetImage(audioPlay.music.imgUrl.toString()),
      alignment: Alignment.center,
      fit: BoxFit.cover,
    );
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        controller.stop();
        return true;
      },

      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Container(
          alignment: Alignment.topCenter,
          height: double.infinity,
          decoration: BoxDecoration(
            image: dynamicImage,
          ),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          controller.stop();
                          audioPlay.timing();
                          audioPlay.setTime(int.parse(countText.split(':')[0]) * 3600 +
                              int.parse(countText.split(':')[1]) * 60 +
                              int.parse(countText.split(':')[2]));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: IconButton(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              onPressed: () {
                                Navigator.pop(context);
                                audioPlay.timing();
                                audioPlay.setTime(int.parse(countText.split(':')[0]) * 3600 +
                                    int.parse(countText.split(':')[1]) * 60 +
                                    int.parse(countText.split(':')[2]));
                                controller.stop();
                              },
                              icon: Image.asset('assets/down-arrow_white.png',height: 35,width: 35,fit: BoxFit.cover,)),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              child: IconButton(
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    if (audioPlay.music.isFavorite == false) {
                                      setState(() {
                                        audioPlay.music.isFavorite = true;
                                      });
                                    } else {
                                      setState(() {
                                        audioPlay.music.isFavorite = false;
                                      });
                                    }
                                  },
                                icon: Image.asset(
                                  audioPlay.music.isFavorite ?? false ? 'assets/favorite (1).png' : 'assets/favorite.png',
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                ),

                              )),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              child: IconButton(
                                color: Colors.transparent,
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => audioStatefulWidget()),
                                    );
                                    controller.stop();
                                    audioPlay.setTime(int.parse(countText.split(':')[0]) * 3600 +
                                        int.parse(countText.split(':')[1]) * 60 +
                                        int.parse(countText.split(':')[2]));
                                  },
                                  icon: Image.asset('assets/list.png',height: 35,width: 35,fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 300, // Độ rộng của hình tròn
                            height: 300, // Chiều cao của hình tròn
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Thiết lập hình dạng là hình tròn
                              color: Colors.transparent, // Màu nền của hình tròn
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3), // Màu của viền
                                width: 2, // Độ dày của viền
                              ),
                            ),
                          ),


                          GestureDetector(
                            onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    // Biến tạm để lưu trữ thời gian trước khi xác nhận
                                    Duration tempTime = controller.duration!;
                                    return Container(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: CupertinoTimerPicker(
                                              mode: CupertinoTimerPickerMode.hm,
                                              initialTimerDuration: controller.duration!,
                                              onTimerDurationChanged: (time) {
                                                setState(() {
                                                  tempTime = time; // Cập nhật biến tạm với thời gian mới
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Xác nhận chọn thời gian, gán thời gian mới vào controller
                                                  setState(() {
                                                    controller.duration = tempTime;
                                                  });
                                                  controller.reset();
                                                  controller.reverse(
                                                      from: controller.value == 0 ? 1.0 : controller.value);
                                                  audioPlay.playAudio();
                                                  if (!audioPlay.isChoseList.isEmpty){
                                                    audioPlay.playAll();
                                                  }
                                                  audioPlay.setTime(int.parse(countText.split(':')[0]) * 3600 +
                                                      int.parse(countText.split(':')[1]) * 60 +
                                                      int.parse(countText.split(':')[2]));
                                                  Navigator.pop(context); // Đóng BottomSheet
                                                },
                                                child: Text('Confirm'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );


                              },
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) => Text(
                                countText,
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: buildRow(),
              ),
              Center(
                child:ElevatedButton(
                  onPressed: () {
                    if (audioPlay.isPlaying) {
                      audioPlay.pauseAudio();
                      if (!audioPlay.isChoseList.isEmpty){
                        audioPlay.pauseAll();
                      }
                      controller.stop();
                    } else {
                      audioPlay.playAudio();
                      audioPlay.playAll();
                      controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ColorWithOpacity,
                    padding: EdgeInsets.fromLTRB(
                      widget.screenWidth /6, // Left padding
                      25, // Top padding
                      widget.screenWidth /6, // Right padding
                      25, // Bottom padding
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),

                  child: Image.asset(audioPlay.isPlaying ? 'assets/pause.png' : 'assets/play-button-arrowhead.png',height: 20,width: 20,fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: widget.constraints.maxWidth > 600 ? 10 : 80,
              ),
            ],
          )),
        ),
      ),
    );
  }
  Row buildRow() {
    final audioPlay = Provider.of<DetailViewModel>(context, listen: true);
    List<Widget> columns = [];
    // Thêm các widget từ danh sách items
    for (var item in audioPlay.listSoundPlay) {
      columns.add(
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ColorWithOpacity,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(item['icon']!, width: 30, height: 30, fit: BoxFit.cover,),
            ),
            Text(item['name']!, style: TextStyle(fontSize: 14, color: Colors.white),)
          ],
        ),
      );
    }
    columns.add(
      GestureDetector(
        onTap: () {
          show(context);
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ColorWithOpacity,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/pen-and-paper.png', width: 30, height: 30, fit: BoxFit.cover,),
            ),
            Text('Sửa', style: TextStyle(fontSize: 14, color: Colors.white),)
          ],
        ),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: columns,
    );
  }
  void show(BuildContext context) {
    final audioPlay = Provider.of<DetailViewModel>(context, listen: false);
    double _currentVolume = 0.5;
    showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent, // Make the background transparent
              contentPadding: EdgeInsets.zero, // Remove any default padding
              insetPadding: EdgeInsets.zero, // Remove any default inset padding
              content: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/sao2.jpg'),
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,top: 100,bottom: 15),
                      child: Text('Lựa chọn hiện tại',style: TextStyle(fontSize: 14,color: Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(Provider.of<DetailViewModel>(context, listen: true).listSound.length, (index) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  audioPlay.pauseAudio1(int.parse(audioPlay.listSound[index]["index"]!));
                                  audioPlay.removeById(audioPlay.listSound[index]["index"]!);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: ColorWithOpacity,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.asset(
                                        'assets/${audioPlay.listSound[index]["icon"]}',
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      audioPlay.listSound[index]["name"]!,
                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                    ),
                                    Container(
                                      width: 80,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 2,
                                          thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 5,
                                          ),
                                          overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 10,
                                          ),
                                          thumbColor: Colors.white,
                                        ),
                                        child: Slider(
                                          value:  Provider.of<DetailViewModel>(context, listen: true).volumeList[int.parse(audioPlay.listSound[index]["index"]!)],
                                          min: 0,
                                          max: 1,
                                          onChanged: (newValue) => Provider.of<DetailViewModel>(context, listen: false).changeVolume(int.parse(audioPlay.listSound[index]["index"]!), newValue),
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 55,
                                child: Image.asset(
                                  'assets/close.png',
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 15),
                      child: Text('Tất cả âm thanh',style: TextStyle(fontSize: 14,color: Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                                        child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Số lượng phần tử trên mỗi hàng
                        crossAxisSpacing: 50, // Khoảng cách giữa các phần tử theo chiều ngang
                        mainAxisSpacing: 10,
                        // childAspectRatio: 2 / 1,
                      ),
                      itemCount: widget.sleepMediaItem.listSound!.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                          child:GestureDetector(
                            onTap: (){
                              if (audioPlay.listSound.length <=3 && audioPlay.isChoseList[index] == false){
                                audioPlay.addList(widget.sleepMediaItem.listSound![index], index);
                                audioPlay.playAudio1(index);
                                audioPlay.choise(index);
                              }
                            } ,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color:  ColorWithOpacity,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset('assets/${widget.sleepMediaItem.listSound?[index]["icon"]}',width: 25,height: 25,fit: BoxFit.cover,),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top: 10),
                                  child: Text(widget.sleepMediaItem.listSound?[index]["name"],style: TextStyle(fontSize: 10,color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                                        ),
                                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  Navigator.of(context).pop();
                                  audioPlay.cancelUnique();
                                  audioPlay.pauseAll();
                                  audioPlay.t();
                                },
                                  child: Image.asset('assets/close.png',width: 15,height: 15,fit:BoxFit.cover)),
                              Padding(padding: EdgeInsets.only(),
                              child:Text('Hủy',style: TextStyle(fontSize: 14,color: Colors.white),) ,)
                            ],
                          ),
                          GestureDetector(
                            onTap:(){
                              if (!audioPlay.isPlaying) {
                                  audioPlay.pauseAll();
                              }
                              if (!audioPlay.isRemake) {
                                audioPlay.remakeAll();
                              }
                              audioPlay.addAllUnique();
                              audioPlay.t();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              margin:   EdgeInsets.only(left: 80,right: 80),
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // Xác định hình dạng của container là hình tròn
                                color: Colors.blue, // Màu nền của container
                              ),
                              child: Image.asset('assets/tick.png',height: 30,width:30,fit: BoxFit.cover,),
                            ),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                  onTap:(){
                                    audioPlay.pauseAll();
                                    audioPlay.removeAll();
                                    audioPlay.f();
                                  },
                                  child: Image.asset('assets/refresh-arrow.png',width: 15,height: 15,fit:BoxFit.cover)),
                              Padding(padding: EdgeInsets.only(),
                                child:Text('Đặt lại',style: TextStyle(fontSize: 14,color: Colors.white),) ,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}
