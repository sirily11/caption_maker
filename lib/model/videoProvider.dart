import 'dart:convert';
import 'dart:io';

import 'package:captions_maker/model/base_captions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_chooser/file_chooser.dart';

class VideoProvider with ChangeNotifier implements BaseCaptionMaker {
  VideoPlayerController controller;
  bool isPlaying = false;
  Duration currentPosition = Duration(microseconds: 0);
  List<BaseCaption> captions = [
    BaseCaption(
      id: 0,
      content: "Hello",
      starttime: Duration(seconds: 0),
      endtime: Duration(seconds: 10),
    ),
    BaseCaption(
      id: 1,
      content: "Hello1",
      starttime: Duration(seconds: 10),
      endtime: Duration(seconds: 20),
    )
  ];
  BaseCaption currentCaption;

  /// Open Video File
  Future<void> openFile() async {
    var response = await showOpenPanel();
    if (!response.canceled) {
      String path = response.paths.first;
      path = Uri.encodeFull(path);
      controller = VideoPlayerController.file(File(path));
      await controller.initialize();
      controller.addListener(() async {
        isPlaying = controller.value.isPlaying;
        currentPosition = await controller.position;
        currentCaption = getCurrentCaption(currentPosition);
        notifyListeners();
      });
      notifyListeners();
    }
  }

  /// Play video
  Future<void> play() async {
    await controller?.play();
  }

  /// Pause video
  Future<void> pause() async {
    await controller?.pause();
  }

  /// Seek video
  Future<void> seek(Duration time) async {
    await controller?.seekTo(time);
  }

  @override
  Future<void> addCaption(BaseCaption caption) async {
    captions.add(caption);
    notifyListeners();
  }

  @override
  Future<void> convertToFile(BaseCaptionOutput converter) {
    // TODO: implement convertToFile
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCaption(BaseCaption caption) async {
    captions.remove(caption);
  }

  @override
  BaseCaption getCurrentCaption(Duration current) {
    BaseCaption caption = captions.firstWhere(
        (e) =>
            e.starttime.inMilliseconds <= current.inMilliseconds &&
            e.endtime.inMilliseconds >= current.inMilliseconds,
        orElse: () => null);
    if (caption != null) {
      return caption;
    }
    return null;
  }

  @override
  Future<void> load() {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<void> save() {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> setCaption({
    @required BaseCaption caption,
    Duration starttime,
    Duration endtime,
    String content,
  }) async {
    if (starttime != null) {
      caption.starttime = starttime;
    }
    if (endtime != null) {
      caption.endtime = endtime;
    }
    if (content != null) {
      caption.content = content;
    }
    notifyListeners();
  }
}
