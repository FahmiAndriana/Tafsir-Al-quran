import 'package:alquran_tafsir/app/constants/colors/color.dart';
import 'package:alquran_tafsir/app/data/models/Juz.dart' as juz;

import 'package:alquran_tafsir/app/data/models/surah.dart';
import 'package:alquran_tafsir/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Al Quran Apps'),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {}, //Get.toNamed(Routes.SEARCH),
              icon: const Icon(Icons.search_sharp),
              color: controller.isDark.isFalse ? appPurpleAdult : appWhite,
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              const Text(
                "Selamat Datang",
              ),
              const Text(
                "بسم الله الرحمن الرحيم",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GetBuilder<HomeController>(
                builder: (c) => FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastread(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                            colors: [
                              appPurpleTeen,
                              appPurpleOld,
                            ],
                          ),
                        ),
                        child: Container(
                          height: 140,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -50,
                                right: -40,
                                child: Container(
                                  height: 220,
                                  width: 220,
                                  child: Lottie.asset(
                                      "assets/lottie/reading-quran.json",
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.menu_book_sharp,
                                          color: appWhite,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Terakhir dibaca",
                                          style: TextStyle(color: appWhite),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    const Text(
                                      "Loading...",
                                      style: TextStyle(
                                        color: appWhite,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Text(
                                      "",
                                      style: TextStyle(color: appWhite),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    Map<String, dynamic>? lastRead = snapshot.data;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          // begin: Alignment.topCenter,
                          // end: Alignment.bottomCenter,
                          colors: [
                            appPurpleTeen,
                            appPurpleOld,
                          ],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                title: "Hapus Terakhir dibaca",
                                middleText:
                                    "Yakin ingin menghapus Terakhir dibaca?",
                                actions: [
                                  OutlinedButton(
                                      onPressed: () => Get.back(),
                                      child: Text("Cancel")),
                                  OutlinedButton(
                                      onPressed: () {
                                        controller
                                            .deleteBookmark(lastRead['id']);
                                        Get.back();
                                      },
                                      child: Text("Hapus"))
                                ],
                              );
                            }
                            ;
                          },
                          onTap: () async {
                            if (lastRead != null) {
                              Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                "name": lastRead["surah"]
                                    .toString()
                                    .replaceAll("+", "'"),
                                "number": lastRead["number_surah"],
                                "bookmark": lastRead,
                              });

                              print(lastRead);
                            }
                            ;
                          },
                          child: SizedBox(
                            height: 140,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: -50,
                                  right: -40,
                                  child: SizedBox(
                                    height: 220,
                                    width: 220,
                                    child: Lottie.asset(
                                        "assets/lottie/reading-quran.json",
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.menu_book_sharp,
                                            color: appWhite,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Terakhir dibaca",
                                            style: TextStyle(color: appWhite),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Text(
                                        lastRead == null
                                            ? ""
                                            : lastRead['surah']
                                                .toString()
                                                .replaceAll("+", "'"),
                                        style: const TextStyle(
                                          color: appWhite,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        lastRead == null
                                            ? "Belum ada data"
                                            : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                        style: const TextStyle(color: appWhite),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TabBar(
                indicatorColor: appPurpleAdult,
                tabs: [
                  Tab(
                    text: "Surat",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "BookMark",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Surah>?>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak koneksi internet"),
                          );
                        }
                        return Center(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Surah surah = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                    "name": surah.name!.transliteration!.id,
                                    "number": surah.number!,
                                  });
                                },
                                leading: Obx(
                                  () => Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                      child: Text(
                                        "${surah.number}",
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            controller.isDark.isTrue
                                                ? "assets/images/gold.png"
                                                : "assets/images/purple.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${surah.name!.transliteration!.id}",
                                ),
                                subtitle: Text(
                                  "${surah.numberOfVerses} Ayat | ${surah.revelation!.id}",
                                  style: const TextStyle(color: appGrey),
                                ),
                                trailing: Text(
                                  "${surah.name?.short}",
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    FutureBuilder<List<juz.Juz>?>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak koneksi internet"),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            juz.Juz detailjuz = snapshot.data![index];

                            String nameStart =
                                detailjuz.juzStartInfo?.split(" - ").first ??
                                    "";
                            String nameEnd =
                                detailjuz.juzEndInfo?.split(" - ").first ?? "";

                            List<Surah> rawAllSurahInJuz = [];
                            List<Surah> allSurahInJuz = [];

                            for (Surah item in controller.allSurah) {
                              rawAllSurahInJuz.add(item);
                              if (item.name!.transliteration!.id == nameEnd) {
                                break;
                              }
                            }
                            for (Surah item
                                in rawAllSurahInJuz.reversed.toList()) {
                              allSurahInJuz.add(item);
                              if (item.name!.transliteration!.id == nameStart) {
                                break;
                              }
                            }

                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                                  "juz": detailjuz,
                                  "surah": allSurahInJuz.reversed.toList(),
                                });
                              },
                              leading: Obx(
                                () => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(controller.isDark.isTrue
                                          ? "assets/images/gold.png"
                                          : "assets/images/purple.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${index + 1}",
                                      // style: TextStyle(
                                      //   color: controller.isDark.isFalse
                                      //       ? appWhite
                                      //       : appPurpleAdult,
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              subtitle: Text(
                                "${detailjuz.juzStartInfo} - ${detailjuz.juzEndInfo}",
                                style: const TextStyle(color: appGrey),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    // const Text("Hallo")

                    // bookmark

                    GetBuilder<HomeController>(
                      builder: (c) {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: c.getBookmark(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            // ignore: prefer_is_empty
                            if (snapshot.data?.length == 0) {
                              return const Center(
                                child: Text("Data belum tersedia"),
                              );
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data![index];
                                return ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.DETAIL_SURAH,
                                          arguments: {
                                            "name": data["surah"]
                                                .toString()
                                                .replaceAll("+", "'"),
                                            "number": data["number_surah"],
                                            "bookmark": data,
                                          });
                                      c.update();
                                    },
                                    leading: Obx(
                                      () => Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(controller
                                                    .isDark.isTrue
                                                ? "assets/images/gold.png"
                                                : "assets/images/purple.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${index + 1}",
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(data['surah']
                                        .toString()
                                        .replaceAll("+", "'")),
                                    subtitle: Text(
                                      "Ayat ${data['ayat']} - via ${data['via']}",
                                      style: const TextStyle(
                                        color: appGrey,
                                      ),
                                    ),
                                    trailing: Obx(
                                      () => IconButton(
                                        onPressed: () {
                                          c.deleteBookmark(data['id']);
                                        },
                                        // ignore: prefer_const_constructors
                                        icon: Icon(Icons.delete),
                                        color: controller.isDark.isFalse
                                            ? appPurpleAdult
                                            : appWhite,
                                      ),
                                    ));
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.changeThemeMode(),
        child: const Icon(Icons.color_lens_outlined),
      ),
    );
  }
}
