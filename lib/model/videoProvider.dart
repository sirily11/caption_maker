import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:captions_maker/model/base_captions.dart';
import 'package:captions_maker/pages/home/captionList.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_chooser/file_chooser.dart';

enum VideoState { edit, preview }

class VideoProvider with ChangeNotifier implements BaseCaptionMaker {
  VideoPlayerController controller;
  bool isPlaying = false;
  bool isSettingStartTime = true;
  ScrollController scrollController = ScrollController();
  Duration currentPosition = Duration(microseconds: 0);
  VideoState _state = VideoState.preview;
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
  BaseCaption prevCaption;

  set state(VideoState s) {
    _state = s;
    notifyListeners();
  }

  VideoState get state => this._state;

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
        if (state == VideoState.preview) {
          currentCaption = getCurrentCaption(currentPosition);
          await scrollTo(currentCaption);
        }

        notifyListeners();
      });
      notifyListeners();
    }
  }

  Future<void> scrollTo(BaseCaption caption) async {
    int index = captions.indexWhere((element) => element.id == caption?.id);
    if (index > -1) {
      double offset = index * CAPTION_ROW_HEIGHT;
      offset = min(offset, scrollController.position.maxScrollExtent);
      if (offset != scrollController.offset) {
        await scrollController.animateTo(offset,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      }
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
    isSettingStartTime = true;
    if (currentCaption == null) {
      currentCaption = getCurrentCaption(time) ?? captions[0];
    }
    notifyListeners();
  }

  Future<void> back5Sec() async {
    await this.seek(
      Duration(milliseconds: currentPosition.inMilliseconds - 5000),
    );
  }

  Future<void> forward5Sec() async {
    await this.seek(
      Duration(milliseconds: currentPosition.inMilliseconds + 5000),
    );
  }

  void setCurrentCaption(BaseCaption caption) {
    currentCaption = caption;
    isSettingStartTime = true;
    notifyListeners();
  }

  /// Set [time] to [currentCaption] when set button be clicked
  Future<void> setTime() async {
    if (currentCaption == null) {
      return;
    }
    if (isSettingStartTime) {
      currentCaption.starttime = currentPosition;
      isSettingStartTime = false;
    } else {
      currentCaption.endtime = currentPosition;
      isSettingStartTime = true;
      prevCaption = currentCaption;
      currentCaption = null;
    }
    if (isSettingStartTime) {
      int prevIndex = captions.indexWhere((element) => element == prevCaption);
      if (prevIndex > -1 && prevIndex < captions.length - 1) {
        currentCaption = captions[prevIndex + 1];
        await scrollTo(currentCaption);
        notifyListeners();
      } else {
        return;
      }
    }

    notifyListeners();
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
  Future<void> deleteCaption(BaseCaption caption, BuildContext context) async {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("Delete Caption?"),
        content: Text("You cannot undo this action"),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              captions.remove(caption);
              notifyListeners();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
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
