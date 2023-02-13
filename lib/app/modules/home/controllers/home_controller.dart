import 'package:alquran_flutter/app/constants/colors/color.dart';
import 'package:alquran_flutter/app/data/db/bookmark.dart';
import 'package:alquran_flutter/app/data/models/Juz.dart';
import 'package:alquran_flutter/app/data/models/surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  RxBool isDark = false.obs;
  DatabaseManager database = DatabaseManager.instance;

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);
    isDark.toggle();

    final box = GetStorage();

    if (Get.isDarkMode) {
      box.remove("themeDark");
    } else {
      box.write("themeDark", true);
    }
  }

  Future<List<Surah>?> getAllSurah() async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah");
    var res = await http.get(url);
    List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];

    if (data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      Uri url = Uri.parse("https://api.quran.gading.dev/juz/$i");
      var res = await http.get(url);
      Map<String, dynamic> data =
          (jsonDecode(res.body) as Map<String, dynamic>)["data"];

      Juz juz = Juz.fromJson(data);
      allJuz.add(juz);
      // print(allJuz.length);
    }
    return allJuz;
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allbookmarks = await db.query(
      "bookmark",
      where: "last_read = 0",
    );
    return allbookmarks;
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
    update();
    Get.snackbar("Berhasil!", "Bookmark berhasil dihapus!");
    Get.back();
  }

  Future<Map<String, dynamic>?> getLastread() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastread = await db.query(
      "bookmark",
      where: "last_read = 1",
    );

    if (dataLastread.isEmpty) {
      return null;
    } else {
      return dataLastread.first;
    }
  }
}
