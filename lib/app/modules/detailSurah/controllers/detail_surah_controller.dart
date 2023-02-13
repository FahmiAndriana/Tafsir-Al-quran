import 'dart:convert';

import 'package:alquran_flutter/app/constants/colors/color.dart';
import 'package:alquran_flutter/app/data/db/bookmark.dart';
import 'package:alquran_flutter/app/data/models/detailSurah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DetailSurahController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();
  final player = AudioPlayer();
  Future<DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/$id");
    var res = await http.get(url);
    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)["data"];

    // print(data);

    return DetailSurah.fromJson(data);
  }

  // Audio Start
  Verse? lastVerse;
  void pauseAudio(Verse ayat) async {
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

  void resumeAudio(Verse ayat) async {
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

  void stopAudio(Verse ayat) async {
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

  void playAudio(Verse? ayat) async {
    if (ayat?.audio.primary != null) {
      try {
        if (lastVerse == null) {
          lastVerse = ayat;
        }
        lastVerse!.audioCondition = "stop";
        lastVerse = ayat; //kondisi ketika sudah ada audio yg diputar
        lastVerse!.audioCondition = "stop";
        update();
        await player.stop();
        await player.setUrl(ayat!.audio.primary);
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
  // Audio End

  //Bookmark Start
  bool flagExist = false;
  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
      bool lastRead, DetailSurah? surah, Verse? ayat, int? indexAyat) async {
    Database db = await database.db;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query("bookmark",
          columns: [
            "surah",
            "number_surah",
            "ayat",
            "juz",
            "via",
            "index_ayat",
            "last_read"
          ],
          where:
              "surah = '${surah?.name?.transliteration.id.replaceAll("'", "+")}' and number_surah = ${surah!.number} and ayat = ${ayat?.number.inSurah} and juz = ${ayat?.meta.juz} and via = 'surah' and index_ayat = $indexAyat and last_read = 0");
      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert(
        "bookmark",
        {
          "surah": surah!.name!.transliteration.id.replaceAll("'", "+"),
          "number_surah": surah.number!,
          "ayat": ayat!.number.inSurah,
          "juz": ayat.meta.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead == true ? 1 : 0,
        },
      );

      Get.back();
      Get.snackbar("Berhasil", "Berhasil Menyimpan ayat", colorText: appWhite);
    } else {
      Get.back();
      Get.snackbar("Gagal", "Gagal Menyimpan ayat", colorText: appWhite);
    }

    var data = await db.query("bookmark");
    print(data);
  }
}
