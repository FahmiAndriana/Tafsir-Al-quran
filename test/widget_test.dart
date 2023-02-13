import 'dart:convert';

import 'package:alquran_flutter/app/data/models/detailAyat.dart';
import 'package:alquran_flutter/app/data/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  // Uri url = Uri.parse("https://api.quran.gading.dev/surah");
  // var res = await http.get(url);

  // List data = (jsonDecode(res.body) as Map<String, dynamic>)['data'];

  // Surah surahAnnas = Surah.fromJson(data[113]);

  Uri url = Uri.parse("https://api.quran.gading.dev/surah/1/1");
  var res = await http.get(url);

  Map<String, dynamic> data = jsonDecode(res.body)['data'];

  Map<String, dynamic> dataModel = {
    "number": data['number'],
    "meta": data['meta'],
    "text": data['text'],
    "translation": data['translation'],
    "audio": data['audio'],
    "tafsir": data['tafsir'],
  };

  DetailAyat ayat = DetailAyat.fromJson(dataModel);
}
