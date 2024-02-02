import 'dart:io';
import 'package:aquawords/screens/purchaseScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

import '../model/home_model.dart';
import 'package:flutter/services.dart';

import '../model/profile.dart';
import 'chooseYourPurposeScreen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  bool fullscreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AquaWords'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Text(
              'Create',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.menu));
        }),
      ),
      drawer: Drawer(
        width: 230,
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ), //BoxDecoration
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 50,
              ),
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('About Us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.question_mark),
              title: const Text('Change Profile'),
              onTap: () {
                Get.to(const AddProfileScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Contact Us '),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          SizedBox(
            height: 550,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                StreamBuilder<List<HomeItemData>>(
                  stream: getHomeItemStreamFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                              CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<HomeItemData> users = snapshot.data ?? [];
                      return PageView.builder(
                        itemCount: users.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return SinglePage(item: users[index]);
                        },
                      );
                    }
                  },
                ),
                // Add more pages as needed
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: List.generate(
                10,
                (index) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.purple, width: 1),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("datadee${index}"),
                          )),
                    )),
          ),
        ),
      ),
    );
  }
}

class SinglePage extends StatefulWidget {
  SinglePage({
    Key? key,
    required this.item,
  }) : super(key: key);

  final HomeItemData item;

  @override
  State<SinglePage> createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  bool fullscreen = false;
  final GlobalKey globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  List<Uint8List> capturedScreenshots = [];
  Future<void> _saveScreenshot() async {
    try {
      final directory = await getExternalStorageDirectory();

      if (directory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('External storage not available.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      File file = File('${directory.path}/screenshot.png');

      screenshotController.capture().then((Uint8List? image) async {
        if (image != null) {
          await file.writeAsBytes(image.toList());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Screenshot saved successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save screenshot.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Profile? profile;
  void getData() {
    FirebaseFirestore.instance
        .collection('Profile')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) {
      if (value.exists) {
        profile = Profile.fromMap(value.data()!);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 375, // Adjust the height as needed
                        child: Screenshot(
                            controller: screenshotController,
                            child: Container(
                                color: Colors.white,
                                child: _buildContent(widget.item))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xff132137))),
                            onPressed: () {
                               if(widget.item.isVideo == false){
                                 screenshotController
                                     .capture()
                                     .then((value) async {
                                   if (value == null) return;

                                   final item = await getTemporaryDirectory();
                                   File file = File(item.path + "/screenshot.png");
                                   file.createSync();
                                   await file.writeAsBytes(value!.toList());
                                   Share.shareFiles([file.path],
                                       text: 'Check out my captured image!');
                                 });
                               }else{
                                 Get.to( PurchaseScreen(videolink: widget.item.image,));
                               }

                            },
                            child: const Text(
                              'Share',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.green)),
                            onPressed: () async {
                              await _saveScreenshot();
                            },
                            child: const Text(
                              'download',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {
                          Get.to(const AddProfileScreen());
                        },
                        child: const Text(
                          'Change Your Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeItemData item) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (item.isVideo)
          YoYoPlayer(
            aspectRatio: 16 / 9,
            url:
                // 'https://dsqqu7oxq6o1v.cloudfront.net/preview-9650dW8x3YLoZ8.webm',
                // "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            //"https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8",
            allowCacheFile: true,
            onCacheFileCompleted: (files) {
              print('Cached file length ::: ${files?.length}');

              if (files != null && files.isNotEmpty) {
                for (var file in files) {
                  print('File path ::: ${file.path}');
                }
              }
            },
            onCacheFileFailed: (error) {
              print('Cache file error ::: $error');
            },
            videoStyle: const VideoStyle(
              fullscreenIcon: Icon(
                Icons.fullscreen,
                color: Colors.black,
              ),
              qualityStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              forwardAndBackwardBtSize: 30.0,
              forwardIcon: Icon(
                Icons.skip_next_outlined,
                color: Colors.black,
              ),
              backwardIcon: Icon(
                Icons.skip_next_outlined,
                color: Colors.black,
              ),
              playButtonIconSize: 40.0,
              playIcon: Icon(
                Icons.play_circle,
                size: 40.0,
                color: Colors.black,
              ),
              pauseIcon: Icon(
                Icons.remove_circle_outline_outlined,
                size: 40.0,
                color: Colors.black,
              ),
              videoQualityPadding: EdgeInsets.all(5.0),
              showLiveDirectButton: true,
              enableSystemOrientationsOverride: false,
            ),
            videoLoadingStyle: const VideoLoadingStyle(
              loading: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/progress.gif'),
                      fit: BoxFit.fitHeight,
                      height: 50,
                    ),
                    SizedBox(height: 16.0),
                    Text("Loading video..."),
                  ],
                ),
              ),
            ),
            videoPlayerOptions:
                VideoPlayerOptions(allowBackgroundPlayback: true),
            autoPlayVideoAfterInit: false,
            onFullScreen: (value) {
              setState(() {
                if (fullscreen != value) {
                  fullscreen = value;
                }
              });
            },
          )
        else
          Positioned(
            bottom: 70.0,
            left: 0,
            right: 0,
            top: 0,
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
        Positioned(
          bottom: 2.0,
          left: 16.0,
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage(profile?.image.toString() ??
                      'https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_640.png'),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 20.0,
          child: Text(
            profile?.name ?? 'Default Name',
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
        ),
      ],
    );
  }
}

Stream<List<HomeItemData>> getHomeItemStreamFromFirestore() {
  return FirebaseFirestore.instance.collection('homevideo').snapshots().map(
    (querySnapshot) {
      List<HomeItemData> itemmenu = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data() as Map;
          itemmenu.add(HomeItemData(
            name: gg['name'],
            des: gg['des'],
            image: gg['image'],
            date: gg['date'],
            isVideo: gg['isVideo'],
            category: gg['category'],
            docid: doc.id,
          ));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return itemmenu;
    },
  );
}
