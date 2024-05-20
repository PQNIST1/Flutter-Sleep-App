import 'package:flutter/material.dart';

import '../../themes.dart';

class CustomSound extends StatefulWidget {
  @override
  _CustomSoundState createState() => _CustomSoundState();
}

class _CustomSoundState extends State<CustomSound> {

  List<String> listSound = [
    "Tieng-chim-hot-buoi-sang-www_tiengdong_com.mp3",
    "Tieng-troi-mua-nhe-www_tiengdong_com.mp3",
    "calm-river-ambience-loop-125071.mp3",
    "night-ambience-17064.mp3",
    "rain-and-thunder-16705.mp3",
    "relaxing-ocean-waves-high-quality-recorded-177004.mp3",
    "soft-rain-ambient-111154.mp3",
    "warm-camp-fire-high-quality-176816.mp3",
    "wind-chimes-bells-115747.mp3",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: Column(
        children: [
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
                itemCount:listSound.length,
                itemBuilder: (context, index) {
                  return GridTile(
                    child:Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color:  ColorWithOpacity,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset('assets/pen-and-paper.png',width: 25,height: 25,fit: BoxFit.cover,),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: 10),
                          child: Text('Sửa',style: TextStyle(fontSize: 14,color: Colors.white),),
                        ),
                      ],
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
                        },
                        child: Image.asset('assets/close.png',width: 15,height: 15,fit:BoxFit.cover)),
                    Padding(padding: EdgeInsets.only(),
                      child:Text('Hủy',style: TextStyle(fontSize: 14,color: Colors.white),) ,)
                  ],
                ),
                Container(
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
                Column(
                  children: [
                    GestureDetector(
                        onTap:(){
                          Navigator.of(context).pop();
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
    );
  }
}
