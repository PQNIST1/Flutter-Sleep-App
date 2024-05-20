import 'package:flutter/material.dart';

import '../../themes.dart';
import '../../utils/globals.dart';
import '../home/bottomNavigator.dart';
import '../home/home_screen.dart';
import '../widgets/primary_btn.dart';
import 'package:lottie/lottie.dart';

Scaffold welcomeMobile(BuildContext context, double screenWidth) {
  return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/image_bg_welcome.png"),
          alignment: Alignment.center,
          fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Chào mừng đến với giấc ngủ",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 15, 48, 15),
                child: Center(
                  child: Text(
                    "Khám phá mới của giấc ngủ. Sử dụng âm thanh và hình ảnh để tạo điều kiện hoàn hảo cho giấc ngủ sảng khoái.",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          height: 1.8,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.centerRight,
                // child: Image(
                //   width: screenWidth * 0.8,
                //   image: const AssetImage("assets/image_bird_ilustration.png"),
                //   fit: BoxFit.cover,
                // ),
                    child: Lottie.asset('assets/sleep.json'),
              ),
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: PrimaryBtn(
                  label: "BẮT ĐẦU",
                  onPressed: () {
                    snackbarKey.currentState?.showSnackBar(const SnackBar(
                      content: Text("Chào mừng bạn!  ❤🤗"),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xff3253BD),
                    ));
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return  HomeScreen();
                    }), (route) => false);
                  },
                ),
              )
            ],
          ),
        ),
      ));
}
