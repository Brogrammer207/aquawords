import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import '../model/home_model.dart';
import 'package:flutter/services.dart';

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
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.menu),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          PageView(
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
                            CircularProgressIndicator()); // Show a loading indicator while data is being fetched
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
          // Add buttons
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Button 1 action
                      },
                      child: const Text('Button 1'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Button 2 action
                      },
                      child: const Text('Button 2'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Button 2 action
                      },
                      child: const Text('Button 2'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Button 3 action
                      },
                      child: const Text('Button 3'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Button 4 action
                      },
                      child: const Text('Button 4'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Button 2 action
                      },
                      child: const Text('Button 2'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Button 5 action
                      },
                      child: const Text('Button 5'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Button 6 action
                      },
                      child: const Text('Button 6'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Button 2 action
                      },
                      child: const Text('Button 2'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
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
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 375, // Adjust the height as needed
                            child: _buildContent(widget.item),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Button 2 action
                                },
                                child: const Text('share'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Button 2 action
                                },
                                child: const Text('download'),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Button 2 action
                            },
                            child: const Text('Change Your Profile'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Change color as needed
            ),
            child: Center(
              child: Image.asset('assets/images/logo.png')
              ),
            ),
          ),
        const Positioned(
          bottom: 16.0,
          right: 20.0,
          child: Text(
            'Your Text', // Add your text here
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
        ),
      ],
    );
  }

  void _shareContent(HomeItemData item) async {
    // Capture the current state of the widget
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8List = byteData.buffer.asUint8List();

    // Create an image from the Uint8List
    img.Image finalImage = img.decodeImage(uint8List)!;

    // Add the circle image to the final image
    img.Image circleImage = img.decodeImage((await rootBundle.load('assets/images/logo.png')).buffer.asUint8List())!;
    img.drawImage(finalImage, circleImage);

    // Add text to the final image
    final painter = ui.Paint()
      ..color = ui.Colors.black
      ..strokeWidth = 5.0
      ..strokeCap = ui.StrokeCap.butt;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, Rect.fromPoints(ui.Offset(0.0, 0.0), ui.Offset(500.0, 500.0)));
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
      ellipsis: '...',
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(ui.TextStyle(color: ui.Colors.black))
      ..addText('Your Text'); // Replace with your text
    final paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 500.0));
    canvas.drawParagraph(paragraph, ui.Offset(150.0, 0.0));

    // Convert the text canvas to an image
    final textImage = await recorder.endRecording().toImage(500, 50);
    final ByteData textByteData = await textImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List textUint8List = textByteData.buffer.asUint8List();
    img.Image textImageDecoded = img.decodeImage(textUint8List)!;
    img.drawImage(finalImage, textImageDecoded);

    // Share the final image
    Share.shareFiles(['final_image.png'], text: 'Check out this awesome content!');
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
