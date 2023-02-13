import 'package:alquran_flutter/app/constants/colors/color.dart';
import 'package:alquran_flutter/app/data/models/Juz.dart' as juz;
import 'package:alquran_flutter/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  const DetailJuzView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final juz.Juz detailjuz = Get.arguments["juz"];
    final List<Surah> allSurahInThisJuz = Get.arguments["surah"];

    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${detailjuz.juz}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: detailjuz.verses?.length ?? 0,
        itemBuilder: (context, index) {
          if (detailjuz.verses == null || detailjuz.verses?.length == 0) {
            return Center(
              child: Text("Tidak ada koneksi internet"),
            );
          }
          juz.Verses? ayat = detailjuz.verses?[index];

          if (index != 0) {
            if (ayat!.number?.inSurah == 1) {
              controller.index++;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: appPurpleTeen.withOpacity(0.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 40,
                            width: 40,
                            child:
                                Center(child: Text("${ayat?.number?.inSurah}")),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  Get.isDarkMode
                                      ? "assets/images/gold.png"
                                      : "assets/images/purple.png",
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            allSurahInThisJuz[controller.index]
                                    .name
                                    ?.transliteration
                                    ?.id ??
                                '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //  Play Audio
                          GetBuilder<DetailJuzController>(
                            builder: (c) => Row(
                              children: [
                                (ayat?.audioCondition == "playing")
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (ayat?.audioCondition == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(ayat!);
                                                  },
                                                  icon: Icon(Icons.pause))
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(ayat!);
                                                  },
                                                  icon: Icon(Icons.play_arrow)),
                                          IconButton(
                                              onPressed: () {
                                                c.stopAudio(ayat!);
                                              },
                                              icon: Icon(Icons.stop))
                                        ],
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          c.playAudio(ayat!);
                                        },
                                        icon: Icon(Icons.play_arrow),
                                      )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Text(
                "${ayat?.text?.arab}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "test",
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     color: appGrey,
              //     fontSize: 17,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Text(
                "${ayat?.translation?.id}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
    );
  }
}
