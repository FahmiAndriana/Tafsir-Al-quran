import 'package:alquran_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../../../constants/colors/color.dart';
import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Al-Quran Apps",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            Text(
              textAlign: TextAlign.center,
              "Sudah baca Al-Qurankah hari ini?",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 250,
              width: 250,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(25),
              //   color: appPurpleAdult,
              // ),
              // color: appPurpleAdult,
              child: Lottie.asset(
                "assets/lottie/reading-quran.json",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.HOME),
              child: Text(
                "Get Started",
                style: TextStyle(color: appWhite),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: appOrange,
                  padding: EdgeInsets.symmetric(
                    horizontal: 75,
                    vertical: 20,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
