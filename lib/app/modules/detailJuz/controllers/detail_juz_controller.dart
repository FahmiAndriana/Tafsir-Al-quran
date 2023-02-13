import 'package:alquran_flutter/app/constants/colors/color.dart';
import 'package:alquran_flutter/app/data/db/bookmark.dart';
import 'package:alquran_flutter/app/data/models/Juz.dart';
import 'package:alquran_flutter/app/data/models/detailSurah.dart';
// import 'package:alquran_flutter/app/data/models/detailSurah.dart' as surah;
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';

class DetailJuzController extends GetxController {
  int index = 0;
  final player = AudioPlayer();
  Verses? lastVerse;

  void playAudio(Verses ayat) async {
    if (ayat.audio?.primary != null) {
      try {
        lastVerse ??= ayat;
        lastVerse!.audioCondition = "stop";
        lastVerse = ayat; //kondisi ketika sudah ada audio yg diputar
        lastVerse!.audioCondition = "stop";
        update();
        await player.stop();
        await player.setUrl("${ayat.audio!.primary}");
        ayat.audioCondition = "playing";
        update();
        await player.play();
        ayat.audioCondition = "stop";
        await player.stop();
        update();
      } on PlayerException catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: e.message.toString(),
        );

        // print("Error code: ${e.code}");

        // print("Error message: ${e.message}");
      } on PlayerInterruptedException catch (e) {
        // print("Connection aborted: ${e.message}");
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message}",
        );
      } catch (e) {
        // print('An error occured: $e');
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "An error occured: $e",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Audio tidak ditemukan",
      );
    }
  }

  void pauseAudio(Verses ayat) async {
    try {
      await player.pause();
      ayat.audioCondition = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      // print('An error occured: $e');
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "An error occured: $e",
      );
    }
  }

  void resumeAudio(Verses ayat) async {
    try {
      ayat.audioCondition = "playing";
      update();
      await player.play();
      ayat.audioCondition = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      // print('An error occured: $e');
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "An error occured: $e",
      );
    }
  }

  void stopAudio(Verses ayat) async {
    try {
      await player.stop();
      ayat.audioCondition = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      // print('An error occured: $e');
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "An error occured: $e",
      );
    }
  }

  bool flagExist = false;
  DatabaseManager database = DatabaseManager.instance;
}
