import 'package:alquran_flutter/app/constants/colors/color.dart';
import 'package:alquran_flutter/app/data/models/detailSurah.dart' as detail;
import 'package:alquran_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:get/get.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  DetailSurahView({Key? key}) : super(key: key);
  Map<String, dynamic>? bookmark;
  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    // final Surah surah = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Surat ${Get.arguments["name"]}"),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        future: controller.getDetailSurah(Get.arguments["number"].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Tidak ada koneksi internet"),
            );
          }
          if (Get.arguments["bookmark"] != null) {
            bookmark = Get.arguments["bookmark"];
            // scroll to index
            if (bookmark!["ayat"] > 0) {
              controller.scrollC.scrollToIndex(
                bookmark!["ayat"] + 1,
                preferPosition: AutoScrollPosition.begin,
              );
            }
          }
          print(bookmark);

          detail.DetailSurah surah = snapshot.data!;

          List<Widget> allAyat =
              List.generate(snapshot.data?.verses.length ?? 0, (index) {
            detail.Verse? ayat = snapshot.data?.verses[index];
            return AutoScrollTag(
              key: ValueKey(index + 2),
              index: index + 2,
              controller: controller.scrollC,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: appPurpleTeen.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
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
                            child: Center(child: Text("${index + 1}")),
                          ),
                          GetBuilder<DetailSurahController>(
                            builder: (c) => Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Bookmark",
                                      middleText: "Pilih bookmark!",
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await c.addBookmark(true,
                                                snapshot.data!, ayat!, index);
                                            homeC.update();
                                          },
                                          child: Text("Last read"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: appOrange,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            c.addBookmark(false, snapshot.data!,
                                                ayat!, index);
                                          },
                                          child: Text("Simpan"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: appOrange,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  icon: const Icon(Icons.bookmark_add_outlined),
                                ),
                                (ayat?.audioCondition == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          c.playAudio(ayat);
                                        },
                                        icon: const Icon(Icons.play_arrow),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (ayat?.audioCondition == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(ayat!);
                                                  },
                                                  icon: const Icon(Icons.pause),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(ayat!);
                                                  },
                                                  icon: const Icon(
                                                      Icons.play_arrow),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              c.stopAudio(ayat!);
                                            },
                                            icon: const Icon(Icons.stop),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "${ayat?.text.arab}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ayat!.text.transliteration.en,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: appGrey,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ayat.translation.id,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          });

          return ListView(
            controller: controller.scrollC,
            padding: const EdgeInsets.all(15),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: GestureDetector(
                  onTap: () => Get.defaultDialog(
                    title: "Tafsir Surat ${surah.name?.transliteration.id}",
                    titleStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    content: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        surah.tafsir?.id ?? 'Tidak ada Tafsir',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          appPurpleTeen,
                          appPurpleOld,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "${surah.name!.transliteration.id}",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: appWhite),
                          ),
                          Text(
                            "( ${surah.name!.translation.id} )",
                            style: TextStyle(fontSize: 14, color: appWhite),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "${surah.numberOfVerses} Ayat | ${surah.revelation!.id}",
                            style: TextStyle(fontSize: 12, color: appWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: SizedBox(
                  height: 20,
                ),
              ),
              ...allAyat,
            ],
          );
        },
      ),
    );
  }
}
