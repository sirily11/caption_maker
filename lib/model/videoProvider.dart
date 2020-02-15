import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:captions_maker/model/base_captions.dart';
import 'package:captions_maker/model/jsonOutput.dart';
import 'package:captions_maker/pages/home/captionList.dart';
import 'package:captions_maker/pages/settings/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:file_chooser/file_chooser.dart';

enum VideoState { edit, preview }

class VideoProvider with ChangeNotifier implements BaseCaptionMaker {
  VideoPlayerController controller;
  bool isPlaying = false;
  bool isSettingStartTime = true;
  ItemScrollController scrollController = ItemScrollController();
  Duration currentPosition = Duration(microseconds: 0);
  VideoState _state = VideoState.preview;
  List<BaseCaption> captions = [];
  BaseCaption currentCaption;
  BaseCaption prevCaption;
  int timeSpace = 800;
  bool _useStarttimeReplaceEndtime = true;

  set state(VideoState s) {
    _state = s;
    postProcessCaptions();
    notifyListeners();
  }

  VideoProvider() {
    SharedPreferences.getInstance().then((ins) async {
      timeSpace = ins.getInt("time_period") ?? timeSpace;
      _useStarttimeReplaceEndtime =
          ins.getBool("useStart") ?? _useStarttimeReplaceEndtime;
    });
  }

  VideoState get state => this._state;

  bool get useStarttimeReplaceEndtime => _useStarttimeReplaceEndtime;

  set useStarttimeReplaceEndtime(bool v) {
    _useStarttimeReplaceEndtime = v;
    notifyListeners();
  }

  Future<void> showSettings(BuildContext context) async {
    await showDialog(context: context, builder: (c) => SettingPage());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("useStart", _useStarttimeReplaceEndtime);
    await prefs.setInt("time_period", timeSpace);
  }

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

  /// If line 1's endtime is closer to line2's startime
  /// then use line2's starttime as line1's endtime
  void postProcessCaptions() {
    if (useStarttimeReplaceEndtime) {
      int i = 0;
      for (var caption in captions) {
        if (i < captions.length - 1) {
          if (captions[i + 1].starttime.inMilliseconds -
                  caption.endtime.inMilliseconds <
              timeSpace) {
            caption.endtime = captions[i + 1].starttime;
          }
        }

        i += 1;
      }
    }
  }

  Future<void> scrollTo(BaseCaption caption) async {
    int index = captions.indexWhere((element) => element.id == caption?.id);
    if (index > -1 && index < captions.length - 2) {
      await scrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 300),
      );
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

  Future<void> loadSaved() async {
    var result = await showOpenPanel(allowedFileTypes: ['json']);
    if (!result.canceled) {
      var file = File(result.paths.first);
      String content = await file.readAsString();
      List<dynamic> json = JsonDecoder().convert(content);
      captions = json.map((e) => BaseCaption.fromJson(e)).toList();
      notifyListeners();
    }
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
  Future<void> convertToFile(BaseCaptionOutput converter) async {
    await converter.output(captions);
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
              captions.removeWhere((element) => element.id == caption.id);
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
  Future<void> load() async {
    var result = await showOpenPanel(allowedFileTypes: ['txt']);
    if (!result.canceled) {
      String path = result.paths.first;
      var file = File(path);
      var content = await file.readAsString();
      var lines = content.split("\n");
      List<BaseCaption> cps = [];
      int i = 1;
      for (var line in lines) {
        if (line == "") {
          continue;
        }
        cps.add(
          BaseCaption(
            id: i,
            content: line,
            starttime: Duration(seconds: 0),
            endtime: Duration(seconds: 1),
          ),
        );
        i += 1;
      }
      captions = cps;
      notifyListeners();
    }
  }

  @override
  Future<void> save() async {
    await JSONOutput().output(captions);
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
