import 'package:captions_maker/model/videoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart' as FlutterVideoPlayer;

class VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of(context);
    if (provider.controller == null || !provider.controller.value.initialized) {
      return Container(
        color: Colors.black,
      );
    }

    return Container(
      child: AspectRatio(
        aspectRatio: provider.controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            FlutterVideoPlayer.VideoPlayer(provider.controller),
            Positioned.fill(
              bottom: 0,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Slider(
                      value: provider.currentPosition.inMilliseconds.toDouble(),
                      onChangeEnd: (v) async {
                        await provider.play();
                      },
                      onChangeStart: (v) async {
                        await provider.pause();
                      },
                      onChanged: (v) async {
                        await provider.seek(Duration(milliseconds: v.toInt()));
                      },
                      max: provider.controller?.value?.duration?.inMilliseconds
                              ?.toDouble() ??
                          0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
